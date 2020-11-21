module song_reader_tb();
    // inputs
    reg clk, reset, play, note_done, ff_switch0, r_switch1, activate_done;
    reg [1:0] song;
    // outputs
    wire [5:0] note;
    wire [5:0] duration;
    wire song_done, new_note, activate;

    song_reader dut(
        .clk(clk),
        .reset(reset),
        .play(play),
        .song(song),
        .note_done(note_done),
        .ff_switch0(ff_switch0),
        .r_switch1(r_switch1),
        .activate_done(activate_done),
        
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note),
        .activate(activate)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
    reset = 1'b1;
    ff_switch0 = 1'b0;
    r_switch1  = 1'b0;
    activate_done = 1'b1;
    #10
    reset     = 1'b0;
    //ADJUST NOTE DONE
    // Play song 0
    song      = 2'd0;
    play      = 1'b1; // press play once just to start
    note_done = 1'b1;
    
    //Check when note_done is not 0; 
    //Should stay in state 3
    #100
    note_done = 0;
    #100
    note_done =1;
    #50
    
    // Check when play not high
    #100
    play = 0;
    #100
    play = 1;
    
    //Check Reset
    #20
    reset = 1;
    #10
    reset = 0;
   
    
 
    #1600    
    note_done = 0;
    #30
    
    // NOTE ADJUST NOTE DONE
    // Play song 1
    reset     = 1'b0;
    song      = 2'd1;
    play      = 1'b1; // press play once just to start
    note_done = 1'b1;
    #1300   
    note_done = 0;
    play      = 1'b0;
    #30
    
    // Play song 2
    song      = 2'd2;
    play      = 1'b1; // press play once just to start
    note_done = 1'b1;
    #10
    #1300    
    note_done = 0;
    play      = 0;
    #30
    
    // Play song 3
    song      = 2'd3;
    play      = 1'b1; // press play once just to start
    note_done = 1'b1;
    #1300   
    note_done = 0;
    play      = 1'b0;

    #30
    
    // Fast Forward
    // Play song 0 - reg
    song       = 2'd0;
    play       = 1'b1; // press play once just to start
    note_done  = 1'b1;
    ff_switch0 = 1'b0;
    r_switch1  = 1'b0; 
    #1300
    play = 1'b0;
    #20
    // Play song 0 - fast - ff
    song      = 2'd0;
    play      = 1'b1; 
    note_done = 1'b1;
    ff_switch0 = 1'b1;
    r_switch1  = 1'b0; 
    #1300
    
    // Play song 0 - fast - r
    song      = 2'd2;
    note_done = 1'b1;
    ff_switch0 = 1'b0;
    r_switch1  = 1'b1; 
    #1300    
    play = 1'b0;
    #20
    $stop;
    end
endmodule