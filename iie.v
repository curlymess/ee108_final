module iie(
    input clk,
    input reset,
    input weight_button,
    output [1:0] weight
);

// ----------------------------------------------
// Define State Assignments
// ----------------------------------------------
`define DEFAULT_WEIGHT 		2'b00
`define WEIGHT1				2'b01
`define WEIGHT2         	2'b10

reg [1:0] next_weight;
    dffr #(.WIDTH(2)) weight_dffre (
        .clk(clk),
        .r(reset),
        .d(next_weight),
        .q(weight)
    );

always @(*) begin
    case (weight)
       `DEFAULT_WEIGHT: next_weight = weight_button ? `WEIGHT1 : `DEFAULT_WEIGHT;
       `WEIGHT1:        next_weight = weight_button ? `WEIGHT2 : `WEIGHT1;
       `WEIGHT2:        next_weight = weight_button ? `DEFAULT_WEIGHT : `WEIGHT2;
       default:         next_weight = `DEFAULT_WEIGHT;
    endcase
end

endmodule
