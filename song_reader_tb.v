module song_reader_tb();

    reg clk, reset, play, note_done;
    reg [1:0] song;
    wire [5:0] note;
    wire [5:0] duration;
    wire song_done, new_note;

    song_reader dut(
        .clk(clk),
        .reset(reset),
        .play(play),
        .song(song),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note),
        .note_done(note_done)
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
    #10
    
    // Play song 0
    reset     = 1'b0;
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
    
    //Check when play not high
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
    //note_done = 0;
    //#30
    
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
    
    $stop;
    end
endmodule