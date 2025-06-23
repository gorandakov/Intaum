
module findindex12(
  input [11:0] din,
  output [11:0] dout0,
  output [3:0] dout);

  generate
    genvar a;
    for(a=0;a<12;a++) begin
        assign dout0[a]=din[a:0]==1<<a;
        assign dout=dout0[a] ? a[3:0] : 'z;
    end
  endgenerate
  assign dout=|din ? 'z : '0;
endmodule
