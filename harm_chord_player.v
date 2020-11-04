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
wire [19:0] step_size1, step_size2, step_size3;
reg  [5:0] duration1, duration2, duration3;
reg  [5:0] note_to_load1, note_to_load2, note_to_load3; // is it a problem these are regs and not wires since they are going into modules?
reg  load_new_note1, load_new_note2, load_new_note3;
	
	
	// NOTE: IMPLEMENT COUNT 
wire [5:0] count1, count2, count3;

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
note_player np1(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.activate(activate),
	.beat(beat),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load1),
	.duration(duration1),
	.load_new_note(load_new_note1),
	.sample_out(sample_out1),
	.note_done(note_done1),
	.sample_ready(sample_ready1)
	);
	
note_player np2(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.activate(activate),
	.beat(beat),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load2),
	.duration(duration2),
	.load_new_note(load_new_note2),
	.sample_out(sample_out2),
	.note_done(note_done2),
	.sample_ready(sample_ready2)
	);

note_player np3(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.activate(activate),
	.beat(beat),
	.generate_next_sample(generate_next_sample),
	// note specific variables
	.note_to_load(note_to_load3),
	.duration(duration3),
	.load_new_note(load_new_note3),
	.sample_out(sample_out3),
	.note_done(note_done3),
	.sample_ready(sample_ready3)
	);

//////////// CREATE HARMONCS ////////////     
wire [17:0] note_harm1, note_harm2, note_harm3;
create_harmonic ch1(
    .clk(clk),
    .reset(reset),
    .note_to_load(note_to_load1),
    .step_size(step_size1),
    .sample_in(sample_out1),
    .harmonic_out(note_harm1)
    );
    
create_harmonic ch2(
    .clk(clk),
    .reset(reset),
    .note_to_load(note_to_load2),
    .step_size(step_size2),
    .sample_in(sample_out2),
    .harmonic_out(note_harm2)
    );

create_harmonic ch3(
    .clk(clk),
    .reset(reset),
    .note_to_load(note_to_load3),
    .step_size(step_size3),
    .sample_in(sample_out3),
    .harmonic_out(note_harm3)
    );
    
/// OUTPUT
assign final_sample = note_harm1 + note_harm2 + note_harm3;
endmodule
