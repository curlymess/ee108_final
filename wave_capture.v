`define ARMED 2'b00
`define ACTIVE 2'b01
`define WAIT 2'b10

module wave_capture (
    input clk,
    input reset,
    input new_sample_ready,
    input [15:0] new_sample_in,
    input wave_display_idle,

    output wire [8:0] write_address,
    output wire write_enable,
    output wire [7:0] write_sample,
    output wire read_index
);

	//wires used in the flip flop to keep track of the count and sample
	wire [7:0] next_counter, counter, write_sample_temp;

	//wires used to keep track of when zero crossing is positive (zero_crossing), sample is negative (is_negative), and when we have counted to 255 (count_done)
	wire zero_crossing, is_negative, last_is_negative, count_done;

	//wires used in the flip flop to keep track of what state in the FSM we are in
	wire [1:0] state, next_state;

	//register that allows us to temporarily assign the value of next_state
	reg [1:0] next_state_temp;

	//register that allows us to temporarily hold and invert the value of read_index
	wire read_index_temp;

	//flip flop that modifies the address when in the ARMED state
	dffre #(8) count_flip_flop(.clk(clk), .r(reset | state == `ARMED), .en(state == `ACTIVE), .d(next_counter), .q(counter));

	//flip flop that changes the states 
	dffr #(2) state_flip_flop(.clk(clk), .r(reset), .d(next_state), .q(state));

	//flip flop that determines positive zero crossing or a negative sample
	dffre #(1) zero_cross_flip_flop(.clk(clk), .r(reset), .en(~new_sample_ready), .d(is_negative), .q(last_is_negative));

	//flip flop that changes read_index
	dffre #(1) read_index_flip_flop(.clk(clk), .r(reset), .en(wave_display_idle && state == `WAIT), .d(read_index_temp), .q(read_index));

//change the states based on various signals
always @ (*) begin
	case(state)
		`ARMED: //when in the ARMED state
			if (zero_crossing) begin //if positive zero_crossing (the signal is high), move to the next state (ACTIVE)
				next_state_temp = `ACTIVE;
			end else begin	//else stay in the ARMED state
				next_state_temp = `ARMED;
			end
		`ACTIVE: //when in the ACTIVE state, just wait until we have counted to 255 and then go to the WAIT state
			if (count_done) begin //if count_done signal is high move to the next state (WAIT)
				next_state_temp = `WAIT;
			end else begin // else stay in the active state
				next_state_temp = `ACTIVE;
			end
		`WAIT: 
			if (wave_display_idle) begin //if wave_display_idle is high we move to the ARMED state 
				next_state_temp = `ARMED; 
			end else begin
				next_state_temp = `WAIT; // else we stay in the wait state
			end
		default: next_state_temp = `ARMED;
		endcase
end

	//in the active state
	assign next_counter = (new_sample_ready) ? (counter + 8'b00000001) : counter; //when new_sample_ready signal is high, we increment the counter
	assign write_address = {~read_index,counter}; //address is the concatenation of the read_index signal and the current count
	assign count_done =(counter == 8'b11111111); //when the counter has reached 255, the signal count_done goes high

	//determine positive zero crossing
	assign is_negative = new_sample_in[15] == 1'b1;	//if the module is reset and the sample is less than 0, is_negative signal is high
	assign zero_crossing = reset ? 1'b0 : (~is_negative & last_is_negative); //if the sample is not negative and the last sample is negative, positive zero crossing

	//state specific assignments
	assign next_state = next_state_temp; //next_state always holds the value of the temporary next_state register
	assign write_sample_temp = (state == `ACTIVE) ? new_sample_in[15:8] : 8'b00000000; 
	assign write_enable = (state  == `ACTIVE);
	assign write_sample = write_sample_temp + 8'b10000000;

	//invert read_index when wave_display_idle goes high 
	assign read_index_temp = ~read_index;

endmodule 