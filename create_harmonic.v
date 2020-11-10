module create_harmonic(
	input clk,
	input reset,
	input play_enable,
	input generate_next_sample,
	input [19:0] step_size,
	input [1:0] weight,
	output [17:0] harmonic_out,
	output sample_ready
);

wire [17:0] harm1, harm2, harm3;
wire [19:0] harm_step2, step_harm3;
wire samp_ready1, samp_ready2,samp_ready3;

assign harm_step2 = step_size >> 1; // is it >>>? check documentation
assign harm_step3 = step_size >> 2;

//////////// WEIGHT ////////////


//////////// GENERATE SAMPLE ////////////       
    sine_reader harmonic_sine_read1(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(play_enable && generate_next_sample),
        .sample_ready(samp_ready1),
        .sample(harm1)
    );
	
    sine_reader harmonic_sine_read2(
        .clk(clk),
        .reset(reset),
        .step_size(harm_step2),
        .generate_next(play_enable && generate_next_sample),
        .sample_ready(samp_ready2), ///////?????
        .sample(harm2)
    );

    sine_reader harmonic_sine_read3(
        .clk(clk),
        .reset(reset),
        .step_size(harm_step3),
        .generate_next(play_enable && generate_next_sample),
        .sample_ready(samp_ready3), ///////////????
        .sample(harm3)
    );
	
assign harm1 = (harm1 >> 1) + (harm1 >> 3);// 1/2 + 1/8 = 5/8
assign harmonic_out = harm1 + (harm2 >> 2) + (harm3 >> 3); // is it >> or >>>?
assign sample_ready = samp_ready1 && samp_ready2 && samp_ready3;
// 5/8 + 1/4 + 1/8
endmodule