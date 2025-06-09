/* 
The country: since the country is the rich and their kids,
the country is not welcome here. It is not the country project.
also not donation of puppies to us corporations.
also is not an os roulette.
not an open source clicksword.
not a Microsoft shill.
not a Google praendtl.
I don't hold patents on this and don't intend to.
not a linux peacock.
not a voodo broddo.
not a doss munchey.
not a olga volga .
not a dako muscovite.
not an apple cruscokh .
not a royal crunch.
*/
module frontend (
  );
  function flcond;
    input [3:0] cond;
    input [3:0] FL;
    case (cond)
      0: flcond=cond[3];
      1: flcond=cond[3]^1;
      2: flcond=cond[3]^cond[0];
      3: flcond=cond[3]^cond[0]^1;
      4: flcond=cond[2];
      5: flcond=cond[2]|cond[0];
      6: flcond=cond[2]^1;
      7: flcond=cond[2]^1&~cond[0];
      8: flcond=cond[0];
      9: flcond=cond[0]^1;
      10: flcond=cond[1];
      11: flcond=1'b1;
      12: flcond=cond[1]^1;
      13: flcond=cond[1]^1&~cond[0];
      14: ~cond[3]&&^cond[2:1];//pointer set
      15: !(~cond[3]&&^cond[2:1]); //pointer clear
    endcase
  endfunction

  function is_wconfl;
      input [63:0] addr_aligned;
      input [4:0] flag_aligned;
      input [63:0] addrl;
      input [4:0] flagkl;
      begin
          is_wconfl=addr_aligned[63:3]==addrl[63:3] && flagkl[4] && flagkl[2] && flag_aligned[2];
          if (addr_aligned[2:0]>(addrl[2:0]+(1<<flagkl[1:0]))) is_wconfl=0;
          if (addrl[2:0]>(addr_aligned[2:0]+(1<<flag_aligned[1:0]))) is_wconfl=0;
      end
  endfunction

  function is_lconfl;
      input [63:0] addr_aligned;
      input [4:0] flag_aligned;
      input [63:0] addrl;
      input [4:0] flagkl;
      begin
          is_lconfl=addr_aligned[63:3]==addrl[63:3] && ~flagkl[4] && flagkl[3] && flag_aligned[2];
          if (addr_aligned[2:0]>(addrl[2:0]+(1<<flagkl[1:0]))) is_lconfl=0;
          if (addrl[2:0]>(addr_aligned[2:0]+(1<<flag_aligned[1:0]))) is_lconfl=0;
      end
  endfunction

  function bndnonred;
      input [20:0] from;
      input [20:0] to;
      bndnonred=to[5:0]<=from[5:0] && {1'b0,from[19:13]}<={from[20]^to[20],to[19:13]} && from[12:6]>=to[12:6];
  endfunction

  function addition_check;
      input [20:0] cookie;
      input [42:0] val0;
      input [42:0] addend;
      input protect_cookie;
      input isand;
      reg [42:0] boogie;
      reg on_low;
      begin
          boogie=addend>>cookie[5:0];
          val1=val0>>cookie[5:0];
          on_low=boogie[8]==cookie[20];
          byone=(val1>>7)==1;
          byminus=(val1>>7)=='1;
          byzero=(val1>>7)=='0;
          if (on_low) begin
            addition_check=(boogie[6:0]+val1[6:0])>=cookie[19:13]-!protect_cookie;
              if (cookie[12:6]>cookie[19:13] && (boogie[6:0]+val1[6:0])>cookie[12:6])
                  addition_check=0;
            if (!byone && !byzero || isand & byminus)
                addition_check=0;
          end else begin
            addition_check=(boogie[7:0]+val1[7:0])>=cookie[20:13]-!protect_cookie;
              if (cookie[12:6]>cookie[19:13] && (boogie[6:0]+val1[6:0])>cookie[12:6])
                  addition_check=0;
            if (!byminus && !byzero&!isand)
                addition_check=0;
          end
      end
  end
  reg [15:0][9:0] rTT;
  reg [65535:0][1:0] predA;
  reg [65535:0][1:0] predB;
  reg [65535:0][1:0] predC;
  reg [(1<<24)+(1<<9)-1:0][65:0] htlb;
  always @(posedge clk) begin
      if (!ins_addr[0][42:37]) ins_addr[1]<=htlb[{ci,ins_addr[0][36:15]}];
      if (isret) glptr<=htlb[1<<24+sttop];
      if (iscall) begin
          htlb[1<<24+sttop+1]<=glptr;
          htlb[1<<24+sttop+257]<=lastIP+5;
      end
  end
    
  assign pred_en=predA[IP[17:5],GHT[1:0]]^predB[IP[12:5],GHT[7:0]]^predC[IP[6:5],GHT[13:0]]||ucjmp;
  assign tbuf=tbufl[IP[13:5]];
  assign jen[0]=tbuf[0][43] && IP[42:4]==tbuf[0][82:44];
  assign jen[1]=tbuf[1][43] && IP[42:4]==tbuf[1][82:44];
  assign iscall=jen[0] && tbuf[0][83] || jen[1] && tbuf[1][83];
  assign isret=jen[0] && tbuf[0][84] || jen[1] && tbuf[1][84];
  assign ucjmp=jen[0] && tbuf[0][85] || jen[1] && tbuf[1][85];
  always @(posedge clk) begin
      if (rst) begin
          IP<=init_IP;
      end else if (&jen[1:0]) begin
        if (pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        else if (pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=tbuf[1][IP[12:4]][42:0]; if (tbuf[1][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+16; end
      end else if (^jen[1:0]) begin
        if (pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        //else if (pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=tbuf[1][IP[12:4]][42:0]; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+16; end
      end else begin
          IP=IP+16;
      end
      if (jretire[0] && except) begin
        tbuf[0][IP[12:4]]={retSRCIP[63:13],retIP[0][63:13]};
          if (jmispred) begin
              if ($random()&0x3==0x3) predA[retSRCIP[13:0],retGHT[1:0]]~=2'b1;
              if ($random()&0xf==0xf) predB[retSRCIP[7:0],retGHT[7:0]]~=2'b1;
              if ($random()&0xff==0xff) predC[retSRCIP[1:0],retGHT[13:0]]~=2'b1;
              GHT<=retGHT;
              tbufl[retSRCIP[13:5]][0]={retJPR0,1'b1,retSRCIP,retIPA};
           end
      end else if (jretire[1] && except) begin
        tbuf[1][IP[12:4]]={retSRCIP[63:13],retIP[1][63:13]};
          if (jmispred) begin
              if ($random()&0x3==0x3) predA[retSRCIP[13:0],retGHT[1:0]]~=2'b10;
              if ($random()&0xf==0xf) predB[retSRCIP[7:0],retGHT[7:0]]~=2'b10;
              if ($random()&0xff==0xff) predC[retSRCIP[1:0],retGHT[13:0]]~=2'b10;
              GHT<=retGHT;
              tbufl[retSRCIP[13:5]][1]={retJPR1,1'b1,retSRCIP,retIPB}
          end
      end
  end
  generate
      genvar fu,fuB;
      genvar way;
      genvar line;
      genvar PHY;
    for(PHY=0;PHY<10;PHY=PHY+1) begin : phy
      reg [31:0] insn_clopp;

      for(fu=0;fu<12;fu=fu+1) begin : funit
          reg [63:0][63:0] data_gen;
          reg [63:0][63:0] data_fp;
          reg [63:0][63:0] data_imm;
          reg [63:0][16:0] data_op;
          reg [63:0][6:0] cloopbndloff;
          reg [39:0] insn;
          reg [63:0][5:0] data_imm_phy;
          reg [63:0][5:0] rdy; //port lsu/alu=bits 2:1 a,b; port store data=bit 0,A,B; upper 3 bits=needed bits
          reg [63:0][4+5:0] rdyA;
          reg [63:0][4+5:0] rdyB;
          reg [63:0] free;
          wire [4+5:0] rA;
          wire [4+5:0] rB;
          wire [4+5:0] rBX;
          wire [4+5:0] rFL;
          wire rA_en, rB_en;
          wire [65:0] dataA;
          wire [65:0] dataB;
          wire [65:0] dataBIX;
          wire [65:0] dataBI;
          wire [1:0] data_phy;
          wire [63:0] res;
          wire [7:0] opcode;
          wire [4:0] cond;
          wire cond_tru;
          reg [63:0][63:0] dreqmort;
          reg [63:0][65:0] dreqdata;
          reg [63:0][4:0] dreqmort_flags;
          reg [63:0][3:0] dreqdata_flags;
          bit_find_index indexLSU_ALU(rdy[63:0][2]&rdy[63:0][1]&{64{~phy[PHY].funit[(fu+1)%12].is_mul_reg3}},indexFU,indexFU_has);
          bit_find_index indexLDU(rdy[63:0][0],indexLDU,indexLDU_has);
          bit_find_index indexAlloc(free,rT[5:0],rT_en0);
          bit_find_indexR indexAlloc2(free,rTm[5:0],rTm_en0);
          bit_find_index indexST(dreqmort_flags[63:0][4] && dreqmort_flags[63:0][2] && {64{sten[fu]}},indexST,indexST_has);
          fpuadd64 Xadd(clk,rst,dataAF,dataBF,rnd,xaddres);
          fpuprod64 Xmul(clk,rst,dataAF,dataBF,rnd,xmulres);
          assign ret0[fu][PHY]=!data_retFL[RETI][0];
          assign ret1[fu]=&ret0[fu];
          assign rT[9:6]=fu;
          assign rT_en=opcode[5] && rT_en0;
          assign ldsize=1<<opcode[9:8]-1;
          assign ldsizes=ldsize & {3{opcode[10]}};
          assign LQ=opcode[16:11];
          assign LQX=opcodex[16:11];
          assign op_anx=opcode[7:5]==0 && |opcode[10:9];
          assign opand=opcode[7:5]!=0;
          assign jindir=fu!=10 && !opcode[10];
          assign dataA[31:0]=phy[PHY].funit[rA[9:6]].data_gen[rA[5:0]][31:0] & {32{opand}};
          assign dataB[31:0]=phy[PHY].funit[rB[9:6]].data_gen[rB[5:0]][31:0];
          assign dataBI[31:0]=phy[PHY].funit[rT[9:6]].data_imm[rT[5:0]][31:0]*(data_phy+1);
          assign data_phy[31:0]=phy[PHY].funit[rT[9:6]].data_imm_phy[rT[5:0]][31:0];
          assign dataBX[31:0]=phy[PHY].funit[rBX[9:6]].data_gen[rBX[5:0]][31:0];
          assign dataA[63:32]=phy[PHY].funit[rA_reg[9:6]].data_gen[rA_reg[5:0]][63:32] & {34{opand_reg}};
          assign dataB[63:32]=phy[PHY].funit[rB_reg[9:6]].data_gen[rB_reg[5:0]][63:32];
          assign dataAF[63:0]=phy[PHY].funit[rA_reg3[9:6]].data_gen[rA_reg3[5:0]][63:0];
          assign dataBF[63:0]=phy[PHY].funit[rB_reg3[9:6]].data_gen[rB_reg3[5:0]][63:0];
          assign dataBI[63:32]=phy[PHY].funit[rT_reg[9:6]].data_imm[rT_reg[5:0]][63:0]*(data_phy+1)>>32;
          assign dataBX[63:32]=phy[PHY].funit[rBX_reg[9:6]].data_gen[rBX_reg[5:0]][63:32];
          assign dataFL=phy[PHY].funit[rFL[9:6]].data_fl[rFL[5:0]][3:0];
          assign cond_tru=flcond(cond[3:0],dataFL);
          assign {c32,res[31:0]}=opcode[7:0]==0 && cond_tru ?
            dataA[31:0]+dataB[31:0]^{32{dataBI[20]}}+dataBI[21] : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==0 && cond_tru_reg ?
           {dataA[63]~!chk,dataA[63:32]}+{dataB[63],dataB[63:32]}^
            {32{c32_reg}}+c32_reg : 'z;
          assign {c32,res[31:0]}=(opcode[7:2]==1 || opcode[7:3]==1) 
               && cond_tru  ?
             res_shift[32:0] : 'z;
          assign {s64,c64,res[63:32]}=(opcode_reg[7:2]==1 || opcode_reg[7:3]==1) 
              && cond_tru_reg ?
             {1'b0,res_shift[64:32]}&{33{opcode[7:2]==1}}|{33{opcode[7:2]!=1 && res_shift_reg[31]}} : 'z;
          assign {c32,res[31:0]}=opcode[7:3]==2 && cond_tru ?
             {1'b0,res_logic[31:0]} : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:3]==2 && cond_tru_reg ?
          {dataA_reg[65:64]|{!isand_reg|!chk,1'b0},res_logic[64:32]} : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==1 && cond_tru ?
            {1'b0,res_sxt[31:0]} : 'z;
          assign {s64,c64,res[63:32]}=opcode_reg[7:0]==1 && cond_tru_reg ?
            {res_sxt[63],res_sxt[64:32]} : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==2 && cond_tru ?
            dataA[31:0]+dataBI[31:0] : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==2 && cond_tru_reg ?
            {dataA[63]|~chk,dataA[63:32]}+op_anx_reg ? 0 : {dataBI[63],dataBI[63:32]} + c32: 'z;
          assign {c32,res[31:0]}=opcode[7:0]==3 && cond_tru ?
            op_anx ? 1 : dataBI[31:0] : 'z;
          assign chk=addition_check(dataA[63:43],{dataA[42:32],dataA_reg[31:0]},{dataBIX[42:32],dataBIX_reg[31:0]},opcode_reg[11],isand)
             || ~dataA_reg[65] || ^dataA_reg[64:63];
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==3 && cond_tru_reg ?
            {1'b0,dataBI[63],dataBI[63:32]} : 'z;
          assign res_logic[31:0]=opcode[2:1]==0 &~foo ? dataA[31:0]&dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==1 &~foo ? dataA[31:0]^dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==3 &~foo ? dataA[31:0]|dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==2 &~foo ? phy[(LOOPSTOP+dataBIX[1:0])%4].dataA[31:0] 
              : 'z;
          assign res_logic[31:0]=foo ? dataA[31:0] :'z;

          assign res_logic[63:32]=opcode_reg[2:1]==0 &~foo_reg ? dataA[63:32]&dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==1 &~foo_reg ? dataA[63:32]^dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==3 &~foo_reg ? dataA[63:32]|dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==2 &~foo_reg ? phy[(LOOPSTOP+dataBIX_reg[1:0])%4].dataA[63:32] 
              : 'z;
          assign res_logic[63:32]=foo_reg & bndnonred(dataA[63:43],{opcode_reg[2:1],dataBI_reg[18:0]}) ? {opcode_reg[2:1],dataBI_reg[18:0],dataA[42:32]};
          assign res_logic[63:32]=foo_reg & ~bndnonred(dataA[63:43],{opcode_reg[2:1],dataBI_reg[18:0]}) ? dataA[63:32];

          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2]==0 ? dataA_reg3[31:0]*dataBIX_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2:1]==2'b10 ? dataAS_reg3[31:0]*dataBIXS_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2:1]==2'b11 ? dataAS_reg3[63:0]*dataBIXS_reg3[63:0]>>22 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==0 ? dataA_reg4[63:0]*dataBIX_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==1 ? {32{res_mul_reg[31]}} : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==2'b10 ? dataAS_reg4[63:0]*dataBIXS_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==2'b11 ? dataAS_reg4[63:0]*dataBIXS_reg4[63:0]>>54 : 'z;
          assign val_else[31:0]=opcode[12:11]==0 ? dataA[31:0] : 'z;
          assign val_else[31:0]=opcode[12:11]==1 ? 1 : 'z;
          assign val_else[31:0]=opcode[12:11]==2 ? 0: 'z;
          assign val_else[31:0]=opcode[12:11]==3 ? '1 : 'z;
          assign val_else[65:32]=opcode[12:11]==0 ? dataA[65:32] : 'z;
          assign val_else[65:32]=opcode[12:11]==1 ? 1<<33+1 : 'z;
          assign val_else[65:32]=opcode[12:11]==2 ? 1<<33 : 'z;
          assign val_else[65:32]=opcode[12:11]==3 ? 34'h1_ffff_ffff : 'z;
          assign val_sxt[31:0]=dataBI[25:24]!=3 ? dataA[31:0]<<(8<<dataBI0[25:24])>>>(8<<dataBI0[25:24]) : {dataA[7:0],dataA[15:8],dataA[23:16],dataA[31:24]};
          assign val_sxt[63:0]=dataBI_reg[25:24]!=3 ? dataA_reg[31:0]<<(8<<dataBI[25:24])>>>(8<<dataBI[25:24])>>>32 : {32{dataA_reg}};
          always @(posedge clk) begin
              if (rst) sten<=12'hf; else sten<={sten[7:0],sten[12:8]};
              dataA_reg[63:32]<=dataA[63:32];
              dataA_rexx[31:0]<=dataA[31:0];
              dataA_reg[31:0]<=dataA_rexx[31:0];
              dataA_reg2<=dataA_reg;
              dataA_reg3<=dataA_reg2;
              dataAS_reg3<=dataA_reg2;
              dataA_reg4<=dataA_reg3;
              dataAS_reg4<=dataAS_reg4;
              dataBIX_reg[63:32]<=dataBIX[63:32];
              dataBIX_rexx[31:0]<=dataBIX[31:0];
              dataBIX_reg[31:0]<=dataBIX_rexx[31:0];
              dataBIX_reg2<=dataBIX_reg;
              dataBIX_reg3<=dataBIX_reg2;
              dataBIXS_reg3<=dataBIX_reg2;
              dataBIX_reg4<=dataBIX_reg3;
              dataBIXS_reg4<=dataBIXS_reg4;
              opcode_reg<=opcode;
              opcode_reg2<=opcode_reg;
              opcode_reg3<=opcode_reg2;
              opcode_reg4<=opcode_reg3;
              opcode_reg5<=opcode_reg4;
              rA<=rdyA[indexLSU_ALU];
              rB<=rdyB[indexLSU_ALU];
              rBX<=rdyB[indexLDU];
              rT<={fu,indexLSU_ALU};
              rTMem<=rdyM[indexLSU_ALU];
              opcode<=data_op[indexLSU_ALU];
              opcodex<=data_op[indexLDU];
              if (except) begin 
                  rTT<=rTTB;
                  rTTE<='1;
                  rdy<='0;
              end
              if (retire && retire_bndl && read_ret) begin
                  rTTE[retROLD][1]<=1'b1;
                  rTTB[retRNEW_arch]<=retRNEW;
              end
              if (rT_en0_reg | rT_en_reg && |opcode_reg[7:6]) begin
                  dreqmort[LQ][31:0]<=res[31:0];
                  dreqmord_flags[LQ]<={sterror,opcode_reg[7:6],opcode_reg[1:0]};
              end
              if (rT_en0_reg2 | rT_en_reg2 && |opcode_reg2[7:6]) begin
                  dreqmort[LQ][63:32]<=res[63:32];
                 // dreqmord_flags[LQ]<={opcode_reg[7:6],opcode_reg[9:8]};
              end
              if (indexLDU_has_reg) begin
                  dreqdata[LQX][31:0]<=res[31:0];
                  dreqdata_flags[LQX]<={2'b01,2'b0};
              end
              if (indexLDU_has_reg2) begin
                  dreqdata[LQX][63:32]<=res[63:32];
                  //dreqdata_flags[LQX]<={2'b01,2'b0};
              end
              for(fu3=0;fu3<12;fu3++) for(sch=0;sch<64;sch=sch+1) begin
                  if (rT_en && funit[fu3].rdyB[sch]==rT && funit[fu3].rdy[sch][5]) funit[fu3].rdy[sch][2]=1'b1; 
                  if (rT_en && funit[fu3].rdyB[sch]==rT && funit[fu3].rdy[sch][3]) funit[fu3].rdy[sch][0]=1'b1;
                  if (rT_en && funit[fu3].rdyA[sch]==rT && funit[fu3].rdy[sch][4]) funit[fu3].rdy[sch][1]=1'b1;
              end
              aligned[PHY][fu]<=|dreqmort_flags[LDI][4:3];
              if (&aligned) begin
                  dreqmort_flags[LDI_reg][4]<=~dreqmort_flags[LDI][5];
              end
              instr<=poo_c_reg2;
              instr_clopp<=poo_c2_reg2;
              if (rT_en_reg) data_gen[rT_reg[5:0]][31:0]<=res[31:0];
              if (rT_en0_reg3 && opcode[7]) data_gen[rTMem_reg2[5:0]][31:0]<=pppoe_reg[31:0];
              if (rT_en0_reg3 && opcode[7:3]==3) data_gen[rTMem_reg2[5:0]][31:0]<=res_mul[31:0];
              if (rT_en_reg2) data_gen[rT_reg2[5:0]][65:32]<={c64,s64,res[63:32]};
            if (rT_en_reg2) data_genFL[rT_reg2[5:0]][3:0]<=opcode_reg2[7:0]==1 && dataBI_reg2[22] ? {dataAF[65:63],~|dataAF[62:53]} : {c64,s64,res[63],~|resX[63:0]]};
              if (rT_en_reg2) data_retFL[LQ_reg][3:0]<=opcode_reg2[7:5]==0 ? {dataAF[65:63],~|dataAF[62:53]} : {c64,s64,res[63],~|resX[63:0]],1'b0};
              if (rT_en_reg5 &&(opcode_reg4[7:6]=0 && opcode_reg4[4:0]==1 && dataBI_reg4[20])) data_fpu[rT_reg5[5:0]]<=xaddres;
              if (rT_en_reg6 &&(opcode_reg5[7:6]=0 && opcode_reg5[4:0]==1 && dataBI_reg5[21])) data_fpu[rTMem_reg6[5:0]]<=xmulres;
              if (rT_en_reg6 &&(opcode_reg5[7] && dataBI_reg5[21])) data_fpu[rTMem_reg6[5:0]]<=pppoe_reg4;
              if (rT_en0_reg4 && opcode_reg3[7:3]==3) data_gen[rTMem_reg3[5:0]][65:32]<=res_mul[63:32];
              if (insert_en && (fu>=insn_cloop[3:0] && IP[4:0]==insn_cloop[9:5])|
                    (fu>=insn_cloop[13:10] && IP[4:0]==insn_cloop[19:15])|
                    (fu>=insn_cloop[23:10] && IP[4:0]==insn_cloop[29:25])  ) begin
                  data_op[alloc][7:6]=instr[39:38];
                  if (&instr[39:38]) data_op[alloc][7:6]=2'b0;
                 if (instr[39:38]==2'b10 && |instr[13:12]) begin
                   data_imm[alloc]=&instr[13:12] ? ret_cookie : {instr[37:14],instr[11:0]};
                      data_op[alloc][11]<=instr[12]; //1=call 0=jump
                      data_cond[alloc]=instr[37:34];
                      data_op[10:8]=instr[32:30];
                  else if (^instr[39:38]) begin
                      data_op[alloc][10:8]=instr[37:35];
                      data_op[alloc][5]=instr[34];
                      data_op[alloc][4:0]=5'b1;
                      data_op[alloc][11]=instr[34];
                      data_imm[alloc]={{44{instr[32]}},instr[32:13]};
                      if (instr[12]) data_phy[alloc]=vec ? PHYCNT-1 : PHY;
                      else data_phy[alloc]=1;
                  end
                  if (&instr[39:38]) begin
                    data_op[alloc][4:0]={instr[37:34],instr[14]};
                      data_op[alloc][5]=1'b1;
                    data_cond[alloc][3:0]=instr[12:9];
                    data_imm[alloc]={{46{instr[32]}},instr[32:15]};
                  end
                  if (!|instr[39:38]) begin
                    data_op[alloc][4:0]={instr[37:32],instr[12]};
                      data_op[alloc][5]=1'b1;
                      data_cond[alloc][3:0]=instr[32:27];
                    data_imm[alloc]={{21{instr[26]}},instr[26:14],19'b0};
                  end
                  rTT[instr[3:0]]<=alloc;
                  if (instr[39:38]==2) begin
                    rTT[instr[7:4]]<=alloc2;
                    rTTOldm[INSI]<=rTT[instr[7:4]];
                    rTTNewm[INSI]<=alloc2;
                    rTTe[alloc2][0]<=1'b1;
                  end
                  rTTOld[INSI]<=rTT[instr[3:0]];
                  rTTNew[INSI]<=alloc;
                  data_retFL[INSI]<=1;
                  rTTe[alloc][0]<=1'b1;
                  rdyA[alloc]<=rTT[instr[7:4]];
                  rdyB[alloc]<=rTT[instr[11:8]];
                  rdyFL[alloc]<=rTT[instr[33]];
                  rdy[alloc]<={1'b1,instr[39],1'b1,instr[32:27]==3,instr[39]};  
                  data_op[alloc][12:11]=instr[13:12]
              end
          end
          always @* begin
                  wstall[PHY][fu]<=1'b0;
                  lderror<=64'b0;
                  for(ldi=0;ldi<64;ldi++) begin
                      if (is_wconfl(dreqmort[LDI_reg],dreqmort_flags[LDI_reg],dreqmort[ldi],dreqmort_flags[ldi]))
                          wstall[PHY][fu]<=1'b1;
                      if (is_lconfl(dreqmort[indexLDU],dreqmort_flags[indexLDU],dreqmort[ldi],dreqmort_flags[ldi]))
                          lderror[ldi]<=1'b1;
                      if (!anyhitw_reg && is_store_reg && ldi==indexLSU_ALU_reg3) begin
                          miss[ldi]=1;
                          missus[resX[16:11][PHY]=1;
                      end
                      if (!anyhit_reg && opcode_reg2[7] && ldi==indexLSU_ALU_reg3) begin
                          miss[ldi]=1;
                          missus[res_reg[16:11]][PHY]=1;
                      end
                  end
          end
      end
      reg [9:0][38:0] tr;
      for(way=0;way<8;way=way+1) begin : cache_way
          wire [11:0][65:0] poo_e;
        for(line=0;line<64;line=line+1) begin : cache_line
          reg [15:0][65:0] line_data;
          reg [1:0][52:0] tag;
             assign poo_c2[fuB]=cache_line[IP[12:7]][line][IP[6:3]][40*12+:32];
             for(fuB=0;fuB<12;fuB=fuB+1) begin : funit2
                wire [65:-64] poo_mask;
                assign poo_e[fuB]=cache_line[phy[PHY].funit[fuB].res[12:7]][line][phy[PHY].funit[fuB].res[6:3]]>>(phy[PHY].funit[fuB].res[2:0]*8)<<(phy[PHY].funit[fuB].ldsizes[2:0]*8)>>>(phy[PHY].funit[fuB].ldsizes[2:0]*8);
                assign poo_c[fuB]=cache_line[IP[12:7]][line][IP[6:3]][40*fuB+:40];
                assign poo_mask=(130'h3ffff_ffff_ffff_ffff<<(phy[PHY].funit[fuB].ldsize_reg[2:0]*8))&{phy[PHY].funit[fuB].resX[65],65'h1ffff_ffff_ffff_ffff};
                if (line==0) assign pppoe[fuB]=tag[51]&&tag[18:0][phy[PHY].funit[fuB].res[6]]=={res[31:26],res[25:13]} ? poo_e_reg && poo_mask_reg[65:0] : 'z;
                if (line==1) assign anyhit[fuB][way]==tag[51]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]==phy[PHY].funit[fuB].resX[37:6];
                if (line==3) assign anyhitW[fuB][way]==tag[52]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]==phy[PHY].funit[fuB].resX[37:6];
              //  if (line==4) assign tlbhit=tr_reg[phy[PHY].funit[fuB].resX[31:22]][37:6]==phy[PHY].funit[fuB].resX[63:37] && tr_reg[phy[PHY].funit[fuB].resX[31:22]][38];
                always @(posedge clk) begin
                  if (fuB==3 || fuB==7 || fuB==5 || fuB==11)
                    for (byte=0;byte<8;byte=byte+1)
                        if (anyhitW[fuB][way] && phy[PHY].funit[fuB].is_write_reg && phy[PHY].funit[fuB].resW[2:0]==line[5:3] && byte<phy[PHY].funit[fuB].is_write_size_reg); 
                            line_data[phy[PHY].funit[fuB].resW[6:3]]<=phy[PHY].funit[fuB].resW[8*phy[PHY].funit[fuB].resW[2:0]+:8];
                //        if (anyhitW[fuB][way] && phy[PHY].funit[fuB].is_write_reg && phy[PHY].funit[fuB].resW[2:0]==line[5:3] && byte<phy[PHY].funit[fuB].is_write_size_reg &&
                //            phy[PHY].funit[fuB].resX[63:9]=='1); 
                //            line_data[line][phy[PHY].funit[fuB].resW[6:3]]<=phy[PHY].funit[fuB].resW[8*phy[PHY].funit[fuB].resW[2:0]+:8];
                end
             end
          end
      end
    end
  endgenerate
endmodule
