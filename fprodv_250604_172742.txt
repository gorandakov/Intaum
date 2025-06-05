module fprod65(
);

assign prodA={1'b1,A_reg2[52:0]}*{1'b1,B_reg2[52:0]}+rnd<<53;

assign prodB={1'b1,A_reg2[52:0]}*{1'b1,B_reg2[52:0]}+rnd<<52;

assign res[52:0]=prodA[107] | prodB[107] ? prodA[107:54] : prodB[106:53];
assign {c,ae}=A[62:53]+B[62:53]-bias;
assign res[62:53]=ae|{10{c}};
assign res[63]=A[63]^B[63];