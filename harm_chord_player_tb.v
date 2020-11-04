module harm_chord_player_tb();
    reg clk, reset, next_button, play_button;
    wire new_frame;
    wire [15:0] sample;

    //instantiate harm_chord_player

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


    end


endmodule
