module harm_chord_player(
    input  clk,
    input  reset,
    input  play_enable,         // When high we play, when low we don't.
    input  [5:0] note_to_load,  // The note to play
    input  [5:0] duration,      // The duration of the note to play
    input  load_new_note,       // Tells us when we have a new note to load
    input  activate,            // Tells us if the counters should counting
    input  beat,                // This is our 1/48th second beat
    input  generate_next_sample,// Tells us when the codec wants a new sample
    input  [1:0] weight,        // When we are done with a note this stays high - combo of note_done1,2,3
	output note_done,
    output signed [15:0] final_sample,  // Our sample output - note1,2,3 and harmonics together!            
    output activate_done,
    output sample_ready          // Tells the codec when we've got a sample - combo of sample_ready1,2,3
);

/// Generate Samples for each Note    
reg  [5:0] duration1, duration2, duration3, duration4;
reg  [5:0] note_to_load1, note_to_load2, note_to_load3, note_to_load4; // is it a problem these are regs and not wires since they are going into modules?
reg  load_new_note1, load_new_note2, load_new_note3, load_new_note4;
wire note_done1, note_done2, note_done3, note_done4;
	
//////////// COUNTERS ////////////    
wire [5:0] count1, count2, count3, count4, next_count1, next_count2, next_count3, next_count4;
 
dffre #(.WIDTH(6)) duration_counter1 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate2) || load_new_note1) && play_enable),
   .d(next_count1),
   .q(count1)
);

dffre #(.WIDTH(6)) duration_counter2 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate2) || load_new_note2) && play_enable),
   .d(next_count2),
   .q(count2)
);

dffre #(.WIDTH(6)) duration_counter3 (
   .clk(clk),
   .r(reset),
   .en(((beat && activate2) || load_new_note3) && play_enable),
   .d(next_count3),
   .q(count3)
);


wire [5:0] dur, next_dur;
dffre #(.WIDTH(6)) dur_ff(
   .clk(clk),
   .r(reset),
   .en(load_new_note4 && play_enable),
   .d(next_dur),
   .q(dur)
);
dffre #(.WIDTH(6)) duration_counter4 (
   .clk(clk),
   .r(reset),
   .en((beat || load_new_note4) && play_enable),
   .d(next_count4),
   .q(count4)
);

//assign next_count4 = load_new_note4 ? duration4: (count4!= 0) ? (count4-1) : 0;
assign activate2 = (count4 != 0) ? 1:0;


assign note_done1 = (count1 == 6'd0);
assign note_done2 = (count2 == 6'd0);
assign note_done3 = (count3 == 6'd0);
assign note_done4 = (count4 == 6'd0);
assign activate_done = note_done4;

assign next_count1 = (reset || note_done1 || load_new_note1 || count1 == 6'b0)
                    ? duration1 : (count1 - 6'd1);
assign next_count2 = (reset || note_done2 || load_new_note2 || count2 == 6'b0)
                    ? duration2 : (count2 - 6'd1);
assign next_count3 = (reset || note_done3 || load_new_note3 || count3 == 6'b0)
                    ? duration3 : (count3 - 6'd1);
assign next_count4 = (reset || note_done4 || load_new_note4 || count4 ==6'b0) 
                    ? duration4: (count4-1);

assign next_dur =  duration4;



/// GOAL - Load New Note into proper Note Number
always @(*) begin
    if (activate &&load_new_note && (count4 ==0) ) begin
        load_new_note1 = 1'b0;
        load_new_note2 = 1'b0;
        load_new_note3 = 1'b0;
        load_new_note4 = load_new_note;

        note_to_load1 = 6'b0;
        note_to_load2 = 6'b0;
        note_to_load3 = 6'b0;
        note_to_load4 = note_to_load;
      
        duration1 = 6'b0;
        duration2 = 6'b0;
        duration3 = 6'b0;
        duration4 = duration;    
    end else if (count1 == 0 && load_new_note) begin
        load_new_note1 = load_new_note;
        load_new_note2 = 1'b0;
        load_new_note3 = 1'b0;
        load_new_note4 = 1'b0;
        
        note_to_load1 = note_to_load;
        note_to_load2 = 6'b0;
        note_to_load3 = 6'b0;
        note_to_load4 = 6'b0;
        
        duration1 = duration;
        duration2 = 6'b0;
        duration3 = 6'b0;
        duration4 = 6'b0;
        
    end else if (count2 == 0 && load_new_note) begin
        load_new_note1 = 1'b0;
        load_new_note2 = load_new_note;
        load_new_note3 = 1'b0;
        load_new_note4 = 1'b0;

        note_to_load1 = 6'b0;
        note_to_load2 = note_to_load;
        note_to_load3 = 6'b0;
        note_to_load4 = 6'b0;
        
        duration1 = 6'b0;
        duration2 = duration;
        duration3 = 6'b0;
        duration4 = 6'b0;

    end else if (count3 == 0 && load_new_note) begin
        load_new_note1 = 1'b0;
        load_new_note2 = 1'b0;
        load_new_note3 = load_new_note;
        load_new_note4 = 1'b0;

        note_to_load1 = 6'b0;
        note_to_load2 = 6'b0;
        note_to_load3 = note_to_load;
        note_to_load4 = 6'b0;
      
        duration1 = 6'b0;
        duration2 = 6'b0;
        duration3 = duration;
        duration4 = 6'b0;
       
    end else begin 
        load_new_note1 = 1'b0;
        load_new_note2 = 1'b0;
        load_new_note3 = 1'b0;
        load_new_note4 = 1'b0;

        note_to_load1 = 6'b0;
        note_to_load2 = 6'b0;
        note_to_load3 = 6'b0;
        note_to_load4 = 6'b0;
  
        duration1 = 6'b0;
        duration2 = 6'b0;
        duration3 = 6'b0;
        duration4 = 6'b0;

    end
end

//////////// OBTAIN ORIGINAL SAMPLES ////////////   
wire signed [15:0] harmonic_out1, harmonic_out2, harmonic_out3;
wire harmonic_ready1, harmonic_ready2, harmonic_ready3;
note_player np1(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.weight(weight),
	.generate_next_sample(generate_next_sample),
	.note_done(note_done1),
	.note_to_load(note_to_load1),
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
	.note_done(note_done2),
	.note_to_load(note_to_load2),
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
	.note_done(note_done3),
	.note_to_load(note_to_load3),
	.load_new_note(load_new_note3),
	.harmonic_ready(harmonic_ready3),
	.harmonic_out(harmonic_out3)
	);

//////////// OUTPUTS ////////////   
assign final_sample = (harmonic_out1 >>> 2) + (harmonic_out2 >>> 2) + (harmonic_out3 >>> 2);
assign note_done = note_done1 || note_done2 || note_done3 || note_done4;
assign sample_ready = (harmonic_ready1 || !count1) && (harmonic_ready2 || !count2) && (harmonic_ready3 || !count3);
endmodule
