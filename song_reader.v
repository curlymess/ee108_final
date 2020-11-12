`define SONG_WIDTH 5
`define NOTE_WIDTH 6
`define DURATION_WIDTH 6

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define SWIDTH 3
`define PAUSED             3'b000
`define WAIT               3'b001
`define INCREMENT_ADDRESS  3'b010
`define RETRIEVE_NOTE      3'b011
`define NEW_NOTE_READY     3'b100


module song_reader(
    input clk,
    input reset,
    input wire play,
    input [1:0] song,
    input note_done,
    input beat,
    output wire song_done,
    output wire [5:0] note,
    output wire [5:0] duration,
    output wire new_note,
    output wire activate,
    output wire [2:0] parameters
);

    wire [`SONG_WIDTH-1:0] curr_note_num, next_note_num;
    wire [15:0] rom_out;
    wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num};

    wire [`SWIDTH-1:0] state;
    reg  [`SWIDTH-1:0] next;

    // For identifying when we reach the end of a song
    wire overflow;

    dffr #(`SONG_WIDTH) note_counter (
        .clk(clk),
        .r(reset),
        .d(next_note_num),
        .q(curr_note_num)
    );
    dffr #(`SWIDTH) fsm (
        .clk(clk),
        .r(reset),
        .d(next),
        .q(state)
    );
    
    //Counter
    wire [5:0] duration2;
    wire  [5:0] next_count;
    wire [5:0] count;
//    dffr#(6) SR_counter (
//        .clk(clk),
//        .r(reset),
//        .d(next_count),
//        .q(count)
//    );
dffre #(.WIDTH(6)) SR_counter (
   .clk(clk),
   .r(reset),
   .en(beat && play),
   .d(next_count),
   .q(count)
);
assign duration = rom_out[8:3];
assign duration2 = rom_out[15] ? duration : 6'b000000;
assign next_count = (count != 6'd0) ? count - 1 : duration2;
    
song_rom rom(.clk(clk), .addr(rom_addr), .dout(rom_out));
    
 
//    always @(*) begin
//        if ( count != 6'd0 ) begin
//            next_count = count - 6'd1;
//        end else begin 
//            next_count = duration2;
//        end
//    end
    wire [1:0] SR_next_count2;
    wire [1:0] SR_count2;
dffre#(2) SR_counter2 (
    .clk(clk),
    .r(reset),
    .en(state ==3'b010),
    .d(SR_next_count2 ),
    .q(SR_count2)
);
assign SR_next_count2 = (SR_count2 == 2'd2) ? 0 : (SR_count2 + 2'd1);
    
//assign activate = (count !=0) ? 1:0;
    
    

    always @(*) begin
        case (state)
            `PAUSED:            next = play ? `RETRIEVE_NOTE : `PAUSED;
            `RETRIEVE_NOTE:     next = play ? `NEW_NOTE_READY : `PAUSED;
            `NEW_NOTE_READY:    next = play ? `WAIT: `PAUSED;
            `WAIT:              next = !play ? `PAUSED
                                             : (note_done) ? `INCREMENT_ADDRESS
                                                          : `WAIT;
            `INCREMENT_ADDRESS: next = (play && ~overflow) ? `RETRIEVE_NOTE
                                                           : `PAUSED;
            default:            next = `PAUSED;
        endcase
    end
    
    assign {overflow, next_note_num} =
        (state == `INCREMENT_ADDRESS) ? {1'b0, curr_note_num} + 1
                                      : {1'b0, curr_note_num};
                                      
    assign new_note = (state == `NEW_NOTE_READY);
    assign note = rom_out[14:9];
    assign duration = rom_out[8:3];
    assign activate = rom_out[15];
    //assign {note, duration} = rom_out;
    assign song_done = overflow;
    
    

endmodule
