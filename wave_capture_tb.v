module wave_capture_tb ();

// inputs
reg clk, reset, new_sample_ready, wave_display_idle;
reg [15:0] new_sample_in;

// outputs
wire write_enable, read_index;
wire [8:0] write_address;
wire [7:0] write_sample;


wave_capture wc (.clk(clk), .reset(reset), .new_sample_ready(new_sample_ready), .new_sample_in(new_sample_in), .wave_display_idle(wave_display_idle),
    .write_address(write_address), .write_enable(write_enable), . write_sample(write_sample), . read_index(read_index));

// Clock and reset
initial begin
    clk = 1'b0;
    reset = 1'b1;
    repeat (4) #5 clk = ~clk;
    reset = 1'b0;
    forever #5 clk = ~clk;
end

// Tests
integer i, j;

initial begin
    reset = 1'b1;
    #10
    reset = 1'b0;
    wave_display_idle = 1'b0;
    new_sample_ready = 1'b0;

    //// Run through all the states
    // start in STATE_ARM
    new_sample_in = 16'b1000000000000001; // negative
    #10
    new_sample_in = 16'b0000000000000000; //positive
    // zero crossing now = 1
    
    // move to STATE_ACTIVE
    #10
    new_sample_ready = 1'b1;
    for (i = 0; i < 256; i = i + 1) begin
        new_sample_in = new_sample_in + i;
        #10;
    end
    
    // move to STATE_WAIT
    wave_display_idle = 1'b0;
    #50
    
    // move back to STATE_ARM
    wave_display_idle = 1'b1;
    #10
    
    //// Back in STATE_ARM - shut off play_enable while in STATE_ACTIVE
    new_sample_in = 16'b0000000000000001; // positive
    #10
    new_sample_in = 16'b1000000000000011; // negative
    // zero crossing now = 1 (prev went - to + now going + to - )
    
    // move to STATE_ACTIVE
    #10
    new_sample_ready = 1'b1;

    for (j = 0; j < 51; j = j + 1) begin
        if(j == 8'd4) begin
            new_sample_ready = 1'b0;
        end else if (j == 8'd30) begin
            new_sample_ready = 1'b1;
        end else if (j == 8'd50) begin
            reset = 1'b1;
        end else begin
            new_sample_in = new_sample_in + j;
            reset = 1'b0;
        end
        #10;
    end
    
    
    
    #50        

    
    $stop;

end
endmodule