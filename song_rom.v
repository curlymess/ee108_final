// How to use:					
// 1. Edit the songs on the Enter Song sheet.					
// 2. Select this whole worksheet, copy it, and paste it into a new file.					
// 3. Save the file as song_rom.v.					
					
module song_rom (					
	input clk,				
	input [6:0] addr,				
	output reg [15:0] dout				
);					
					
	wire [15:0] memory [127:0];				
					
	always @(posedge clk)				
		dout = memory[addr];			
					
	assign memory[	  0	] =	{1'b0,6'd28,6'd48,3'b000};	// Note: 3C
	assign memory[	  1	] =	{1'b0,6'd40,6'd48,3'b000};	// Note: 4C
	assign memory[	  2	] =	{1'b0,6'd52,6'd48,3'b000};	// Note: 5C
	assign memory[	  3	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	  4	] =	{1'b0,6'd27,6'd48,3'b000};	// Note: 3B
	assign memory[	  5	] =	{1'b0,6'd39,6'd32,3'b000};	// Note: 4B
	assign memory[	  6	] =	{1'b0,6'd51,6'd16,3'b000};	// Note: 5B
	assign memory[	  7	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	  8	] =	{1'b0,6'd28,6'd16,3'b000};	// Note: 3C
	assign memory[	  9	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 10	] =	{1'b0,6'd28,6'd16,3'b000};	// Note: 3C
	assign memory[	 11	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 12	] =	{1'b0,6'd30,6'd48,3'b000};	// Note: 3D
	assign memory[	 13	] =	{1'b0,6'd54,6'd48,3'b000};	// Note: 5D
	assign memory[	 14	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 15	] =	{1'b0,6'd32,6'd48,3'b000};	// Note: 3E
	assign memory[	 16	] =	{1'b0,6'd56,6'd16,3'b000};	// Note: 5E
	assign memory[	 17	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 18	] =	{1'b0,6'd33,6'd48,3'b000};	// Note: 3F 
	assign memory[	 19	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 20	] =	{1'b0,6'd35,6'd32,3'b000};	// Note: 3G
	assign memory[	 21	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 22	] =	{1'b0,6'd37,6'd32,3'b000};	// Note: 4A
	assign memory[	 23	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 24	] =	{1'b0,6'd39,6'd16,3'b000};	// Note: 4B
	assign memory[	 25	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 26	] =	{1'b1,6'd0,6'd0,3'b000};	// Note: rest
	assign memory[	 27	] =	{1'b1,6'd0,6'd0,3'b000};	// Note: rest
	assign memory[	 28	] =	{1'b1,6'd0,6'd0,3'b000};	// Note: rest
	assign memory[	 29	] =	{1'b1,6'd0,6'd0,3'b000};	// Note: rest
	assign memory[	 30	] =	{1'b0,6'd40,6'd63,3'b000};	// Note: 4C
	assign memory[	 31	] =	{1'b1,6'd0,6'd63,3'b000};	// Note: rest
	assign memory[	 32	] =	{1'b0,6'd35,6'd36,3'b000};	// Note: 3G
	assign memory[	 33	] =	{1'b0,6'd23,6'd36,3'b000};	// Note: 2G
	assign memory[	 34	] =	{1'b0,6'd47,6'd36,3'b000};	// Note: 4G
	assign memory[	 35	] =	{1'b1,6'd0,6'd36,3'b000};	// Note: rest
	assign memory[	 36	] =	{1'b0,6'd30,6'd18,3'b000};	// Note: 3D
	assign memory[	 37	] =	{1'b0,6'd42,6'd36,3'b000};	// Note: 4D
	assign memory[	 38	] =	{1'b1,6'd0,6'd36,3'b000};	// Note: rest
	assign memory[	 39	] =	{1'b0,6'd38,6'd54,3'b000};	// Note: 4A#Bb
	assign memory[	 40	] =	{1'b1,6'd0,6'd54,3'b000};	// Note: rest
	assign memory[	 41	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	 42	] =	{1'b0,6'd25,6'd9,3'b000};	// Note: 3A
	assign memory[	 43	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	 44	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	 45	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	 46	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	 47	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	 48	] =	{1'b0,6'd34,6'd18,3'b000};	// Note: 3F#Gb
	assign memory[	 49	] =	{1'b0,6'd46,6'd18,3'b000};	// Note: 4F#Gb
	assign memory[	 50	] =	{1'b0,6'd58,6'd18,3'b000};	// Note: 5F#Gb
	assign memory[	 51	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	 52	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	 53	] =	{1'b0,6'd42,6'd9,3'b000};	// Note: 4D
	assign memory[	 54	] =	{1'b0,6'd47,6'd9,3'b000};	// Note: 4G
	assign memory[	 55	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	 56	] =	{1'b0,6'd30,6'd18,3'b000};	// Note: 3D
	assign memory[	 57	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	 58	] =	{1'b0,6'd47,6'd18,3'b000};	// Note: 4G
	assign memory[	 59	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	 60	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 61	] =	{1'b1,6'd28,6'd0,3'b000};	// Note: 3C
	assign memory[	 62	] =	{1'b0,6'd37,6'd63,3'b000};	// Note: 4A
	assign memory[	 63	] =	{1'b1,6'd0,6'd63,3'b000};	// Note: rest
	assign memory[	 64	] =	{1'b0,6'd40,6'd48,3'b000};	// Note: 4C
	assign memory[	 65	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 66	] =	{1'b0,6'd45,6'd32,3'b000};	// Note: 4F
	assign memory[	 67	] =	{1'b0,6'd49,6'd32,3'b000};	// Note: 5A
	assign memory[	 68	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 69	] =	{1'b0,6'd42,6'd48,3'b000};	// Note: 4D
	assign memory[	 70	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 71	] =	{1'b0,6'd47,6'd32,3'b000};	// Note: 4G
	assign memory[	 72	] =	{1'b0,6'd51,6'd16,3'b000};	// Note: 5B
	assign memory[	 73	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 74	] =	{1'b0,6'd44,6'd48,3'b000};	// Note: 4E
	assign memory[	 75	] =	{1'b1,6'd0,6'd16,3'b000};	// Note: rest
	assign memory[	 76	] =	{1'b0,6'd49,6'd32,3'b000};	// Note: 5A
	assign memory[	 77	] =	{1'b0,6'd52,6'd48,3'b000};	// Note: 5C
	assign memory[	 78	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 79	] =	{1'b0,6'd47,6'd32,3'b000};	// Note: 4G
	assign memory[	 80	] =	{1'b0,6'd51,6'd32,3'b000};	// Note: 5B
	assign memory[	 81	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 82	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 83	] =	{1'b0,6'd40,6'd48,3'b000};	// Note: 4C
	assign memory[	 84	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 85	] =	{1'b0,6'd45,6'd48,3'b000};	// Note: 4F
	assign memory[	 86	] =	{1'b0,6'd49,6'd48,3'b000};	// Note: 5A
	assign memory[	 87	] =	{1'b1,6'd0,6'd48,3'b000};	// Note: rest
	assign memory[	 88	] =	{1'b0,6'd42,6'd16,3'b000};	// Note: 4D
	assign memory[	 89	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 90	] =	{1'b0,6'd47,6'd32,3'b000};	// Note: 4G
	assign memory[	 91	] =	{1'b0,6'd51,6'd16,3'b000};	// Note: 5B
	assign memory[	 92	] =	{1'b1,6'd0,6'd32,3'b000};	// Note: rest
	assign memory[	 93	] =	{1'b0,6'd28,6'd0,3'b000};	// Note: 3C
	assign memory[	 94	] =	{1'b1,6'd0,6'd0,3'b000};	// Note: rest
	assign memory[	 95	] =	{1'b1,6'd0,6'd26,3'b000};	// Note: rest
	assign memory[	 96	] =	{1'b0,6'd35,6'd36,3'b000};	// Note: 3G
	assign memory[	 97	] =	{1'b1,6'd0,6'd36,3'b000};	// Note: rest
	assign memory[	 98	] =	{1'b0,6'd42,6'd36,3'b000};	// Note: 4D
	assign memory[	 99	] =	{1'b1,6'd0,6'd36,3'b000};	// Note: rest
	assign memory[	100	] =	{1'b0,6'd39,6'd54,3'b000};	// Note: 4Bb
	assign memory[	101	] =	{1'b1,6'd0,6'd54,3'b000};	// Note: rest
	assign memory[	102	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	103	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	104	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	105	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	106	] =	{1'b0,6'd38,6'd18,3'b000};	// Note: 4A#Bb
	assign memory[	107	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	108	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	109	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	110	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	111	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	112	] =	{1'b0,6'd34,6'd18,3'b000};	// Note: 3F#Gb
	assign memory[	113	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	114	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	115	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	116	] =	{1'b0,6'd30,6'd36,3'b000};	// Note: 3D
	assign memory[	117	] =	{1'b1,6'd0,6'd36,3'b000};	// Note: rest
	assign memory[	118	] =	{1'b0,6'd35,6'd18,3'b000};	// Note: 3G
	assign memory[	119	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	120	] =	{1'b0,6'd30,6'd18,3'b000};	// Note: 3D
	assign memory[	121	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	122	] =	{1'b0,6'd37,6'd18,3'b000};	// Note: 4A
	assign memory[	123	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	124	] =	{1'b0,6'd30,6'd18,3'b000};	// Note: 3D
	assign memory[	125	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
	assign memory[	126	] =	{1'b0,6'd38,6'd18,3'b000};	// Note: 4A#Bb
	assign memory[	127	] =	{1'b1,6'd0,6'd18,3'b000};	// Note: rest
endmodule					
