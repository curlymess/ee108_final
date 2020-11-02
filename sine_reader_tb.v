module sine_reader_tb();

    reg clk, reset, generate_next;
    reg [19:0] step_size;
    wire sample_ready;
    wire [15:0] sample;
    sine_reader reader(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(generate_next),
        .sample_ready(sample_ready),
        .sample(sample)
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
    #5
    step_size = 20'd500;
    generate_next = 1'b0;
    #500
    repeat(50000) #20
        generate_next = ~generate_next;
    #500 //should hold the sample value steady 
    step_size = 20'd1000; //step faster through sine wave = high freq wave
    repeat(50000) #20
        generate_next = ~generate_next;
    #500
   
    step_size = 20'd100; //step slower = lower freq sine wave 
    repeat(50000) #20
        generate_next = ~generate_next;
    
    generate_next = 1'b0; //should hold the sample value steady and sample_ready should be 0
    #100
    reset = 1'b1; //sample should reset to 0
    #100; 
    reset = 1'b0;

    repeat(50000) #20
        generate_next = ~generate_next; //reload the previous step_size
    
    repeat(5000) begin //reload previous step size
    #5 generate_next = 1'b0;
    #25 generate_next = 1'b1;
    end
    generate_next = 1'b0;
    
    $stop;
    end
endmodule
