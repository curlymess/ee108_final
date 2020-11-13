module iie_tb();
    reg clk, reset, up_button, down_button, switch;
    wire [1:0] weight;

    iie dut(
        .clk(clk),
        .reset(reset),
        .up_button(up_button),
        .down_button(down_button),
        .switch(switch),
        .weight(weight)
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
        reset = 1'b1;
        #10
		reset = 1'b0;
		
		//// Everything LOW
		switch = 1'b0;
		up_button = 1'b0;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		//// switch LOW, bttns HIGH
		// up_button no effect
		up_button = 1'b1;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// down button no effect
		up_button = 1'b0;
		down_button = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// switch HIGH, bttns LOW
		switch = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		///// Max out weight
		// at 0, go to 1
		up_button = 1'b1;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// at 1, go to 2
		up_button = 1'b1;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// at 2, try to increase but stays at 2
		up_button = 1'b1;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10

		//// Min weight
		// at 2, go to 1
		up_button = 1'b0;
		down_button = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// at 1, go to 0
		up_button = 1'b0;
		down_button = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		// at 0, try to decrease but stays at 0
		up_button = 1'b0;
		down_button = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		//// Go to 1 then reset
		up_button = 1'b1;
		down_button = 1'b0;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		up_button = 1'b0;
		down_button = 1'b0;
		reset = 1'b1;
		$display("switch: %b, up_button: %b, down_button: %b -> weight: %d", switch, up_button, down_button, weight);
		#10
		
		reset = 1'b0;
		#10;
        $stop;               
    end

endmodule
