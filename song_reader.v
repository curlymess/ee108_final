`define SONG_WIDTH 5
`define NOTE_WIDTH 6
`define DURATION_WIDTH 6

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define SWIDTH1 3
`define PAUSED             3'b000
`define WAIT               3'b001
`define CHANGE_ADDRESS     3'b010
`define RETRIEVE_NOTE      3'b011
`define NEW_NOTE_READY     3'b100


module song_reader(
    input clk,
    input reset,
    input wire play,
    input [1:0] song,
    input note_done,
    input activate_done,
    input ff_switch0,
    input r_switch1,
    output wire song_done,
    output wire [5:0] note,
    output wire [5:0] duration,
    output wire new_note,
    output wire activate
);

wire [`SONG_WIDTH - 1:0] curr_note_num, next_note_num;
wire [15:0] rom_out;
wire [`SONG_WIDTH + 1:0] rom_addr = {song, curr_note_num};

wire [`SWIDTH1-1:0] state;
reg  [`SWIDTH1-1:0] next;

// For identifying when we reach the end of a song
wire overflow;

 dffr #(`SONG_WIDTH) note_counter (
    .clk(clk),
    .r(reset),
    .d(next_note_num),
    .q(curr_note_num)
 );
 dffr #(`SWIDTH1) fsm (
    .clk(clk),
    .r(reset),
    .d(next),
    .q(state)
 );
  
song_rom rom(.clk(clk), .addr(rom_addr), .dout(rom_out));

always @(*) begin
    case (state)
       `PAUSED:            next = play ? `RETRIEVE_NOTE : `PAUSED;
       `RETRIEVE_NOTE:     next = play ? `NEW_NOTE_READY : `PAUSED;
       `NEW_NOTE_READY:    next = play ? `WAIT: `PAUSED;
       `WAIT:              next = !play ? `PAUSED : 
                                    (rom_out[15] ? activate_done : note_done) ? `CHANGE_ADDRESS : `WAIT;
       `CHANGE_ADDRESS:    next = (play && ~overflow) ? `RETRIEVE_NOTE : `PAUSED;
       default:            next = `PAUSED;
    endcase
end
    
assign {overflow, next_note_num} =
       (state == `CHANGE_ADDRESS) ? ({1'b0, curr_note_num} + 1): {1'b0, curr_note_num};
wire [5:0] duration_temp = rom_out[8:3];

/////// Outputs ///////                                     
assign new_note = (state == `NEW_NOTE_READY);
assign note = rom_out[14:9];
assign duration = (ff_switch0 || r_switch1) ? duration_temp >> 1 : duration_temp; // half the duration if ff or rewind
assign activate = rom_out[15];
assign song_done = overflow;

endmodule
