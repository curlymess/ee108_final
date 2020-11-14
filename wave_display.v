module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    input [1:0] weight,
    output wire [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);

`define START_WADDR 9'h0b8
`define END_WADDR   9'h0bf
`define START_WX    11'd100
`define END_WX      11'd107
`define START_WY    10'd420
`define END_WY      10'd427

	wire read_address_changed; //we check that our address has changed and therefore we want to pass it into the RAM
	wire moving_up; //we are in quadrants I and IV of the sine wave
	wire make_white; //our current pixel should be white
	
	assign read_address = {read_index, x[9], x[7:1]};
	
	wire [8:0] prev_read_address; //to compare if we are changing (only happens every other cycle)
	
	// This logic is only needed if adjustment is done for the 800x480 display
	wire [7:0] read_value_adjusted = ({1'b0, read_value[7:1]}) + 8'd32;
	wire [7:0] prev_read_value_adjusted;
	//wire [7:0] prev_read_value;  //
	
	
	
	
	wire [7:0] translated_y = y[8:1]; //current y coordinate
	
	//stores read_address but only when the x and y coordinates correspond with a valid pixel
	dffre #(9) change_flip_flop(.clk(clk), .r(reset), .en(valid), .d(read_address), .q(prev_read_address));
	
	assign read_address_changed = (read_address != prev_read_address); //true when current and previous read_addresses are different
	
	//stores the value gotten from RAM
	dffre #(8) RAM_value_flip_flop(.clk(clk), .r(reset), .en(read_address_changed), .d(read_value_adjusted), .q(prev_read_value_adjusted));
	//dffre #(8) RAM_value_flip_flop(.clk(clk), .r(reset), .en(read_address_changed), .d(read_value), .q(prev_read_value));      // without adjustment
	
	
	assign moving_up = (read_value_adjusted < prev_read_value_adjusted);
//	assign moving_up = (read_value < prev_read_value);   // without adjustment
    
	
		
	//we want to make a pixel white if the y value falls within the range of the previous and current RAM values
	//we account for whether we are moving up or down
	//we also deal with the edge case where we are at the beginning of the display screen, so that we only
	//make the pixel at the given read_value white 
	assign make_white = (moving_up) ? 
	                    ((prev_read_value_adjusted >= translated_y) & (read_value_adjusted <= translated_y)) : 
						((prev_read_value_adjusted <= translated_y) & (read_value_adjusted >= translated_y));
    //assign make_white = (moving_up) ? ((prev_read_value >= translated_y) & (read_value <= translated_y)) : 
    //						((prev_read_value <= translated_y) & (read_value >= translated_y));         // without adjustment
    wire [7:0] data;
    wire [8:0] addr;
    assign addr = (y >= `START_WY) ? `START_WADDR + (y - `START_WY) : 9'd0;
    tcgrom tcg(.addr(addr), .data(data));

    reg valid_pixel_temp;

	//valid_pixel is true when we are in the middle two quadrants and the upper half of the display
	
	reg [7:0] r_temp, g_temp, b_temp;
	always @(*) begin
	   //draw boxes
	   if(valid && x <= 11'd400 && x >= 11'd200 && y <= 10'd480 && y >= 10'd420) begin
	       if(weight == 2'd2 && x <= 11'd400 && x > 11'd300 && y <= 10'd480 && y >= 10'd420) begin
	           {r_temp, g_temp, b_temp} = 24'h0000FF;
                valid_pixel_temp = 1'b1;
	       end else if (weight != 2'd0 && x <= 11'd300 && x > 11'd200 && y <= 10'd480 && y >= 10'd420) begin
	           {r_temp, g_temp, b_temp} = 24'h00FF00;
                valid_pixel_temp = 1'b1;     
           end else begin
               {r_temp, g_temp, b_temp} = 24'h000000;
                valid_pixel_temp = 1'b1;
           end
        //draw W
        end else if(valid && x <= `END_WX && x >= `START_WX && y <= `END_WY && y >= `START_WY) begin
	           {r_temp, g_temp, b_temp} = data[x - `START_WX] ? 24'hFF0000 : 24'h000000;
	           valid_pixel_temp = 1'b1;
        end else begin
	       {r_temp, g_temp, b_temp} = reset ? (24'h000000) : ((make_white & valid_pixel) ? (24'hFFFFFF) : (24'h000000));
            valid_pixel_temp = (((x[10:8] == 3'b001) | (x[10:8] == 3'b010)) & (x > 11'b00100000010) & (y[9] == 1'b0) & valid);
        end 
    end
	
	//sets the pixel to white if meets both the make_white and valid_pixel constraints. Always sets 
	//display to black when reset is high (ie the top button is pressed) 
	assign {r,g,b} = {r_temp, g_temp, b_temp};
    assign valid_pixel = valid_pixel_temp;

endmodule
