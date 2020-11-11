module harm_chord_player_tb();

// Inputs
reg clk, reset, play_enable, load_new_note, activate, generate_next_sample;
reg [1:0] weight;
reg [5:0] note_to_load, duration;
//Outputs
wire sample_ready, note_done, beat;
wire [17:0] final_sample;

beat_generator #(.WIDTH(17), .STOP(5)) beat_generator(
     .clk(clk),
     .reset(reset),
     .en(1'b1),
     .beat(beat)
);
    
harm_chord_player hcp1(
    .clk(clk),
    .reset(reset),
    .play_enable(play_enable),    
    .note_to_load(note_to_load),  
    .duration(duration),
    .load_new_note(load_new_note),
    .activate(activate),
    .beat(beat),
    .generate_next_sample(generate_next_sample),
    .weight(weight),
         // outputs
    .final_sample(final_sample),
    .note_done(note_done),
    .sample_ready(sample_ready)
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
   //integer delay = 50000;
    initial begin
        reset = 1'b0;
        #10
        reset = 1'b1;
        
        play_enable = 1'b1;
        weight = 2'd2;
        activate = 1'b0; // off until load all the notes
        #30
        // Chord - load note 1, same durations
        duration = 6'd4;
        note_to_load = 6'd36;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10
        
        // Chord - load note 2, same durations
        duration = 6'd4;
        note_to_load = 6'd32;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10       
        
        // Chord - load note 3, same durations
        duration = 6'd4;
        note_to_load = 6'd26;
        load_new_note = 1'b1;
        #20
        load_new_note = 1'b0;
        #10       
        
        // play chord, same durations
        activate = 1'b1;
        generate_next_sample = 1'b1; // flip on and off??
        #5000
        //activate = 1'b0;
    
        $stop;
    end
endmodule
