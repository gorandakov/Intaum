
module bit_find_index12(
  input [11:0] din,
  output [11:0] dout0,
  output [3:0] dout,
  output has);

  generate
    genvar a;
    for(a=0;a<12;a=a+1) begin
        assign dout0[a]=din[a:0]==1<<a;
        assign dout=dout0[a] ? a[3:0] : 4'bz;
    end
  endgenerate
  assign dout=|din ? 4'bz : 4'b0;
  assign has=|din;
endmodule
