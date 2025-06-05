module fadd64(
  );
  assign AB0={1'b1,A[52:0]}-{1'b1,B[52:0]};
  assign BA0={1'b1,B[52:0]}-{1'b1,A[52:0]};

  assign AB1={1'b1,A[52:0],rnd}-{2'b1,B[52:0]};
  assign BA1={1'b1,B[52:0],rnd}-{2'b1,A[52:0]};

 assign ABExp=A[62:53]-B[62:53];
 assign BAExp=B[62:53]-A[62:53];
 assign age=cABExp && !ABeq | cAB0;
 assign ABeq=A[62:53]==B[62:53];

 assign S=ABeq && age ? AB0 : z;
 assign S=ABeq && !age ? BA0 : z;
 assign S=!ABeq && age ? AB1 : z;
 assign S=!ABeq && !age ? BA1 : z;

 assign shAB=({1'b1,B[52:0],2'b0}^{54{sxor}})>>ABexp;
 assign shBA=({1'b1,A[52:0],2'b0}^{54{sxor}})>>BAexp;
 assign sxor=A[63]^B[63];

find_first_bit nrm(S_reg,pfs,s_has);
assign shar=age ? shAB&bz : shBA&ba;
assign shn=age ? {1'b1,A[52:0],rnd} &ba: {1'b1,B[52:0],rnd}&bz;
assign shn2=age ? {1'b1,A[52:0],1'b0,rnd} : {1'b1,B[52:0],1'b0,rnd};
assign res_sh=shn_reg + shar_reg[55:0];
assign res_sh2=shn2_reg + shar_reg;
assign res_dn=S_reg << pfs;
assign res[52:0]=(!ABeq && !ABone || !sxor ) && res_sh[54]  ? res_sh[53:1] : 'z;
assign res[52:0]=(!ABeq && !ABone || !sxor ) && res_sh[54:53]==1  ? res_sh[52:0] : 'z;
assign res[52:0]=(!ABeq && !ABone || !sxor ) && res_sh[54:53]==0  ? res_sh2[51:-1] : 'z;
assign res[52:0]=!(!ABeq && !ABone || !sxor )   ? res_dn : 'z;

assign res[62:53]=(!ABeq && !ABone || !sxor ) && res_sh[54]  ? aegis + 1: 'z;
assign res[62:53]=(!ABeq && !ABone || !sxor ) && res_sh[54:53]==1  ? aegis: 'z;
assign res[62:53]=(!ABeq && !ABone || !sxor ) && res_sh[54:53]==0  ? aegis-1 : 'z;
assign res[62:53]=!(!ABeq && !ABone || !sxor )  ? (aegis-pfs)&zux : 'z;
assign zux=aegis<pfs ? '0 : '1;

assign bz=B[62:53]==0 ? '0 : '1;

assign ba=A[62:53]==0 ? '0 : '1;