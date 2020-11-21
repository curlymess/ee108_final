module harm_chord_player_tb();

// Inputs
reg clk, reset, play_enable, load_new_note, activate, generate_next_sample;
reg [1:0] weight;
reg [5:0] note_to_load, duration;
// Outputs
wire sample_ready, note_done, beat;
wire [15:0] final_sample;

beat_generator #(.WIDTH(17), .STOP(20)) beat_generator(
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
        weight = 2'd0;
        activate = 1'b0; // off until load all the notes
        #30

/////////////////////// 3 NOTE CHORD ///////////////////////
///////// Same Duration
        // Chord - load note 1, same durations
       #10
        duration = 6'd12;
        note_to_load = 6'd36;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10
        
        // Chord - load note 2, same durations
        duration = 6'd12;
        note_to_load = 6'd32;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10       
        
        // Chord - load note 3, same durations
        duration = 6'd12;
        note_to_load = 6'd26;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10     
        activate = 1'b1;
  
        load_new_note = 1'b1;
        #10

        load_new_note = 1'b0;
        
        // play chord, same durations
        generate_next_sample = 1'b1;
        #5000
        activate = 1'b0;
        #30
        
///////// Diff Duration
        // Chord - load note 1, diff durations
        duration = 6'd20;
        note_to_load = 6'd20;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10
        
        // Chord - load note 2, diff durations
        duration = 6'd8;
        note_to_load = 6'd26;
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;
        #10       
        
        // Chord - load note 3, diff durations
        duration = 6'd4;
        note_to_load = 6'd30;
        load_new_note = 1'b1;
        #20
        load_new_note = 1'b0;
        #10       
        
        // play chord, diff durations
        activate = 1'b1;
        generate_next_sample = 1'b1;
        #300
        // load new note in note 3
        activate = 1'b0;
        #10
        duration = 6'd6;
        note_to_load = 6'd32;
        load_new_note = 1'b1;
        #30
        activate = 1'b1;
        load_new_note = 1'b0;
        #10
        #4000
        activate = 1'b0;
        #30
        
        /// Test 1
        ///  only have Note 1, make sure retained basic functionality
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6;           // 6/48ths
        load_new_note = 1'b1;
        activate = 1'b1;      
         #20
        load_new_note = 1'b0;        
        repeat(1000000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("ONE NOTE:");
        //$display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load, duration, load_new_note, sample_out1);
        #1000
        activate = 1'b0;
        #50000
        
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6; 
        activate = 1'b1;          // 6/48ths
        load_new_note = 1'b1;      
        #30
        load_new_note = 1'b0; 
        repeat(1000000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("ONE NOTE:");
        //$display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load, duration, load_new_note, sample_out2);
        #1000
        activate = 1'b0;
        
               
        /// Test 2 
        ///  only have Note 1&2 - same duration
        // Note 1
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6;           // 6/48ths
        // Note 2
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6;           // 6/48ths
        
        load_new_note = 1'b1;
         #20
        load_new_note = 1'b0;   
        activate = 1;     
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("TWO NOTES:");
        //$display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
        //$display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
        #1000
 
        /// Test 3 
        ///  all 3 Notes - same duration
        // Note 1
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        load_new_note = 1'b1;
        #20
        load_new_note = 1'b0;
        // Note 2
        note_to_load = 6'd44;      // note 44 - E4
        load_new_note = 1'b1;
        #20
        load_new_note = 1'b0;
        // Note 3
        note_to_load = 6'd44;      // note 44 - E4
        load_new_note = 1'b1;
        load_new_note = 1'b1;
        #20
        load_new_note = 1'b0;
         #10
        load_new_note = 1'b0;     
        load_new_note = 1'b1;
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("THREE NOTES:");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
        #1000
        load_new_note = 1'b0;   

        
        /// Test 4 
        ///  all 3 Notes - same note, different duration
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44; 
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;     
        // Note 2
        note_to_load = 6'd44;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        // Note 3
        note_to_load = 6'd44;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        
        activate = 1'b1;    
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
        #1000
        activate = 1'b0;
        /// Test 5 
        ///  all 3 Notes - different notes, same duratio
        // Note 1
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd32; 
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;     
        // Note 2
        note_to_load = 6'd40;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        // Note 3
        note_to_load = 6'd49;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        
        activate = 1'b1;
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
        #1000       
 
        /// Test 6 
        ///  all 3 Notes - different notes, different durations
        // Note 1
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd40; 
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;     
        // Note 2
        note_to_load = 6'd22;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        // Note 3
        note_to_load = 6'd43;
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        
        activate = 1'b1;
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
        #1000           
        activate = 1'b0;
        
        /////////////////////           
        reset = 1'b1; //should reset everythhing
        #5000
        reset = 1'b0;
        repeat(5000) #20 //should load the previous sample
        generate_next_sample= ~generate_next_sample;
        #100
        play_enable = 1'b0; //should stop counting
        #1000;
        play_enable = 1'b1; 
        #100
        activate = 1'b0; //should stop counting
        #1000;
        activate = 1'b1; 
        #1000
       
    
        $stop;
    end
endmodule
