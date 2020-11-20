module create_harmonic(
	input clk,
	input reset,
	input play_enable,
	input generate_next_sample,
	input [19:0] step_size,
	input [1:0] weight,
	input note_done,
	output signed [15:0] harmonic_out,
	output sample_ready
);
wire signed [15:0] out1, out2, out3;
wire signed [15:0] harm1, harm2, harm3;
wire [19:0] harm_step2, harm_step3;
wire samp_ready1, samp_ready2,samp_ready3;
wire signed [15:0] harm_out1,harm_out2, harm_out3;


assign harm_step2 = step_size << 1;
assign harm_step3 = step_size << 2;


//////////// GENERATE SAMPLE ////////////       
    sine_reader harmonic_sine_read1(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(!note_done && play_enable && generate_next_sample),
        .sample_ready(samp_ready1),
        .sample(harm_out1)
    );
    
    
    dffr #(.WIDTH(16)) ff1 (
        .clk(clk),
        .r(reset),
        .d(out1),
        .q(harm1)
    );
    dffr #(.WIDTH(16)) ff2 (
        .clk(clk),
        .r(reset),
        .d(out2),
        .q(harm2)
    );
    dffr #(.WIDTH(16)) ff3 (
        .clk(clk),
        .r(reset),
        .d(out3),
        .q(harm3)
    );
	
    sine_reader harmonic_sine_read2(
        .clk(clk),
        .reset(reset),
        .step_size(harm_step2),
        .generate_next(!note_done && play_enable && generate_next_sample),
        .sample_ready(samp_ready2),
        .sample(harm_out2)
    );

    sine_reader harmonic_sine_read3(
        .clk(clk),
        .reset(reset),
        .step_size(harm_step3),
        .generate_next(!note_done && play_enable && generate_next_sample),
        .sample_ready(samp_ready3),
        .sample(harm_out3)
    );
	
	//try 
///////////////// WEIGHT /////////////////
assign out1 = harm_out1;
assign out2 = ((harm_out1 >>> 1) + (harm_out1 >>> 3)) + ((harm_out2 >>> 2) + (harm_out2 >>> 3));
assign out3 = ((harm_out1 >>> 1) + (harm_out1 >>> 3)) + (harm_out2 >>> 2) + (harm_out3 >>> 3);
assign harmonic_out = ((weight == 0) ? harm1 : (weight == 1) ? harm2 : harm3);
assign sample_ready = samp_ready1 && samp_ready2 && samp_ready3;
endmodule