module note_player(
    input  clk,
    input  reset,
    input  play_enable,         // When high we play, when low we don't.
    input  [5:0] note_to_load,  // The note to play
    input  load_new_note,       // Tells us when we have a new note to load
	input  [1:0] weight,	
	input  note_done,	        // Informs create_harmonic how the weight of each harmony
    input  generate_next_sample,// Tells us when the codec wants a new sample
    output [15:0] harmonic_out, // Our sample output
    output harmonic_ready     	// Tells the codec when we've got a sample
);

//////////// GET STEP SIZE ////////////
    wire [5:0] freq_rom_in;
	wire [19:0] step_size;
	
    dffre #(.WIDTH(6)) np_freq_reg (
        .clk(clk),
        .r(reset),
        .en(load_new_note),
        .d(note_to_load),
        .q(freq_rom_in)
    );

    frequency_rom np_freq_rom(
        .clk(clk),
        .addr(freq_rom_in),
        .dout(step_size)
    );

wire [15:0] harmonic_out_temp;
wire harmonic_ready_temp;
//////////// CREATE HARMONCS ////////////     
create_harmonic ch1(
    .clk(clk),
    .reset(reset),
	.generate_next_sample(generate_next_sample),
	.play_enable(play_enable),
    .step_size(step_size),
    .note_done(note_done),
	.weight(weight),
    .harmonic_out(harmonic_out_temp),
	.sample_ready(harmonic_ready_temp)
    );


dffr #(.WIDTH(16)) out_delay (
   .clk(clk),
   .r(reset || note_done),
   .d(harmonic_out_temp),
   .q(harmonic_out)
);

dffr #(.WIDTH(1)) ready_delay (
   .clk(clk),
   .r(reset),
   .d(harmonic_ready_temp),
   .q(harmonic_ready)
);
	

endmodule
