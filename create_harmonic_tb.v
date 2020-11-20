module create_harmonic_tb();
    reg clk, reset, play_enable, generate_next_sample, note_done;
    reg [19:0] step_size;
    reg [1:0] weight;
    //outputs
    wire signed [15:0] harmonic_out;
    wire sample_ready;

    //instantiate create_harmonic
create_harmonic ch_test(
	.clk(clk),
	.reset(reset),
	.play_enable(play_enable),
	.generate_next_sample(generate_next_sample),
	.step_size(step_size),
	.weight(weight),
	.note_done(note_done),
	.harmonic_out(harmonic_out),
	.sample_ready(sample_ready)
);

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    integer delay = 25000;
    initial begin
        reset = 1'b0;
        #10
        reset = 1'b1;
        step_size = 20'd500;
        play_enable = 1'b1;
        
        //// Weight = 0 ////
        
        //Regular Case 
        weight = 2'd0;
        generate_next_sample = 1'b0;
        note_done = 1'b0;
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
        
        //Change Step Size
        step_size = 20'd1000;
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
        
        //disable Play_enable
        play_enable = 0;
        
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        play_enable = 1;     
        
                
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
      
        //Enable note_done
        note_done = 1'b1;
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        note_done = 1'b0;
           
        
       //// Weight = 1 ////
        
        #200
        generate_next_sample = 1'b0;
        $display("weight = %d, play_enable = %d, step_size = %d, harm_out = %b, sample_ready = %d", weight, play_enable, step_size, harmonic_out, sample_ready);
        #200
 
         //// Weight = 1 ////
        weight = 2'd1;
        generate_next_sample = 1'b0;
        
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
                //Change Step Size
        step_size = 20'd1500;
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
        
        
                // Disable Play_enable
        play_enable = 0;
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        play_enable = 1; 
        
       repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end  
        
                //Enable note_done
        note_done = 1'b1;
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        note_done = 1'b0;
        #400    

        //// Weight = 2 ////
        weight = 2'd2;
        generate_next_sample = 1'b0;
        
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
                //Change Step Size
        step_size = 20'd2000;
        repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end
        
        
                // Disable Play_enable
        play_enable = 0;
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        play_enable = 1; 
        
       repeat(delay) begin
            #5
            generate_next_sample= ~generate_next_sample;
        end  
        
                //Enable note_done
        note_done = 1'b1;
        repeat(10000) begin
        #5
            generate_next_sample= ~generate_next_sample;
        end   
        note_done = 1'b0;

        #400
        reset = 1'b1;
        #10
        reset= 1'b0;
        generate_next_sample = 1'b0;
        $stop;
    end


endmodule
