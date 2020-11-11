module harm_chord_player(
    input  clk,
    input  reset,
    input  play_enable,          // When high we play, when low we don't.
    input  [5:0] note_to_load,  // The note to play
    input  [5:0] duration,      // The duration of the note to play
    input  load_new_note,       // Tells us when we have a new note to load
    input  activate,             // Tells us if the counters should counting
    input  beat,                 // This is our 1/48th second beat
    input  generate_next_sample, // Tells us when the codec wants a new sample
	
    output [17:0] final_sample,  // Our sample output - note1,2,3 and harmonics together!
    output note_done,          // When we are done with a note this stays high - combo of note_done1,2,3
    output sample_ready     // Tells the codec when we've got a sample - combo of sample_ready1,2,3
);

/////////NOTE GET COUNT FROM NOTE PLAYERS! OR NOTE DONES?	

/// Generate Samples for each Note    
reg  [5:0] duration1, duration2, duration3;
reg  [5:0] note_to_load1, note_to_load2, note_to_load3; // is it a problem these are regs and not wires since they are going into modules?
reg  load_new_note1, load_new_note2, load_new_note3;
wire note_done1, note_done2, note_done3;
	
//////////// COUNTERS ////////////    
wire [5:0] count1, count2, count3, next_count1, next_count2, next_count3;
 
dffre #(.WIDTH(6)) duration_counter1 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate) || load_new_note1) && play_enable),
   .d(next_count1),
   .q(count1)
);

dffre #(.WIDTH(6)) duration_counter2 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate) || load_new_note2) && play_enable),
   .d(next_count2),
   .q(count2)
);

dffre #(.WIDTH(6)) duration_counter3 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate) || load_new_note3) && play_enable),
   .d(next_count3),
   .q(count3)
);

assign note_done1 = (count1 == 6'd0);
assign note_done2 = (count2 == 6'd0);
assign note_done3 = (count3 == 6'd0);

assign next_count1 = (reset || note_done1 || load_new_note1 || count1 == 6'b0)
                    ? duration1 : (count1 - 6'd1);
assign next_count2 = (reset || note_done2 || load_new_note2 || count2 == 6'b0)
                    ? duration2 : (count2 - 6'd1);
assign next_count3 = (reset || note_done3 || load_new_note3 || count3 == 6'b0)
                    ? duration3 : (count3 - 6'd1);


/// GOAL - Load New Note into proper Note Number
always @(*) begin
    if (count1 == 0 && load_new_note) begin
        load_new_note1 = load_new_note;
        load_new_note2 = 1'b0;
        load_new_note3 = 1'b0;
        
        note_to_load1 = note_to_load;
        note_to_load2 = 6'b0;
        note_to_load3 = 6'b0;
        
        duration1 = duration;
        duration2 = 6'b0;
        duration3 = 6'b0;
        
    end else if (count2 == 0 && load_new_note) begin
        load_new_note1 = 1'b0;
        load_new_note2 = load_new_note;
        load_new_note3 = 1'b0;

        note_to_load1 = 6'b0;
        note_to_load2 = note_to_load;
        note_to_load3 = 6'b0;
        
        duration1 = 6'b0;
        duration2 = duration;
        duration3 = 6'b0;
        
    end else if (count3 == 0 && load_new_note) begin
        load_new_note1 = 1'b0;
        load_new_note2 = 1'b0;
        load_new_note3 = load_new_note;

        note_to_load1 = 6'b0;
        note_to_load2 = 6'b0;
        note_to_load3 = note_to_load;
        
        duration1 = 6'b0;
        duration2 = 6'b0;
        duration3 = duration;
        
    end else begin 
        load_new_note1 = 1'b0;
        load_new_note2 = 1'b0;
        load_new_note3 = 1'b0;
        
        note_to_load1 = 6'b0;
        note_to_load2 = 6'b0;
        note_to_load3 = 6'b0;
        
        duration1 = 6'b0;
        duration2 = 6'b0;
        duration3 = 6'b0;
    end
end

//////////// OBTAIN ORIGINAL SAMPLES ////////////   
wire [17:0] harmonic_out1, harmonic_out2, harmonic_out3;
wire harmonic_ready1, harmonic_ready2, harmonic_ready3;
note_player np1(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.weight(weight),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load1),
	.duration(duration1),
	.load_new_note(load_new_note1),
	.harmonic_ready(harmonic_ready1),
	.harmonic_out(harmonic_out1)
	);
	
note_player np2(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.weight(weight),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load2),
	.duration(duration2),
	.load_new_note(load_new_note2),
	.harmonic_ready(harmonic_ready2),
	.harmonic_out(harmonic_out2)
	);

note_player np3(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.weight(weight),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load3),
	.duration(duration3),
	.load_new_note(load_new_note3),
	.harmonic_ready(harmonic_ready3),
	.harmonic_out(harmonic_out3)
	);

//////////// OUTPUTS ////////////   
assign final_sample = harmonic_out1 + harmonic_out2 + harmonic_out3;
assign note_done = note_done1 || note_done2 || note_done3;
assign sample_ready = harmonic_ready1 && harmonic_ready2 && harmonic_ready3;
endmodule