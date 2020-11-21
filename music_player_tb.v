module music_player_tb();
    reg clk, reset, next_button, play_button, ff_switch0, r_switch1;
    reg [1:0] weight_button;
    wire new_frame;
    wire [15:0] sample;
    wire [1:0] current_song;
    wire play;
    

    music_player #(.BEAT_COUNT(100)) music_player(
        .clk(clk),
        .reset(reset),
        .next_button(next_button),
        .play_button(play_button),
        .weight(weight_button),
        .new_frame(new_frame),
        .sample_out(sample),
        .ff_switch0(ff_switch0),
        .r_switch1(r_switch1),
        .current_song(current_song),
        .play(play)
    );

    // AC97 interface
    wire AC97Reset_n;        // Reset signal for AC97 controller/clock
    wire SData_Out;          // Serial data out (control and playback data)
    wire Sync;               // AC97 sync signal

    // Our codec simulator
    ac97_if codec(
        .Reset(1'b0), // Reset MUST be shorted to 1'b0
        .ClkIn(clk),
        .PCM_Playback_Left(sample),   // Set these two to different
        .PCM_Playback_Right(sample),  // samples to have stereo audio!
        .PCM_Record_Left(),
        .PCM_Record_Right(),
        .PCM_Record_Valid(),
        .PCM_Playback_Accept(new_frame),  // Asserted each sample
        .AC97Reset_n(AC97Reset_n),
        .AC97Clk(1'b0),
        .Sync(Sync),
        .SData_Out(SData_Out),
        .SData_In(1'b0)
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
    integer delay;
    initial begin
        delay = 3000000;
        play_button = 1'b0;
        next_button = 1'b0;
        weight_button = 1'b0;
        ff_switch0 = 1'b0;
        r_switch1 = 1'b0;
        @(negedge reset);
        @(negedge clk);

        repeat (25) begin
            @(negedge clk);
        end 

        // Start playing
        $display("Starting playing song 0...");
        @(negedge clk);
        play_button = 1'b1;

        @(negedge clk);
        play_button = 1'b0;

        repeat (1000000) begin
            @(negedge clk);
        end
        
        //ff_switch0 = 1'b1;
        next_button = 1'b1;
        #10
        next_button = 1'b0;
        play_button = 1'b1;
        #100
        play_button = 1'b0;
        
        repeat (2000000) begin
            @(negedge clk);
        end
        
        //2nd song
        ff_switch0 = 1'b0;
        play_button = 1'b1;
        //weight_button = 2'd2;
        #10
        play_button = 1'b0;

        repeat (delay) begin
            @(negedge clk);
        end
        
        
        //3rd song
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        
        repeat (delay) begin
            @(negedge clk);
        end  
        
        //4th song     
        play_button = 1'b1;
        #10
        play_button = 1'b0;
        
        repeat (delay) begin
            @(negedge clk);
        end
        
            
        $finish;
    end


endmodule
