//BEE 271 Lab 2
//Nicholas Greenwood and Ben Rockhold

module AddingMachine(
    output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
    input [9:0] SW,
	 output [9:0] LEDR
	 );
	 
    wire    [4:0]   a_side, b_side;
    wire    [5:0]   sum;

    assign LEDR = SW;
    assign a_side = SW[9:5];
    assign b_side = SW[4:0];
    assign sum = a_side + b_side;
	 
    
    SevenSegment sum1stDigit  (sum[3:0], 1, HEX0);
	 SevenSegment sum2ndDigit  (sum[5:4], sum[5:4]!=2'b00, HEX1);
	 
    SevenSegment A1stDigit (a_side[3:0], 1, HEX4);
	 SevenSegment A2ndDigit (a_side[4], a_side[4]!=2'b00, HEX5);
	 
    SevenSegment B1stDigit (b_side[3:0], 1, HEX2);
	 SevenSegment B2ndDigit (b_side[4], b_side[4]!=2'b00, HEX3);
	 
endmodule


module SevenSegment(input [3:0] bin, input enable, output [6:0] display);
  wire [6:0] s;
	 
  //if (enable) is just not working
  assign s[0] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (bin[3] & ~bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & bin[0]);
  assign s[1] = (~bin[3] & bin[2] & ~bin[1] & bin[0]) | (bin[2] & bin[1] & ~bin[0]) | (bin[3] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[0]);
  assign s[2] = (~bin[3] & ~bin[2] & bin[1] & ~bin[0]) | (bin[3] & bin[2] & ~bin[0]) | (bin[3] & bin[2] & bin[1]);
  assign s[3] = (~bin[3] & ~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1] & ~bin[0]) | (bin[2] & bin[1] & bin[0]) | (bin[3] & ~bin[2] & bin[1] & ~bin[0]);
  assign s[4] = (~bin[3] & bin[0]) | (~bin[2] & ~bin[1] & bin[0]) | (~bin[3] & bin[2] & ~bin[1]);
  assign s[5] = (~bin[3] & ~bin[2] & bin[0]) | (~bin[3] & ~bin[2] & bin[1]) | (~bin[3] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & bin[0]);
  assign s[6] = (~bin[3] & ~bin[2] & ~bin[1]) | (~bin[3] & bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & ~bin[1] & ~bin[0]);

  assign display = enable ? s : 7'b1111111;  //~0 should also work
  
	 
endmodule

