//
//  music_player module
//
//  This music_player module connects up the MCU, song_reader, note_player,
//  beat_generator, and codec_conditioner. It provides an output that indicates
//  a new sample (new_sample_generated) which will be used in lab 5.
//
///////
module music_player(
    // Standard system clock and reset
    input clk,
    input reset,

    // Our debounced and one-pulsed button inputs.
    input play_button,
    input next_button,
    input [1:0] weight,
    
    // Our switches
    input ff_switch0,
    input r_switch1,

    // The raw new_frame signal from the ac97_if codec.
    input new_frame,

    // This output must go high for one cycle when a new sample is generated.
    output wire new_sample_generated,

    // Our final output sample to the codec. This needs to be synced to
    // new_frame.
    output wire [15:0] sample_out,
    output wire [1:0] current_song,
    output wire play
);
    // The BEAT_COUNT is parameterized so you can reduce this in simulation.
    // If you reduce this to 100 your simulation will be 10x faster.
    parameter BEAT_COUNT = 100; //1000

//
//  ****************************************************************************
//      Master Control Unit
//  ****************************************************************************
//   The reset_player output from the MCU is run only to the song_reader because
//   we don't need to reset any state in the note_player. If we do it may make
//   a pop when it resets the output sample.
//
 
    wire reset_player;
    wire song_done;
    mcu mcu(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(current_song),
        .song_done(song_done)
    );

//
//  ****************************************************************************
//      Song Reader
//  ****************************************************************************
//
    wire [5:0] note_to_play;
    wire [5:0] duration_for_note;
    wire new_note, activate;
    wire note_done, activate_done;
    song_reader song_reader(
        .clk(clk),
        .reset(reset | reset_player),
        .play(play),
        .ff_switch0(ff_switch0),
        .r_switch1(r_switch1),
        .activate_done(activate_done),
        .song(current_song),
        .note_done(note_done),
        .song_done(song_done),
        .note(note_to_play),
        .duration(duration_for_note),
        .new_note(new_note),
        .activate(activate)
    );

//   
//  ****************************************************************************
//      Harmonic Chord Player
//  ****************************************************************************
//  
  
    wire generate_next_sample;
    wire sample_ready;
    wire [15:0] final_sample;
    

    harm_chord_player harmonic_chord_player(
        .clk(clk),
        .reset(reset),
        .play_enable(play),
        .note_to_load(note_to_play) ,        // When high we play, when low we don't.
        .duration(duration_for_note),      // The duration of the note to play
        .load_new_note(new_note),       // Tells us when we have a new note to load
        .activate(activate),            // Tells us if the counters should counting
        .beat(beat),                // This is our 1/48th second beat
        .generate_next_sample(generate_next_sample),// Tells us when the codec wants a new sample
        .weight(weight),
        .final_sample(final_sample),  // Our sample output - note1,2,3 and harmonics together!
        .note_done(note_done),          // When we are done with a note this stays high - combo of note_done1,2,3
        .activate_done(activate_done),
        .sample_ready(sample_ready)  
    );
      
//   
//  ****************************************************************************
//      Beat Generator
//  ****************************************************************************
//  By default this will divide the generate_next_sample signal (48kHz from the
//  codec's new_frame input) down by 1000, to 48Hz. If you change the BEAT_COUNT
//  parameter when instantiating this you can change it for simulation.
//  
//.STOP(BEAT_COUNT)
    beat_generator #(.WIDTH(10), .STOP(BEAT_COUNT)) beat_generator(
        .clk(clk),
        .reset(reset),
        .en(generate_next_sample),
        .beat(beat)
    );

//  
//  ****************************************************************************
//      Codec Conditioner
//  ****************************************************************************
//  
    assign new_sample_generated = generate_next_sample;
    codec_conditioner codec_conditioner(
        .clk(clk),
        .reset(reset),
        .new_sample_in(final_sample),
        .latch_new_sample_in(sample_ready),
        .generate_next_sample(generate_next_sample),
        .new_frame(new_frame),
        .valid_sample(sample_out)
    );

endmodule
