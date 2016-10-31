module AddingMachine(
    //Each hex bit has its own 7-segment array
    output  [6:0]    HEX0,  // Second digit of the sum
    output  [6:0]    HEX1,  // First digit of the sum
    output  [6:0]    HEX2,  // Second digit of the second input value ("B")
    output  [6:0]    HEX3,  // First digit of "B" input
    output  [6:0]    HEX4,  // Second digit of the first value ("A")
    output  [6:0]    HEX5,  // First digit of the "A" input
    //10 switches
    input   [9:0]   SW,     // 10 value-input switches
    //10 LEDs corresponding to the switches
    output  [9:0]   LEDR    );
    wire    [4:0]   a_side, b_side;  //5 bits each
    wire    [5:0]   sum;             //6 bits

    assign LEDR = SW;           // Use LEDs for visual switch state feedback
    assign a_side = SW[9:5];    // Left half of the input switches (5 total) encode the value of the first number to add.
    assign b_side = SW[4:0];    // Right half of the input switches (5 total) encode the value of the second number to add.
    assign sum = a_side + b_side;//The sum of the first and second values.

    SevenSegment sumDisplay  (.b(sum[5:0]),      .s1(HEX0), .s2(HEX1));  // 
    SevenSegment AvalDisplay (.b(a_side[4:0]),   .s1(HEX4), .s2(HEX5));  // 
    SevenSegment BvalDisplay (.b(b_side[4:0]),   .s1(HEX2), .s2(HEX3));  //
endmodule

//Accepts a 6 bit input, decodes a little-endian binary value to a pair of 7-segment displays.
module SevenSegment(
    input  [5:0] b,     // 5-bit little endian binary value to display
    output [6:0] s1,
    output [6:0] s2  );
    reg [1:0] f;
    
    //Place bits 5 and 6 in a new 2-bit array
    always @(f, b) begin
        f[0] <= b[4];
        f[1] <= b[5];
    end
    
    // The second hex digit can display all of the values between 0x0 and 0xF, representing the possible stages of four bits.
    // One assignment per segment of the 7-segment display, representing the outputs corresponding to each combination of four bits.
    assign s1[0] = (~b[3] & ~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1] & ~b[0]) | (b[3] & ~b[2] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & b[0]);
    assign s1[1] = (~b[3] & b[2] & ~b[1] & b[0]) | (b[2] & b[1] & ~b[0]) | (b[3] & b[1] & b[0]) | (b[3] & b[2] & ~b[0]);
    assign s1[2] = (~b[3] & ~b[2] & b[1] & ~b[0]) | (b[3] & b[2] & ~b[0]) | (b[3] & b[2] & b[1]);
    assign s1[3] = (~b[3] & ~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1] & ~b[0]) | (b[2] & b[1] & b[0]) | (b[3] & ~b[2] & b[1] & ~b[0]);
    assign s1[4] = (~b[3] & b[0]) | (~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1]);
    assign s1[5] = (~b[3] & ~b[2] & b[0]) | (~b[3] & ~b[2] & b[1]) | (~b[3] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & b[0]);
    assign s1[6] = (~b[3] & ~b[2] & ~b[1]) | (~b[3] & b[2] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & ~b[0]);

    // The first hex digit only displays the values 0x1 through 0x3, and is disabled for 0x0.
    assign s2[0] = ~f[1];
    assign s2[1] = ~f[0] & ~f[1];
    assign s2[2] = ~f[0];
    assign s2[3] = ~f[1];
    assign s2[4] = ~f[1] | f[0];
    assign s2[5] = 1;
    assign s2[6] = ~f[1];
endmodule

