module create_harmonic(
	input clk,
	input reset,
	input play_enable,
	input generate_next_sample,
	input [19:0] step_size,
	input [17:0] sample_in,
	output [17:0] harmonic_out
);

wire [17:0] harm1, harm2, harm3;
wire [19:0] harm_step2, step_harm3;
wire samp_ready2,samp_ready3;

assign harm_step2 = step_size >> 1; // is it >>>? check documentation
assign harm_step3 = step_size >> 2;


//////////// GENERATE SAMPLE ////////////       

    sine_reader harmonic_sine_read2(  // NOTE WHAT ABOUT SINE READERS OTHER SHIT -- OUTPUTS
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
	
assign harm1 = (sample_in >> 1) + (sample_in >> 3);// 1/2 + 1/8 = 5/8
assign harmonic_out = harm1 + (harm2 >> 2) + (harm3 >> 3); // is it >> or >>>?
// 5/8 + 1/4 + 1/8
endmodule