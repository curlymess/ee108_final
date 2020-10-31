module wave_display_tb ();

// inputs
reg clk, reset, valid, read_index;
reg [10:0] x;
reg [9:0] y;
wire [7:0] read_value;

// outputs
wire valid_pixel;
wire [7:0] r, g, b;
wire [8:0] read_addr;

// expected outputs
reg exp_valid_pixel;

// instantiation
wave_display wd (.clk(clk), .reset(reset), .x(x), .y(y), .valid(valid), .read_value(read_value),
    .read_index(read_index), .read_address(read_addr), .valid_pixel(valid_pixel), .r(r), .g(g), .b(b));

fake_sample_ram fsr (
        .clk(clk),
        .addr(read_addr[7:0]),
        .dout(read_value)
    );


// focus on edge cases - general testing will have to be w synthessis
// ex. when frame is done that it will trigger
// read_index signal that it is actually changing the address
// .. etc

// Clock and reset
initial begin
    clk = 1'b0;
    reset = 1'b1;
    repeat (4) #5 clk = ~clk;
    reset = 1'b0;
    forever #5 clk = ~clk;
end

// Tests
initial begin
    // ensure reset off
    reset = 1'b0;
    
    // set all inputs to 0
    valid = 1'b0;
    read_index = 1'b0;
    x = 11'd0;
    y = 10'd0;
    
    // set all exp outputs to 0
    exp_valid_pixel = 1'b0;
    #10
    
/////////output: r,g,b and read_value bounds check///////
//// Check output r,g,b - white if valid, black if invalid    
    valid = 1'b1;
    //valid x and valid y
    x = 11'b00111100110;
    y = 10'b111111110;
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    //valid x and valid y
    //same read_addr as previous so read_value should not propagate through
    x = 11'b00111100111;
    y = 10'b111111111;
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    //valid x and valid y 
    //different read_addr so rgb pixels should be white now
    x = 11'b00111111100;
    y = 10'b010111000;
    #20  
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    x = 11'b00111111101;
    y = 10'b010111010;
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
  
    //valid = 0 so pixels should be black;
    valid = 1'b0;
    x = 11'b00111111100;
    y = 10'b0011111100; 
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
   
    #100
    //set read_index to 1 and valid = 1
    //invalid y
    read_index = 1'b1;
    valid = 1'b1;
    x = 11'b01011111111;
    y = 10'b1011111110; //invalid y so pixels should be black
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    //wave is moving downward case
    x = 11'b01011111111;
    y = 10'b011111111;
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    #20
    //the addr did not change 
    x = 11'b00111111100;
    y = 10'b011111111;
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    #20
    //addr changed and y coor is in range so pixels should be white
    x = 11'b00111111101;
    y = 10'b011111101;
    #20
    $display("x %b, y %b, valid %b, read_address %b, read_value %b, read_index %b, valid_pixel %b, r %b, g %b, b %b, read_value bounds [%b, %b]", x, y, valid, read_addr, read_value, read_index, valid_pixel, r, g, b, wd.read_value_adj, wd.curr_read_value);
    #100
    
    ////// Output: valid_pixel ////// 
    //// Check output valid_pixel is HIGH when x[9:8] == 01 or 10 and y[10] == 0
    //// Check output valid_pixel goes HIGH after 2 clock cycles 
    // Test 0 - valid_pixel = 0
    valid = 1'b1;
    
    x = 11'b00000000000;    // invalid x val
    y = 10'b1111111111;     // invalid y val
    exp_valid_pixel = 1'b0;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");
    
    // Test 1 - valid_pixel = 0
    x = 11'b00100000000;    // valid x val - 01
    y = 10'b1111111111;     // invalid y val
    exp_valid_pixel = 1'b0;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");
        
    // Test 2 - valid_pixel = 0
    x = 11'b01000000000;    // valid x val - 10
    y = 10'b1111111111;     // invalid y val
    exp_valid_pixel = 1'b0;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");

    // Test 3 - valid_pixel = 0
    x = 11'b00000000000;    // invalid x val
    y = 10'b0000000000;     // valid y val
    exp_valid_pixel = 1'b0;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");

    // Test 4 - valid_pixel = 1
    x = 11'b01000000000;    // valid x val - 10
    y = 10'b0111111111;     // valid y val
    exp_valid_pixel = 1'b1;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");

    // Test 5 - valid_pixel = 1
    x = 11'b00100011000;    // valid x val - 01
    y = 10'b0111111111;     // valid y val
    exp_valid_pixel = 1'b1;
    #30 $display("x: %b, y: %b = valid_pixel: %b -> %s", x, y, valid_pixel, (valid_pixel == exp_valid_pixel) ? "TRUE" : "FALSE");
    #100
    $stop;
end
endmodule