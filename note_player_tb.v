module note_player_tb();
    /// Inputs ///
    reg clk, reset, play_enable, generate_next_sample, activate;
    reg load_new_note;
    reg [5:0] note_to_load;
    reg [5:0] duration;
    
    /// Outputs ///
    wire beat, note_done1, note_done2, note_done3;
    wire [17:0] sample_out1, sample_out2, sample_out3;
    wire sample_ready1, sample_ready2, sample_ready3;

    note_player np(
        .clk(clk),
        .reset(reset),
        .play_enable(play_enable),
        .note_to_load(note_to_load),
        .duration(duration),
        .load_new_note(load_new_note),
        .note_done1(note_done1),
        .note_done2(note_done2),
        .note_done3(note_done3),
        .activate(activate),
        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out1(sample_out1),
        .sample_out2(sample_out2),
        .sample_out3(sample_out3),
        .sample_ready1(sample_ready1),
        .sample_ready2(sample_ready2),
        .sample_ready3(sample_ready3)
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
        activate = 1'b1;
        
        /// Test 1
        ///  only have Note 1, make sure retained basic functionality
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6;           // 6/48ths
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        repeat(1000000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("ONE NOTE:");
        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load, duration, load_new_note, sample_out1);
        #1000
        #50000
         play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;      // note 44 - E4
        duration = 6'd6;           // 6/48ths
        load_new_note = 1'b1;      
         #10
        load_new_note = 1'b0;        
        repeat(1000000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("ONE NOTE:");
        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load, duration, load_new_note, sample_out2);
        #1000
               
//        /// Test 2 
//        ///  only have Note 1&2 - same duration
//        // Note 1
//        play_enable = 1'b1;         // keep HIGH for now
//        note_to_load1 = 6'd44;      // note 44 - E4
//        duration1 = 6'd6;           // 6/48ths
//        // Note 2
//        note_to_load2 = 6'd44;      // note 44 - E4
//        duration2 = 6'd6;           // 6/48ths
        
//        load_new_note1 = 1'b1;
//        load_new_note2 = 1'b1;      
//         #10
//        load_new_note1 = 1'b0;        
//        load_new_note2 = 1'b0;        
//        repeat(50000)
//        #5
//        generate_next_sample= ~generate_next_sample;
//        #500
//        generate_next_sample = 1'b0;
//        $display("TWO NOTES:");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        #1000
 
//        /// Test 3 
//        ///  all 3 Notes - same duration
//        // Note 1
//        play_enable = 1'b1;         // keep HIGH for now
//        note_to_load1 = 6'd44;      // note 44 - E4
//        duration1 = 6'd6;           // 6/48ths
//        // Note 2
//        note_to_load2 = 6'd44;      // note 44 - E4
//        duration2 = 6'd6;           // 6/48ths
//        // Note 3
//        note_to_load3 = 6'd44;      // note 44 - E4
//        duration3 = 6'd6;           // 6/48ths
        
//        load_new_note1 = 1'b1;
//        load_new_note2 = 1'b1;      
//        load_new_note3 = 1'b1;      
//         #10
//        load_new_note1 = 1'b0;        
//        load_new_note2 = 1'b0;        
//        load_new_note3 = 1'b0;        
//        repeat(50000)
//        #5
//        generate_next_sample= ~generate_next_sample;
//        #500
//        generate_next_sample = 1'b0;
//        $display("THREE NOTES:");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
//        #1000
        
//        /// Test 4 
//        ///  all 3 Notes - same note, different duration
//        // Note 1
//        play_enable = 1'b1;         // keep HIGH for now
//        note_to_load1 = 6'd44;      
//        duration1 = 6'd6;           // 6/48ths
//        // Note 2
//        note_to_load2 = 6'd44;      // note 44 - E4
//        duration2 = 6'd4;           // 4/48ths
//        // Note 3
//        note_to_load3 = 6'd44;      // note 44 - E4
//        duration3 = 6'd2;           // 2/48ths
        
//        load_new_note1 = 1'b1;
//        load_new_note2 = 1'b1;      
//        load_new_note3 = 1'b1;      
//         #10
//        load_new_note1 = 1'b0;        
//        load_new_note2 = 1'b0;        
//        load_new_note3 = 1'b0;        
//        repeat(50000)
//        #5
//        generate_next_sample= ~generate_next_sample;
//        #500
//        generate_next_sample = 1'b0;
//        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
//        #1000
 
//        /// Test 5 
//        ///  all 3 Notes - different notes, same duration
//        // Note 1
//        play_enable = 1'b1;         // keep HIGH for now
//        note_to_load1 = 6'd32;      
//        duration1 = 6'd6;           // 6/48ths
//        // Note 2
//        note_to_load2 = 6'd40;      
//        duration2 = 6'd4;           // 6/48ths
//        // Note 3
//        note_to_load3 = 6'd49;      
//        duration3 = 6'd2;           // 6/48ths
        
//        load_new_note1 = 1'b1;
//        load_new_note2 = 1'b1;      
//        load_new_note3 = 1'b1;      
//         #10
//        load_new_note1 = 1'b0;        
//        load_new_note2 = 1'b0;        
//        load_new_note3 = 1'b0;        
//        repeat(50000)
//        #5
//        generate_next_sample= ~generate_next_sample;
//        #500
//        generate_next_sample = 1'b0;
//        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
//        #1000       
 
//        /// Test 6 
//        ///  all 3 Notes - different notes, different durations
//        // Note 1
//        play_enable = 1'b1;         // keep HIGH for now
//        note_to_load1 = 6'd40;      
//        duration1 = 6'd10;           // 10/48ths
//        // Note 2
//        note_to_load2 = 6'd22;      
//        duration2 = 6'd8;           // 8/48ths
//        // Note 3
//        note_to_load3 = 6'd43;      
//        duration3 = 6'd5;           // 5/48ths
        
//        load_new_note1 = 1'b1;
//        load_new_note2 = 1'b1;      
//        load_new_note3 = 1'b1;      
//         #10
//        load_new_note1 = 1'b0;        
//        load_new_note2 = 1'b0;        
//        load_new_note3 = 1'b0;        
//        repeat(50000)
//        #5
//        generate_next_sample= ~generate_next_sample;
//        #500
//        generate_next_sample = 1'b0;
//        $display("THREE NOTES and DIFFERENT Durations");
//        $display("note1 = %d, duration1 = %d, load_new_note1 = %d, sample_out1 = %b", note_to_load1, duration1, load_new_note1, sample_out1);
//        $display("note2 = %d, duration2 = %d, load_new_note2 = %d, sample_out2 = %b", note_to_load2, duration2, load_new_note2, sample_out2);
//        $display("note3 = %d, duration3 = %d, load_new_note3 = %d, sample_out3 = %b", note_to_load3, duration3, load_new_note3, sample_out3);
//        #1000           
        
        
//        /////////////////////           
//        reset = 1'b1; //should reset everythhing
//        #5000
//        reset = 1'b0;
//        repeat(5000) #20 //should load the previous sample
//        generate_next_sample= ~generate_next_sample;
//        #100
//        play_enable = 1'b0; //should stop counting
//        #1000;
//        play_enable = 1'b1; 
//        #100
//        activate = 1'b0; //should stop counting
//        #1000;
//        activate = 1'b1; 
//        #1000

    $stop;
    end

endmodule
