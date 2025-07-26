
module bit_find_index12r(
  input [11:0] din,
  output [11:0] dout0,
  output [3:0] dout,
  output has);

  generate
    genvar a;
    for(a=0;a<12;a++) begin
        assign dout0[a]=din[11:a]==1<<(11-a);
        assign dout=dout0[a] ? 4'd11-a[3:0] : 'z;
    end
  endgenerate
  assign dout=|din ? 'z : '0;
  assign has=|din;
endmodule
