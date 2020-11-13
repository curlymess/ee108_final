module iie(
    input clk,
    input reset,
    input up_button,
    input down_button,
	input switch,
    output [1:0] weight
);

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define DEFAULT_WEIGHT 		2'b00
`define WEIGHT1				2'b01
`define WEIGHT2         	2'b10

reg [1:0] next_weight;
    dffre #(.WIDTH(2)) weight_dffre (
        .clk(clk),
        .r(reset),
        .en(switch),
        .d(next_weight),
        .q(weight)
    );

always @(*) begin
	if(switch) begin
		case (weight)
		   `DEFAULT_WEIGHT: next_weight = up_button ? `WEIGHT1 : `DEFAULT_WEIGHT;
		   `WEIGHT1:        next_weight = up_button ? `WEIGHT2 : (down_button ? `DEFAULT_WEIGHT : `WEIGHT1);
		   `WEIGHT2:        next_weight = down_button ? `WEIGHT1 : `WEIGHT2;
		   default:         next_weight = `DEFAULT_WEIGHT;
		endcase
	end else begin
		next_weight = weight;
	end
end

endmodule
