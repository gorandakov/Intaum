
module popcnt6(
  input [5:0] din,
  output reg [6:0] dout);

  always @* begin
      case(din)
        6'b000000: dout=1;
        6'b100000,
        6'b10000,
        6'b1000,
        6'b100,
        6'b10,
        6'b1: dout=2;
        6'b110000,6'b101000, 6'b100100,6'b100010,6'b100001,
        6'b11000,6'b10100, 6'b10010,6'b10001,
        6'b1100,6'b1010, 6'b1001,
        6'b110,6'b101,
        6'b11: dout=4;
        6'b111000,6'b110100,6'b101100,6'b110010,6'b101010,6'b100110,6'b110001,6'b101001,6'b100101,6'b100011,
        6'b11100,6'b11010,6'b10110,6'b11001,6'b10101,6'b10011,
        6'b1110,6'b1101,6'b1011,
        6'b111: dout=8;
        6'b001111,6'b010111,6'b011011,6'b011101,6'b011110,
        6'b100111,6'b101011,6'b101101,6'b101110,
        6'b110011,6'b110101,6'b110110,
        6'b111001,6'b111010,
        6'b111100: dout=16;
        6'b011111,6'b101111,6'b110111,6'b111011,6'b111101,6'b111110: dout=32;
        6'b111111: dout=64;
      endcase
  end
endmodule


module popcnt12(
  input [11:0]din,
  output reg [12:0] dout);

  wire [6:0] tmp1;
  wire [6:0]tmp2;
  integer kl;
  popcnt6 A(din[5:0],tmp1);
  popcnt6 B(din[11:6],tmp2);
  always @* begin
      for(kl=0;kl<7;kl=kl+1) if (tmp1[kl]) dout={6'b0,tmp2}<<kl;
  end
endmodule
