module fpuadd64(
  input clk,
  input rst,
  input [63:0] A,
  input [63:0] B,
  input rnd,
  input pookm,
  output [63:0] res, 
  output [63:0] res2
  );

  

  wire [9:0] ABExp;
  wire cABExp;
  wire [9:0] BAExp;
  wire cAB0;
  wire age;
  wire ABeq;
  wire [53:0] S;
  wire sxor;
  reg sxor_reg,sxor_reg2;
  wire [55:0] shAB;
  wire [55:0] shBA;
  wire [55:0] shar;
  wire [55:0] shn;
  wire [55:0] shn2;
  wire [55:0] res_sh;
  wire [55:0] res_sh2;
  wire [53:0] res_dn;
  wire [55:0] bz;
  wire [55:0] ba;
  wire ABOne;
  wire [9:0] aegis;
  wire [5:0] pfs;
  wire [9:0] zux;
  reg [5:0] pfs_reg;
  reg [55:0] shar_reg;
  reg [55:0] shn_reg;
  reg [55:0] shn2_reg;
  reg [9:0] aegis_reg;
  reg [9:0] aegis_reg2;
  reg ABOne_reg,ABeq_reg,ABOne_reg2,ABeq_reg2;
  reg [53:0] S_reg;
  reg [55:0] res_sh_reg;
  reg [55:0] res_sh2_reg;
  reg [53:0] res_dn_reg;
  reg [9:0] zux_reg;
  reg [127:0][63:0] dsqtbl;
  wire s_has;
  assign buth=dsqtbl[{rnd,A[47+rnd+:6]}];
  // rsqrt and div table
  assign res2=pookg ? buth_reg2 : 'z;
  always @(posedge clk) begin
    shar_reg<=shar;
    shn_reg<=shn;
    shn2_reg<=shn2;
    aegis_reg<=aegis;
    aegis_reg2<=aegis_reg;
    ABOne_reg<=ABOne;
    ABeq_reg<=ABeq;
    ABOne_reg2<=ABOne_reg;
    ABeq_reg2<=ABeq_reg;
    S_reg<=S;
    pfs_reg<=pfs;
    sxor_reg<=sxor;
    sxor_reg2<=sxor_reg;
    res_sh_reg<=res_sh;
    res_sh2_reg<=res_sh2;
    res_dn_reg<=res_dn;
    zux_reg<=zux;
    buth_reg<=buth;
    buth_reg2<=buth_reg;
  end
  assign {cAB0,AB0}={1'b1,A[52:0]}-{~pookm,B[52:0]};
  
 assign {cABExp,ABExp}=A[62:53]-B[62:53];
 assign BAExp=B[62:53]-A[62:53];
 assign age=cABExp && !ABeq | cAB0;
 assign ABeq=A[62:53]==B[62:53];

 assign aegis=cABExp ? B[62:53] : A[62:53];

 
 assign shAB=({~pookm,B[52:0],2'b0}^{56{sxor}})>>ABExp;
 assign shBA=({1'b1,A[52:0],2'b0}^{56{sxor}})>>BAExp;
 assign sxor=A[63]^B[63];

  bit_find_index nrm({10'b0,res_sh},pfs,s_has);
assign shar=age ? shAB&bz : shBA&ba;
assign shn=age ? {1'b1,A[52:0],rnd,1'b0} &ba: {~pookm,B[52:0],rnd,1'b0}&bz;
assign shn2=age ? {1'b1,A[52:0],1'b0,rnd} : {~pookm,B[52:0],1'b0,rnd};
assign res_sh=shn_reg + shar_reg[55:0];
assign res_sh2=shn2_reg + shar_reg;
assign res_dn=res_sh << pfs;
assign zux=aegis_reg<{4'b0,pfs} ? '0 : '1;
  assign res[52:0]=res_dn[52:0];
  assign res[62:53]=aegis>pfs ?aegis-pfs:0;
  assign res[63]=age ? A_reg2[63] : B_reg2[63];
assign bz=B[62:53]==10'd0 ? '0 : '1;

assign ba=A[62:53]==10'd0 ? '0 : '1;

endmodule
