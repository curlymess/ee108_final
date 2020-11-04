module create_harmonic_tb();
    reg clk, reset, next_button, play_button;

    //instantiate create_harmonic

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
