module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    input [1:0] weight,
    input ff_switch0,
    input r_switch1,
    output wire [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);

///
`define PLAY_ADDR       9'h000
`define PAUSE_ADDR      9'h008
`define NEXT_ADDR       9'h010
`define FF_ADDR         9'h018
`define REWIND_ADDR     9'h028
////
`define PLAY_X          11'd108
`define PAUSE_X         11'd116
`define NEXT_X          11'd124
`define FF_X            11'd132
`define REWIND_X        11'd140
///
`define START_ICONX     11'd825 // adjust to fit next
`define END_ICONX       11'd879
`define START_ICONY     10'd479
`define END_ICONY       10'd486
///
`define START_ICON_BOXX 11'd818 // adjust to fit next
`define END_ICON_BOXX   11'd864
`define START_ICON_BOXY 10'd475
`define END_ICON_BOXY   10'd492
///
`define W_ADDR          9'h0b8
`define E_ADDR          9'h030
`define I_ADDR          9'h048
`define G_ADDR          9'h038
`define H_ADDR          9'h040
`define T_ADDR          9'h0a0
////
`define W_X             11'd108
`define E_X             11'd116
`define I_X             11'd124
`define G_X             11'd132
`define H_X             11'd140
`define T_X             11'd148
////
`define START_WEIGHTX   11'd108
`define END_WEIGHTX     11'd156
`define START_WEIGHTY   10'd440
`define END_WEIGHTY     10'd447

wire read_address_changed; //we check that our address has changed and therefore we want to pass it into the RAM
wire moving_up; //we are in quadrants I and IV of the sine wave
wire make_white; //our current pixel should be white
	
assign read_address = {read_index, x[9], x[7:1]};
	
wire [8:0] prev_read_address; //to compare if we are changing (only happens every other cycle)
	
// This logic is only needed if adjustment is done for the 800x480 display
wire [7:0] read_value_adjusted = ({1'b0, read_value[7:1]}) + 8'd32;
wire [7:0] prev_read_value_adjusted;
	
wire [7:0] translated_y = y[8:1]; //current y coordinate
	
//stores read_address but only when the x and y coordinates correspond with a valid pixel
dffre #(9) change_flip_flop(.clk(clk), .r(reset), .en(valid), .d(read_address), .q(prev_read_address));
assign read_address_changed = (read_address != prev_read_address); //true when current and previous read_addresses are different
	
//stores the value gotten from RAM
dffre #(8) RAM_value_flip_flop(.clk(clk), .r(reset), .en(read_address_changed), .d(read_value_adjusted), .q(prev_read_value_adjusted));	

assign moving_up = (read_value_adjusted < prev_read_value_adjusted);    
assign make_white = (moving_up) ? 
                    ((prev_read_value_adjusted >= translated_y) & (read_value_adjusted <= translated_y)) : 
					((prev_read_value_adjusted <= translated_y) & (read_value_adjusted >= translated_y));

//// TCGROM ADDRESS ////
wire [7:0]  data;
reg  [8:0]  addr;
reg  [12:0] letter_start; // for use in pixel color setting
always @(*) begin
    if(valid && x <= `END_WEIGHTX && x >= `START_WEIGHTX && y <= `END_WEIGHTY && y >= `START_WEIGHTY) begin
        if ( x >= `T_X) begin
            addr = `T_ADDR + (y - `START_WEIGHTY);
            letter_start = `T_X;
        end else if ( x >= `H_X) begin
            addr = `H_ADDR + (y - `START_WEIGHTY);
            letter_start = `H_X;
        end else if ( x >= `G_X) begin
            addr = `G_ADDR + (y - `START_WEIGHTY);
            letter_start = `G_X;
        end else if ( x >= `I_X) begin
            addr = `I_ADDR + (y - `START_WEIGHTY);
            letter_start = `I_X;
        end else if ( x >= `E_X) begin
            addr = `E_ADDR + (y - `START_WEIGHTY);
            letter_start = `E_X;
        end else begin // W_X
            addr = `W_ADDR + (y - `START_WEIGHTY);
            letter_start = `W_X;
        end
    end else if(x <= `END_ICONX && x >= `START_ICONX && y <= `END_ICONY && y >= `START_ICONY) begin
         if ( x >= `REWIND_X) begin
            addr = `REWIND_ADDR + (y - `START_ICONY);
            letter_start = `REWIND_X;
        end else if ( x >= `FF_X) begin
            addr = `FF_ADDR + (y - `START_ICONY);
            letter_start = `FF_X;
        end else if ( x >= `PAUSE_X) begin
            addr = `PAUSE_ADDR + (y - `START_ICONY);
            letter_start = `PAUSE_X;
        end else begin
            addr = `PLAY_ADDR + (y - `START_ICONY);
            letter_start = `PLAY_X;
        end   
    end else begin
        addr = 9'd0;
        letter_start = 13'd0;
    end
end
tcgrom tcg(.addr(addr), .data(data));

//// PIXEL COLOR SETTING ////
reg valid_pixel_temp;	
reg [7:0] r_temp, g_temp, b_temp;
always @(*) begin
    // draw boxes for weight
    if(valid && x <= 11'd268 && x >= 11'd108 && y <= 10'd492 && y >= 10'd452) begin
	   if(weight == 2'd2 && x <= 11'd268 && x > 11'd188) begin
	       {r_temp, g_temp, b_temp} = 24'h0000FF;
           valid_pixel_temp = 1'b1;
	   end else if (weight != 2'd0 && x <= 11'd188 && x > 11'd108) begin
	       {r_temp, g_temp, b_temp} = 24'h00FF00;
           valid_pixel_temp = 1'b1;     
       end else begin
           {r_temp, g_temp, b_temp} = 24'h000000;
           valid_pixel_temp = 1'b1;
       end
    // draw WEIGHT
    end else if(valid && x <= `END_WEIGHTX && x >= `START_WEIGHTX && y <= `END_WEIGHTY && y >= `START_WEIGHTY) begin
	   {r_temp, g_temp, b_temp} = (data[letter_start + 11'd7 - x]) ? 24'hFF00FF : 24'h000000;
	   valid_pixel_temp = 1'b1;
	// draw icons
	end else if(valid && x <= `END_ICONX && x >= `START_ICONX && y <= `END_ICONY && y >= `START_ICONY) begin
	   {r_temp, g_temp, b_temp} = (data[letter_start + 11'd7 - x]) ? 24'h510031 : 24'hFFD1DC;
	   valid_pixel_temp = 1'b1;
	// draw icon box
	end else if(valid && x <= `END_ICON_BOXX && x >= `START_ICON_BOXX && y <= `END_ICON_BOXY && y >= `START_ICON_BOXY) begin
	   {r_temp, g_temp, b_temp} = 24'hFFD1DC;
	   valid_pixel_temp = 1'b1;
	// everything else
    end else begin
	   {r_temp, g_temp, b_temp} = reset ? (24'h000000) : ((make_white & valid_pixel) ? (24'hFFFFFF) : (24'h000000));
       valid_pixel_temp = (((x[10:8] == 3'b001) | (x[10:8] == 3'b010)) & (x > 11'b00100000010) & (y[9] == 1'b0) & valid);
    end
end
	
/// OUTPUTS ///
assign {r,g,b} = {r_temp, g_temp, b_temp};
assign valid_pixel = valid_pixel_temp;

endmodule
