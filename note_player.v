module note_player(
    input  clk,
    input  reset,
    input  play_enable,         // When high we play, when low we don't.
    input  [5:0] note_to_load,  // The note to play
    input  [5:0] duration,      // The duration of the note to play
    input  load_new_note,       // Tells us when we have a new note to load
    input  activate,            // Tells us if the counters should counting
    input  beat,                // This is our 1/48th second beat
    input  generate_next_sample,// Tells us when the codec wants a new sample
    output [17:0] sample_out,  	// Our sample output
    output note_done,          	// When we are done with the note this stays high.
    output sample_ready,     	// Tells the codec when we've got a sample
	output [19:0] step_size	    // set by sine reader
);

//////////// GENERATE SAMPLE ////////////       
    wire [5:0] freq_rom_in;
	
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

    sine_reader np_sine_read(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(play_enable && generate_next_sample),
        .sample_ready(sample_ready),
        .sample(sample_out)
    );
  

    
//////////// COUNTER ////////////     
    wire [5:0] count, next_count;
  
    dffre #(.WIDTH(6)) duration_counter (
        .clk(clk),
        .r(reset),
        .en(((beat && activate) || load_new_note) && play_enable),
        .d(next_count),
        .q(count)
    );
    
    assign next_count = (reset || note_done || load_new_note || count == 6'b0)
                        ? duration : (count - 6'd1);


//////////// REMAINING OUTPUTS ////////////     
    assign note_done = (count == 6'b0);

endmodule
