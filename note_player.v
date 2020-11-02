module note_player(
    input clk,
    input reset,
    input play_enable,  // When high we play, when low we don't.
    input [5:0] note_to_load1,  // The note to play
    input [5:0] note_to_load2,
    input [5:0] note_to_load3,
    input [5:0] duration1,  // The duration of the note to play
    input [5:0] duration2,
    input [5:0] duration3,
    input load_new_note1,  // Tells us when we have a new note to load
    input load_new_note2,
    input load_new_note3,
    input activate,         // Tells us if the counters should counting
    output note_done1,  // When we are done with the note this stays high.
    output note_done2,
    output note_done3,
    input beat,  // This is our 1/48th second beat
    input generate_next_sample,  // Tells us when the codec wants a new sample
    output [15:0] sample_out1,  // Our sample output - gets combined in adder
    output [15:0] sample_out2,
    output [15:0] sample_out3,
    output new_sample_ready  // Tells the codec when we've got a sample
);

/// Generate Samples for each Note
//////////// NOTE 1 FLIP-FLOPS ////////////     
    wire [19:0] step_size1;
    wire [5:0] freq_rom_in1;
    wire sample_ready1;

    dffre #(.WIDTH(6)) freq_reg1 (
        .clk(clk),
        .r(reset),
        .en(load_new_note1),
        .d(note_to_load1),
        .q(freq_rom_in1)
    );

    frequency_rom freq_rom1(
        .clk(clk),
        .addr(freq_rom_in1),
        .dout(step_size1)
    );

    sine_reader sine_read1(
        .clk(clk),
        .reset(reset),
        .step_size(step_size1),
        .generate_next(play_enable && generate_next_sample), // edit?
        .sample_ready(sample_ready1),
        .sample(sample_out1)
    );

//////////// NOTE 2 FLIP-FLOPS ////////////     
    wire [19:0] step_size2;
    wire [5:0] freq_rom_in2;
    wire sample_ready2;

    dffre #(.WIDTH(6)) freq_reg2 (
        .clk(clk),
        .r(reset),
        .en(load_new_note2),
        .d(note_to_load2),
        .q(freq_rom_in2)
    );

    frequency_rom freq_rom2(
        .clk(clk),
        .addr(freq_rom_in2),
        .dout(step_size2)
    );

    sine_reader sine_read2(
        .clk(clk),
        .reset(reset),
        .step_size(step_size2),
        .generate_next(play_enable && generate_next_sample), // edit?
        .sample_ready(sample_ready2),
        .sample(sample_out2)
    );
    
//////////// NOTE 3 FLIP-FLOPS ////////////     
    wire [19:0] step_size3;
    wire [5:0] freq_rom_in3;
    wire sample_ready3;

    dffre #(.WIDTH(6)) freq_reg3 (
        .clk(clk),
        .r(reset),
        .en(load_new_note3),
        .d(note_to_load3),
        .q(freq_rom_in3)
    );

    frequency_rom freq_rom3(
        .clk(clk),
        .addr(freq_rom_in3),
        .dout(step_size3)
    );

    sine_reader sine_read(
        .clk(clk),
        .reset(reset),
        .step_size(step_size3),
        .generate_next(play_enable && generate_next_sample), // edit?
        .sample_ready(sample_ready3),
        .sample(sample_out3)
    );
////////////////////////////////////////////   
    
/// Counters
    wire [5:0] count1, next_count1;
    dffre #(.WIDTH(6)) counter1 (
        .clk(clk),
        .r(reset),
        .en((beat || load_new_note1) && play_enable && activate),
        .d(next_count1),
        .q(count1)
    );
    assign next_count1 = (reset || note_done1 || load_new_note1)
                        ? duration1 : count1 - 1;

    wire [5:0] count2, next_count2;
    dffre #(.WIDTH(6)) counter2 (
        .clk(clk),
        .r(reset),
        .en((beat || load_new_note2) && play_enable && activate),
        .d(next_count2),
        .q(count2)
    );
    assign next_count2 = (reset || note_done2 || load_new_note2)
                        ? duration2 : count2 - 1;

    wire [5:0] count3, next_count3;
    dffre #(.WIDTH(6)) counter3 (
        .clk(clk),
        .r(reset),
        .en((beat || load_new_note3) && play_enable && activate),
        .d(next_count3),
        .q(count3)
    );
    assign next_count3 = (reset || note_done3 || load_new_note3)
                        ? duration3 : count3 - 1;

/// Outputs
    assign note_done1 = (count1 == 6'b0) && beat;
    assign note_done2 = (count2 == 6'b0) && beat;
    assign note_done3 = (count3 == 6'b0) && beat;
    assign new_sample_ready = sample_ready1 && sample_ready2 && sample_ready3; // right?

endmodule
