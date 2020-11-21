module note_player_tb();
    /// Inputs ///
    reg clk, reset, play_enable, generate_next_sample, load_new_note, note_done;
    reg [5:0] note_to_load;
    reg [1:0] weight;
    /// Outputs ///
    wire [15:0] harmonic_out;
    wire harmonic_ready, beat;
    

    note_player np_tb(
    .clk(clk),
    .reset(reset),
    .play_enable(play_enable),          // When high we play, when low we don't.
    .note_to_load(note_to_load),        // The note to play
    .load_new_note(load_new_note),      // Tells us when we have a new note to load
	.weight(weight),			        // Informs create_harmonic how the weight of each harmony
	.note_done(note_done),
    .generate_next_sample(generate_next_sample),// Tells us when the codec wants a new sample
    .harmonic_out(harmonic_out),        // Our sample output
    .harmonic_ready(harmonic_ready)
    );

    beat_generator #(.WIDTH(17), .STOP(5)) beat_generator(
        .clk(clk),
        .reset(reset),
        .en(1'b1),
        .beat(beat)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        reset = 1'b1; // in order to get the beat generator to work - MUST start w reset HIGH
        #10
        reset = 1'b0;
        #10
  //////// Note 1 ////////
        // weight 0
        play_enable = 1'b1;
        note_done = 1'b0;
        weight = 2'd0;
        generate_next_sample = 1'b1;
        note_to_load = 6'd45;
        
        //Load Note Into Note Player
        #10
        load_new_note = 1'b1;
        #10 
        load_new_note = 1'b0;
        #10000
        

        
        // Change to weight 1 //
        weight = 2'd1;
        #10000
        // weight 2
        weight = 2'd2;
        #10000
        
        // play enable LOW
        play_enable = 1'b0;
        #5000
        //Turn on Note done and load new note      
        play_enable = 1'b1; // play enable HIGH

        #5000        
        weight = 2'd0;
      
        note_to_load = 6'd32;
        load_new_note = 1'b1;
        #10 
        load_new_note = 1'b0;
        #10000 
        
        // weight 1       
        weight = 2'd1;
        #10000
        // weight 2
        weight = 2'd2;
        #1000

    $stop;
    end

endmodule
