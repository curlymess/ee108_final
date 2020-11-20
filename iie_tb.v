module iie_tb();
    reg clk, reset, weight_button;
    wire [1:0] weight;

    iie dut(
        .clk(clk),
        .reset(reset),
        .weight_button(weight_button),
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
		// weight = 0
		weight_button = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		// weight = 1
		weight_button = 1'b1;
		#10
		weight_button = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		// weight = 2
		weight_button = 1'b1;
		#10
		weight_button = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		// wrap-around
		// weight = 0
		weight_button = 1'b1;
		#10
		weight_button = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		// weight = 1
		weight_button = 1'b1;
		#10
		weight_button = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		// reset 
		// weight = 0
		// weight = 1
		reset = 1'b1;
		#10
		reset = 1'b0;
		$display("weight_button: %b -> weight: %d", weight_button, weight);
		#10
		
		#10;
        $stop;               
    end

endmodule
