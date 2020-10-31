module note_player_tb();

    reg clk, reset, play_enable, generate_next_sample;
    reg [5:0] note_to_load;
    reg [5:0] duration_to_load;
    reg load_new_note;
    wire done_with_note, new_sample_ready, beat;
    wire [15:0] sample_out;

    note_player np(
        .clk(clk),
        .reset(reset),

        .play_enable(play_enable),
        .note_to_load(note_to_load),
        .duration_to_load(duration_to_load),
        .load_new_note(load_new_note),
        .done_with_note(done_with_note),

        .beat(beat),
        .generate_next_sample(generate_next_sample),
        .sample_out(sample_out),
        .new_sample_ready(new_sample_ready)
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
    
        // setting everything to 0
        reset = 1'b0;
        play_enable = 1'b0;
        note_to_load = 1'b0;
        duration_to_load = 1'b0;
        load_new_note = 1'b0;
        generate_next_sample = 1'b0;
        #10
        $display("play_enable = %d, note_to_load = %b, duration = %d, load_new_note = %d, done_w_note = %d, beat = %d, generate_next = %d, sample_out = %b, new_samp_ready = %d", play_enable, note_to_load, duration_to_load, load_new_note, done_with_note, beat, generate_next_sample, sample_out, new_sample_ready);

        // test 1
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd44;       // note 44 - E4
        duration_to_load = 6'd6;    // 6/48ths
        load_new_note = 1'b1; 
         #10
        load_new_note = 1'b0;        
        repeat(50000)
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        generate_next_sample = 1'b0;
        $display("play_enable = %d, note_to_load = %b, duration = %d, load_new_note = %d, done_w_note = %d, beat = %d, generate_next = %d, sample_out = %b, new_samp_ready = %d", play_enable, note_to_load, duration_to_load, load_new_note, done_with_note, beat, generate_next_sample, sample_out, new_sample_ready);
        #400
        
         // test 2
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd45;       // note 45
        duration_to_load = 6'd4;    // 4/48ths
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;       
        repeat(50000) #20
        #5
        generate_next_sample= ~generate_next_sample;
        #500
        load_new_note = 1'b0;
        generate_next_sample = 1'b0;
        $display("play_enable = %d, note_to_load = %b, duration = %d, load_new_note = %d, done_w_note = %d, beat = %d, generate_next = %d, sample_out = %b, new_samp_ready = %d", play_enable, note_to_load, duration_to_load, load_new_note, done_with_note, beat, generate_next_sample, sample_out, new_sample_ready);
        #100
        play_enable = 1'b1;         // keep HIGH for now
        note_to_load = 6'd2;       // note 45
        duration_to_load = 6'd4;    // 4/48ths
        load_new_note = 1'b1;
        #10
        load_new_note = 1'b0;        
        repeat(50000) #20
        generate_next_sample= ~generate_next_sample;
        #500
        load_new_note = 1'b0;
        generate_next_sample = 1'b0;
        $display("play_enable = %d, note_to_load = %b, duration = %d, load_new_note = %d, done_w_note = %d, beat = %d, generate_next = %d, sample_out = %b, new_samp_ready = %d", play_enable, note_to_load, duration_to_load, load_new_note, done_with_note, beat, generate_next_sample, sample_out, new_sample_ready);
        #100
        
        reset = 1'b1; //should reset everythhing
        #5000
        reset = 1'b0;
        repeat(5000) #20 //should load the previous sample
        generate_next_sample= ~generate_next_sample;
        #100
        play_enable = 1'b0; //should stop counting
        #1000;
        play_enable = 1'b1; 
        #1000

    $stop;
    end

endmodule
