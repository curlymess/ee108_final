module mcu_tb();
    reg clk, reset, play_button, next_button, song_done;
    wire play, reset_player;
    wire [1:0] song;

    mcu dut(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(song),
        .song_done(song_done)
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
        reset = 1'b0;
        
        // in song 0 - next song = 0, reset player = 0
        play_button = 1'b0;
        next_button = 1'b0;
        song_done = 1'b0;
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        /////////////////////////////////////////////////////////
        // go to song 1 - next song = 2, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;
        song_done = 1'b0;
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
 
        // stay in song 1 - next song = 1, reset player = 0
        play_button = 1'b0;
        next_button = 1'b0;
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        //////////////////////////////////////////
 
        // go to song 2 - next song = 3, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);

        // go to song 3 - next song = 0, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);


        // go to song 0 -- wrap around! - next song = 1, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);

        // go to  song 1 - next song = 2, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);

        // go to  song 2 - next song = 3, reset player = 1
        play_button = 1'b0;
        next_button = 1'b1;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        /// Play Button Tests ///
        // press play button on song 2 - play = 0, reset player = 1
        play_button = 1'b1;
        next_button = 1'b0;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        // press play button on song 2 - play = 1, reset player = 0
        play_button = 1'b1;
        next_button = 1'b0;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        // press play button on song 2 - play = 0, reset player = 0
        play_button = 1'b1;
        next_button = 1'b0;     
        song_done = 1'b0; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        
        /// Song Done Tests ///
        // song_done on song 2 - move to song 3, reset player = 1
        play_button = 1'b0;
        next_button = 1'b0;     
        song_done = 1'b1; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        // song_done on song 3 - move to song 0, reset player = 1
        play_button = 1'b0;
        next_button = 1'b0;     
        song_done = 1'b1; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
<<<<<<< Updated upstream
        
        // song_done on song 0 - next song = 1, reset player = 1
        play_button = 1'b0;
        next_button = 1'b0;     
        song_done = 1'b1; 
        #10
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
        
        /// Reset Test
        // reset on song 1 - next song = 0, reset player = 1
        reset = 1'b1;
        play_button = 1'b0;
        next_button = 1'b0;     
        song_done = 1'b0; 
        #10
        reset = 1'b0;
        $display("next song: %d, playbttn: %d, nextbttn: %d, songdone: %d, play: %d, reset_player: %d", song, play_button, next_button, song_done, play, reset_player);
                  
        #10
=======
//        next_button = 1;
//        #20
//        next_button = 0;
//        play_button = 1;
//        #10
        //reset = 1;
>>>>>>> Stashed changes
        $stop;               
    end

endmodule
