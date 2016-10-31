module AddingMachine(
    //Each hex bit has its own 7-segment array
    output  [6:0]    HEX0,  // Second digit of the sum
    output  [6:0]    HEX1,  // First digit of the sum
    output  [6:0]    HEX2,  // Second digit of the second input value ("B")
    output  [6:0]    HEX3,  // First digit of "B" input
    output  [6:0]    HEX4,  // Second digit of the first value ("A")
    output  [6:0]    HEX5,  // First digit of the "A" input

    input   [9:0]   SW,     // 10 value-input switches
    output  [9:0]   LEDR    //10 LEDs corresponding to the switches
    );
    wire    [4:0]   a_side, b_side;  //5 bits each
    wire    [5:0]   sum;             //6 bits

    assign LEDR = SW;           // Use LEDs for visual switch state feedback
    assign a_side = SW[9:5];    // Left half of the input switches (5 total) encode the value of the first number to add.
    assign b_side = SW[4:0];    // Right half of the input switches (5 total) encode the value of the second number to add.
    assign sum = a_side + b_side;//The sum of the first and second values.
    // Display the values of the two inputs and the sum on three pairs of seven-segment displays
    DualSevenSegmentDriver sumDisplay  (.bin(sum[5:0]),      .DisplayTwo(HEX0), .DisplayOne(HEX1));  // 
    DualSevenSegmentDriver AvalDisplay (.bin(a_side[4:0]),   .DisplayTwo(HEX4), .DisplayOne(HEX5));  // 
    DualSevenSegmentDriver BvalDisplay (.bin(b_side[4:0]),   .DisplayTwo(HEX2), .DisplayOne(HEX3));  //
endmodule

//Accepts a 6 bit input, decodes a little-endian binary value to a pair of (active low) 7-segment displays.
module DualSevenSegmentDriver(
    input   [5:0] bin,     // 6-bit little endian binary value to display
    output  [6:0] DisplayTwo,   // 7-bit output for the second 7-segment display
    output  [6:0] DisplayOne  );// 7-bit output for the first 7-segment display

    // Place the top two most significant bits in a new 2-bit array
    reg     [1:0] f;
    always @(f, bin) begin
        f[0] <= bin[4];
        f[1] <= bin[5];
    end
    
    // The second hex digit can display all of the values between 0x0 and 0xF, representing the possible stages of four bits.
    // One assignment per segment of the 7-segment display, representing the outputs corresponding to each combination of four bits.
    assign DisplayTwo[0] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (bin[3] & ~bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & bin[0]);
    assign DisplayTwo[1] = (~bin[3] & bin[2] & ~bin[1] & bin[0]) | (bin[2] & bin[1] & ~bin[0]) | (bin[3] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[0]);
    assign DisplayTwo[2] = (~bin[3] & ~bin[2] & bin[1] & ~bin[0]) | (bin[3] & bin[2] & ~bin[0]) | (bin[3] & bin[2] & bin[1]);
    assign DisplayTwo[3] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (bin[2] & bin[1] & bin[0]) | (bin[3] & ~bin[2] & bin[1] & ~bin[0]);
    assign DisplayTwo[4] = (~bin[3] & bin[0]) | (~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1]);
    assign DisplayTwo[5] = (~bin[3] & ~bin[2] & bin[0]) | (~bin[3] & ~bin[2] & bin[1]) | (~bin[3] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & bin[0]);
    assign DisplayTwo[6] = (~bin[3] & ~bin[2] & ~bin[1]) | (~bin[3] & bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & ~bin[0]);

    // The first hex digit only displays the values 0x1 through 0x3, and is disabled for 0x0.
    assign DisplayOne[0] = ~f[1];
    assign DisplayOne[1] = ~f[0] & ~f[1];
    assign DisplayOne[2] = ~f[0];
    assign DisplayOne[3] = ~f[1];
    assign DisplayOne[4] = ~f[1] | f[0];
    assign DisplayOne[5] = 1;
    assign DisplayOne[6] = ~f[1];
endmodule

