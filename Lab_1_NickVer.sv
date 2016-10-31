module AddingMachine(
    //Each hex bit has its own 7-segment array
    output	[6:0]		HEX0,  //HEXAdigit2
    output	[6:0]		HEX1,  //HEXAdigit1
    output	[6:0]		HEX2,  //HEXBdigit2
    output	[6:0]		HEX3,  //HEXBdigit1
    output	[6:0]		HEX4,  //HEXCdigit2
    output	[6:0]		HEX5,  //HEXCdigit1
    //10 switches
    input   [9:0]		SW,
    //10 LEDs corresponding to the switches
    output  [9:0]       LEDR    );
    wire [4:0] a_side, b_side;  //5 bits each
    wire [5:0] sum;             //6 bits

    assign LEDR = SW;           // Use LEDs for visual switch state feedback
    assign a_side = SW[9:5];    // Left half of the input switches (5 total) encode the value of the first number to add.
    assign b_side = SW[4:0];    // Right half of the input switches (5 total) encode the value of the second number to add.
    assign sum = a_side + b_side;//The sum of the first and second values.

    SevenSegment HexCDigit1 (.b(sum[5:0]), .s1(HEX0), .s2(HEX1));     // 
    SevenSegment HexBDigit1 (b_side[4:0], HEX2, HEX3);  // 
    SevenSegment HexADigit1 (a_side[4:0], HEX4, HEX5);  // 
endmodule

//Accepts a 6 bit input, decodes a little-endian binary value to a pair of 7-segment displays.
module SevenSegment(
    input [5:0] b,              // 5-bit little endian binary value to display
    input zeroSuppress = 1'b0, // Whether or not to suppress the display of leading zeros
    output [6:0] s1,
    output[6:0] s2   );
    reg [1:0] f;
    
    // The second hex digit can display all of the values between 0x0 and 0xF, representing the possible stages of four bits.
    // One assignment per segment of the 7-segment display, representing the outputs corresponding to each combination of four bits.
    assign s1[0] = (~b[3] & ~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1] & ~b[0]) | (b[3] & ~b[2] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & b[0]);
    assign s1[1] = (~b[3] & b[2] & ~b[1] & b[0]) | (b[2] & b[1] & ~b[0]) | (b[3] & b[1] & b[0]) | (b[3] & b[2] & ~b[0]);
    assign s1[2] = (~b[3] & ~b[2] & b[1] & ~b[0]) | (b[3] & b[2] & ~b[0]) | (b[3] & b[2] & b[1]);
    assign s1[3] = (~b[3] & ~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1] & ~b[0]) | (b[2] & b[1] & b[0]) | (b[3] & ~b[2] & b[1] & ~b[0]);
    assign s1[4] = (~b[3] & b[0]) | (~b[2] & ~b[1] & b[0]) | (~b[3] & b[2] & ~b[1]);
    assign s1[5] = (~b[3] & ~b[2] & b[0]) | (~b[3] & ~b[2] & b[1]) | (~b[3] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & b[0]);
    assign s1[6] = (~b[3] & ~b[2] & ~b[1]) | (~b[3] & b[2] & b[1] & b[0]) | (b[3] & b[2] & ~b[1] & ~b[0]);

    //Convert bits 5 and 6 to a new 2-bit array
    always @(f, b) begin
        f[0] <= b[4];
        f[1] <= b[5];
    end

    // The first hex digit only displays "1," under the condition that the value is greater than 0xF.
    // Otherwise, it is inactive, as no sum of values can be greater
    assign s2[0] = ~f[1];
    assign s2[1] = ~f[0] & ~f[1];
    assign s2[2] = ~f[0];
    assign s2[3] = ~f[1];
    assign s2[4] = ~f[1] | f[0];
    assign s2[5] = 1;
    assign s2[6] = ~f[1];
endmodule

