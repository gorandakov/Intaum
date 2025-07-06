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
not olga dakova's spirit.
not a exchange token for getting into uni.
not a physX token.
not the source code of my person.
*/
module frontend (
  input clk
  );
  reg rst=1;
  reg rst0=1;
  always @(posedge clk) begin
      if (rst0) rst0<=0;
      else if (rst) rst<=0;
  end
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
      14: flcond=~cond[3]&&^cond[2:1];//pointer set
      15: flcond=!(~cond[3]&&^cond[2:1]); //pointer clear
    endcase
  endfunction

  function [63:0] flconv;
    input [65:0] din;
    input isdbl;
    flconv=isdbl ? {din[63:62],din[60:0],din[0]} : {din[31:30],{2{~din[30]}},din[29:0],{2{din[0]}},28'b0};
  endfunction
  function [65:0] fsconv;
    input [63:0] din;
    input [1:0] sel;
    case (sel)

      0: fsconv={2'b10,din[63:62],~din[62],din[61:1]};
      1: fsconv={2'b10,din[63:62],din[59:30]};
      default: fsconv={2'b10,din[63:0]};
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
      reg byone;
      reg byzero,byminus;
      reg [42:0] val1;
      begin
          boogie=addend>>cookie[5:0];
          val1=val0>>cookie[5:0];
          on_low=boogie[8]==cookie[20];
          byone=(boogie>>7)==1;
          byminus=(boogie>>7)=='1;
          byzero=(boogie>>7)=='0;
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
  endfunction
generate
  genvar tile_X,tile_Y;
  for(tile_X=0;tile_X<4;tile_X=tile_X+1) 
  for(tile_Y=0;tile_Y<4;tile_Y=tile_Y+1) begin : HV
  wire iscall,isret,ucjmp;
  reg [7:0] sttop;
  reg [38:0][9:0] rTT;
  reg [65535:0][1:0] predA;
  reg [65535:0][1:0] predB;
  reg [65535:0][1:0] predC;
  reg [(1<<9)-1:0][65:0] htlb;
  always @(posedge clk) begin
      if (isret) glptr<=htlb[sttop--];
      if (iscall|irqload) begin
          htlb[sttop++ +1]<=lastIP+5;
      end
  end

  wire [59:0] missx_en;
  wire [59:0][38:0] missx_addr;
  wire [59:0][59:0] missx_phy;
    
  assign pred_en=predA[{IP[17:5],GHT[1:0]}]^predB[{IP[12:5],GHT[7:0]}]^predC[{IP[6:5],GHT[13:0]}]||ucjmp;
  assign tbuf=tbufl[IP[13:5]];
  assign jen[0]=tbuf[0][43] && IP[42:4]==tbuf[0][82:44];
  assign jen[1]=tbuf[1][43] && IP[42:4]==tbuf[1][82:44];
  assign iscall=jen[0] && tbuf[0][83] || jen[1] && tbuf[1][83];
  assign isret=jen[0] && tbuf[0][84] || jen[1] && tbuf[1][84];
  assign ucjmp=jen[0] && tbuf[0][85] || jen[1] && tbuf[1][85];
  for(subPHY=0;subPHY<5;subPHY=subPHY+1) begin
  bit_find_index12 ex(~(ret1|mret1),retire_ind,retire,has_ret);
    tileXY_cl_fifo #(tile_X,tile_Y,0) busCLH (
      clk,rst,
      XH_intf_in[tile_X], 
      XH_intf_out[tile_X],
      AXH_intf_in[tile_X], 
      AXH_intf_out[tile_X],
      expun_addr_reg[37]&~random[0],
      expun_data_reg, 
      expun_addr_reg,
      {expun_addr_reg[38:37],expun_phy_reg},
      wrtXH_stall,
      insetrh_data,
      insetrh_addr,
      {insetrh_shared,insetrh_write,insetrh_phy},
      insetrh_en,
      missx_en[subPHY*12+2:subPHY*12+0],
      missx_addr[subPHY*12+2:subPHY*12+0],
      missx_phy[subPHY*12+2:subPHY*12+0],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,3) busCLV (
      clk,rst,
      XV_intf_in[tile_Y], 
      XV_intf_out[tile_Y],
      AXV_intf_in[tile_X], 
      AXV_intf_out[tile_X],
      expun_addr_reg[37]&random[0],
      expun_data_reg, 
      expun_addr_reg,
      {expun_addr_reg[38:37],expun_phy_reg},
      wrtXV_stall,
      insetrh_data,
      insetrh_addr,
      {insetrh_shared,insetrh_write,insetrh_phy},
      insetrh_en,
      missx_en[subPHY*12+5:subPHY*12+3],
      missx_addr[subPHY*12+5:subPHY*12+3],
      missx_phy[subPHY*12+5:subPHY*12+3],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,1) busCHH (
      clk,rst,
      XH_intf_in[tile_X], 
      XH_intf_out[tile_X],
      AXH_intf_in[tile_X], 
      AXH_intf_out[tile_X],
      expunh_addr_reg[37],
      expunh_data_reg, 
      expunh_addr_reg,
      {expunh_addr_reg[38:37],expunh_phy_reg},
      wrtXH_stall,
      insetrv_data,
      insetrv_addr,
      {insetrv_shared,insetrv_write,insetrv_phy},
      insetrv_en,
      missx_en[subPHY*12+8:subPHY*12+6],
      missx_addr[subPHY*12+8:subPHY*12+6],
      missx_phy[subPHY*12+8:subPHY*12+6],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,4) busCHV (
      clk,rst,
      XV_intf_in[tile_Y], 
      XV_intf_out[tile_Y],
      AXV_intf_in[tile_X], 
      AXV_intf_out[tile_X],
      expunv_addr_reg[37],
      expunv_data_reg, 
      expunv_addr_reg,
      {expunv_addr_reg[38:37],expunv_phy_reg},
      wrtXV_stall,
      insetrv_data,
      insetrv_addr,
      {insetrv_shared,insetrv_write,insetrv_phy},
      insetrv_en,
      missx_en[subPHY*12+11:subPHY*12+9],
      missx_addr[subPHY*12+11:subPHY*12+9],
      missx_phy[subPHY*12+11:subPHY*12+9],
      shareX);
  
      genvar fu,fuB;
      genvar way,way2;
      genvar line;
      genvar PHY;
    for(PHY=0;PHY<60;PHY=PHY+1) begin : phy
      reg [31:0] insn_clopp;
      assign jretire[0][PHY]=&retire_reg[7:0] && cond(jcondx0[reti_reg],jcc0[reti_reg][4:1]);
      assign jretire[1][PHY]=&retire_reg[9:0] && cond(jcondx1[reti_reg],jcc1[reti_reg][4:1]);
     
      always @(posedge clk) begin
      if (irqload|ccmiss) begin
          IP<=irqload ? irq_IP : IP_reg4;
      end else if (&jen[1:0]) begin
        if (pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        else if (pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=tbuf[1][IP[12:4]][42:0]; if (tbuf[1][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+32; end
      end else if (^jen[1:0]) begin
        if (pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        //else if (pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=tbuf[1][IP[12:4]][42:0]; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+32; end
      end else begin
          IP=IP+32;
      end
      if (|jretire[0] && except) begin
        tbuf[0][IP[12:4]]={retSRCIP[63:13],retIP[0][63:13]};
          if (jmispred) begin
              if (random&3==3) predA[{retSRCIP[13:0],retGHT[1:0]}]^=2'b1;
              if (random&4'hf==4'hf) predB[{retSRCIP[7:0],retGHT[7:0]}]^=2'b1;
              if (random&8'hff==8'hff) predC[{retSRCIP[1:0],retGHT[13:0]}]^=2'b1;
              GHT<=retGHT;
              //tbufl[retSRCIP[13:5]][0]={retJPR0,1'b1,retSRCIP,retIPA};
              IP<=jmptaken0 ? retIP[0] : retSRCIP + 32;
           end
      end else if (|jretire[1] && except) begin
        tbuf[1][IP[12:4]]={retSRCIP[63:13],retIP[1][63:13]};
          if (jmispred) begin
              if (random&3==3) predA[{retSRCIP[13:0],retGHT[1:0]}]^=2'b10;
              if (random&4'hf==4'hf) predB[{retSRCIP[7:0],retGHT[7:0]}]^=2'b10;
              if (random&8'hff==8'hff) predC[{retSRCIP[1:0],retGHT[13:0]}]^=2'b10;
              GHT<=retGHT;
            //tbufl[retSRCIP[13:5]][1]={retJPR1,1'b1,retSRCIP,retIPB  };                 
              IP<=jmptaken1 ? retIP[1] : retSRCIP + 32;
         end
      end
      end
      assign retIP[0]=jcond0[reti_reg];
      assign retIP[1]=jcond1[reti_reg];
      bit_find_index12 fst(indexST_has,ids0p,ids0,ids0_has);
      bit_find_index12r fstb(indexST_has,ids1p,ids1,ids1_has);
      bit_find_index12 fjmp(isJump, idj0p,idj0,idj0_has);
      bit_find_index12r fjmp2(isJump, idj1p,idj1,idj1_has);
      for(fu=0;fu<12;fu=fu+1) begin : funit
          reg [63:0][63:0] data_gen;
          reg [63:0][63:0] data_fp;
          reg signed [63:0][63:0] data_imm;
          reg [63:0][16:0] data_op;
          reg [63:0][6:0] cloopbndloff;
          reg [39:0] insn;
          reg [63:0][5:0] data_imm_phy;
          reg [63:0][5:0] data_loopstop;
          reg [63:0][5:0] rdy; //port lsu/alu=bits 2:1 a,b; port store data=bit 0,A,B; upper 3 bits=needed bits
          reg [63:0][4+5:0] rdyA;
          reg [63:0][4+5:0] rdyB;
          reg [63:0][4+5:0] rdyFl0;
          reg [63:0][4+5:0] rdyFl1;
          reg [63:0][5:0] rdyM; // also used for cloop second condition
          reg [63:0] free;
          wire [4+5:0] rA;
          wire [4+5:0] rB;
          wire [4+5:0] rBX;
          wire [4+5:0] rFL;
          wire [4+5:0] rFL2;
          wire rA_en, rB_en;
          wire [65:0] dataA;
          wire [65:0] dataB;
          wire [65:0] dataBIX;
          wire signed [65:0] dataBI;
          wire [3:0] data_phy;
          wire [63:0] res;
          wire [7:0] opcode;
          wire [4:0] cond;
          wire cond_tru;
          reg [63:0][63:0] dreqmort;
          reg [63:0][65:0] dreqdata;
          reg [63:0][5:0] dreqmort_flags;
          reg [63:0][3:0] dreqdata_flags;
          bit_find_index indexMiss(miss_reg2,index_miss[fu],index_miss_has[fu]);
          bit_find_index12 index12Miss(index_miss_has_reg2,index12m_idx,index12m_pos,index12m_present);
          assign missx_en[PHY]=index12m_idx_reg==fu;
          assign missx_addr[PHY]= fu==index12m_idx_reg ? funit[index12m_idx_reg].dreqmort[index_miss_reg3[index12m_idx_reg]] : 'z;
          assign interPHY_pfaff=missrs_reg4[dreqmort[index_miss_reg4][18:11]] && {10{index12m_idx==fu && (cntphy==1 || cntfirst==PHY)}};
          bit_find_index indexLSU_ALU(rdy[63:0][2]&rdy[63:0][1]&{64{~phy[PHY].funit[(fu+1)%12].is_mul_reg3}},indexFU,indexFU_has);
          bit_find_index indexLDU(rdy[63:0][0],indexLDU,indexLDU_has);
          bit_find_index indexAlloc(free,alloc[5:0],rT_en0);
          bit_find_indexR indexAlloc2(free,alloc2[5:0],rTm_en0);
          bit_find_index indexST(dreqmort_flags[63:0][4] && dreqmort_flags[63:0][2] && {64{sten[fu]}},indexST,indexST_has);
          fpuadd64 Xadd(clk,rst,dataAF,dataBF,rnd,xaddres);
          fpuprod64 Xmul(clk,rst,dataAF,dataBF,rnd,xmulres);
          assign ret0[fu][PHY]=!data_retFL[RETI][0];
          assign ret1[fu]=&ret0[fu];
          assign mret0[fu][PHY]=&dreqmort_flags[RETI][5:4];
          assign mret1[fu]=&mret0[fu];
          assign mxret0[fu][PHY]=^dreqmort_flags[RETI][5:4];
          assign mxret1[fu]=&mxret0[fu];
          assign rT[9:6]=fu;
          assign clres={dataA_reg[63:32],dataA_reg2[31:0]}<{dataB_reg[63:32],dataB_reg2[31:0]}-1;
          assign clres2={dataA_reg[63:32],dataA_reg2[31:0]}<{dataB_reg[63:32],dataB_reg2[31:0]};
          assign clres3={dataA_reg[63:32],dataA_reg2[31:0]}<={dataB_reg[63:32],dataB_reg2[31:0]};
          assign res_cloop0=cond_tru_reg && cond_xtru_reg && clres;
          assign res_cloop1=cond_tru_reg && cond_xtru_reg && clres2;
          assign res_cloop2=cond_tru_reg && cond_xtru_reg && clres3;
          assign res_loop0=clres;
          assign res_loop1=clres2;
          assign res_loop2=clres3;

          assign rT_en=opcode[5] && rT_en0;
          assign ldsize=1<<opcode[9:8]-1;
          assign ldsizes=ldsize & {3{opcode[10]}};
          assign LQ=opcode[19:14];
          assign LQX=opcodex[19:14];
          assign op_anx=opcode[7:5]==0 && |opcode[10:9];
          assign opand=opcode[7:5]!=0;
          assign jindir=fu!=10 && !opcode[10];
          assign dataA[31:0]=phy[PHY].funit[rA[9:6]].data_gen[rA[5:0]][31:0] & {32{opand}};
          assign dataB[31:0]=phy[PHY].funit[rB[9:6]].data_gen[rB[5:0]][31:0];
          assign dataBI[31:0]=opcode[11] ?phy[PHY].funit[rT[9:6]].data_imm[rT[5:0]][9:0]*(data_phy): phy[PHY].funit[rT[9:6]].data_imm[rT[5:0]][31:0]*(data_phy+1);
          assign data_phy[31:0]=phy[PHY].funit[rT[9:6]].data_imm_phy[rT[5:0]][31:0];
          assign dataBX[31:0]=phy[PHY].funit[rBX[9:6]].data_gen[rBX[5:0]][31:0];
          assign dataBIX[31:0]=opcode[0] || opcode[7:0]==2 ? dataBI[31:0] : dataBX[31:0];
          assign dataA[63:32]=phy[PHY].funit[rA_reg[9:6]].data_gen[rA_reg[5:0]][63:32] & {34{opand_reg}};
          assign dataB[63:32]=phy[PHY].funit[rB_reg[9:6]].data_gen[rB_reg[5:0]][63:32];
          assign dataAF[63:0]=phy[PHY].funit[rA_reg3[9:6]].data_gen[rA_reg2[5:0]][63:0];
          assign dataBF[63:0]=phy[PHY].funit[rB_reg3[9:6]].data_gen[rB_reg2[5:0]][63:0];
          assign dataBI[63:32]=phy[PHY].funit[rT_reg[9:6]].data_imm[rT_reg[5:0]][57:0]*(data_phy+1)>>32;
          assign dataBX[63:32]=phy[PHY].funit[rBX_reg[9:6]].data_gen[rBX_reg[5:0]][63:32];
          assign dataBIX[63:32]=opcode_reg[0] || opcode_reg[7:0]==2 ? dataBI[63:32] : dataBX[63:32];
          assign dataFL=phy[PHY].funit[rFL[9:6]].data_fl[rFL[5:0]][3:0];
          assign dataFL2=phy[PHY].funit[rFL2[9:6]].data_fl[rFL2[5:0]][3:0];
          assign cond_tru=flcond(cond[3:0],dataFL);
          assign cond_xtru=flcond(cond2[3:0],dataFL2);
          assign {c32,res[31:0]}=opcode[7:0]==0 && cond_tru && !dataBI[32] ?
          dataA[31:0]+dataB[31:0]^{32{dataBI[33]}}+dataBI[33] : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==0 && cond_tru_reg ?
           {dataA[63],dataA[63:32]}+{dataB[63],dataB[63:32]}^
          {32{dataBI_reg[33]}}+(c32_reg) : 'z;
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
          assign {c64,s64,res[63:32]}=(opcode_reg[7:0]==2 || opcode_reg[7:0]==0 && dataBI_reg[32])&& cond_tru_reg ?
            {dataA[63]|~chk,dataA[63:32]}+{dataBI_reg[63],dataBI_reg[63:32]} + (dataBI_reg[32] ? !res_reg[31] :c32_reg) : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==3 && cond_tru ?
            dataBI[31:0] : 'z;
          assign chk=addition_check(dataA[63:43],{dataA[42:32],dataA_reg[31:0]},{dataBIX[42:32],dataBIX_reg[31:0]},opcode_reg[11],isand)
             || ~dataA_reg[65] || ^dataA_reg[64:63];
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==3 && cond_tru_reg ?
          {1'b0,dataBI_reg[63]^opcode_reg[8],dataBI_reg[63:32]} : 'z;
          assign res_logic[31:0]=opcode[2:1]==0 &~foo ? dataA[31:0]&dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==1 &~foo ? dataA[31:0]^dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==3 &~foo ? dataA[31:0]|dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==2 &~foo ? phy[(LOOPSTOP+dataBIX[5:0])%60].dataA[31:0] 
              : 'z;
          assign res_logic[31:0]=foo ? dataA[31:0] :'z;

          assign res_logic[63:32]=opcode_reg[2:1]==0 &~foo_reg ? dataA[63:32]&dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==1 &~foo_reg ? dataA[63:32]^dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==3 &~foo_reg ? dataA[63:32]|dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==2 &~foo_reg ? phy[(LOOPSTOP+dataBIX_reg[5:0])%60].dataA[63:32] 
              : 'z;
          assign res_logic[63:32]=foo_reg & bndnonred(dataA[63:43],{opcode_reg[2:1],dataBI_reg[18:0]}) ? {opcode_reg[2:1],dataBI_reg[18:0],dataA[42:32]} : 'z;
          assign res_logic[63:32]=foo_reg & ~bndnonred(dataA[63:43],{opcode_reg[2:1],dataBI_reg[18:0]}) ? dataA[63:32] : 'z;

          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2]==0 ? dataA_reg3[31:0]*dataBIX_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2:1]==2'b10 ? dataAS_reg3[31:0]*dataBIXS_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2:1]==2'b11 && !dataBI_reg4[6] ? dataAS_reg3[63:0]>>>dataBIXS_reg3[5:0]: 'z;
          assign res_mul[31:0]=opcode_reg2[7:3]==3 && opcode_reg4[2:1]==2'b11 && dataBI_reg4[6] ? dataAS_reg3[63:0]>>dataBIXS_reg3[5:0]: 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==0 ? dataA_reg4[63:0]*dataBIX_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==1 ? {32{res_mul_reg[31]}} : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==2'b10 ? dataAS_reg4[63:0]*dataBIXS_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==2'b11 && !dataBI_reg4[6] ? dataAS_reg4[63:0]>>>dataBIXS_reg4[5:0]>>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[7:3]==3 && opcode_reg5[2:1]==2'b11 && dataBI_reg4[6] ? dataAS_reg4[63:0]>>dataBIXS_reg4[5:0]>>32 : 'z;
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
          assign res_shift[31:0]=opcode[3:1]==2 ? dataA[31:0]<<dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:1]==3 ? dataA[31:0]<<dataBI[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==8 ? dataA[31:0]>>dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==9 ? dataA[31:0]>>dataBI[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==10 ? dataA[31:0]>>>dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==11 ? dataA[31:0]>>>dataBI[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]==4 ? {dataA[63:32],dataA_reg[31:0]}<<dataB_reg[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]==5 ? {32{res_shift_reg[31]}} : 'z;
          assign res_shift[63:32]=opcode[3:0]==6 ? {dataA[63:32],dataA_reg[31:0]}<<dataBI_reg[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]>=7 ? {32{res_shift_reg[31]}} : 'z;
          assign cond=data_cond[indexLSU_ALU];
          assign cond2=data_cond2[indexLSU_ALU];
          assign isJump[fu]=opcode[7:5]==0 && opcode[8];
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
              rTMem<={fu,rdyM[indexLSU_ALU]};
              opcode<=data_op[indexLSU_ALU];
              opcodex<=data_op[indexLDU];
              if (miss_pfaff || missrs_reg4[index_miss] && miss_reg4[index_miss]) miss_reg4[index_miss]<=1'b0;
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
                  dreqmord_flags[LQ]<={~chk,1'b0,opcode_reg[7:6],opcode_reg[1:0]};
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
                  if (rT_en && funit[fu3].rdyFl0[sch]==rT && funit[fu3].rdy[sch][6]) funit[fu3].rdy[sch[7]]=1'b1;
                  if (rT_en && funit[fu3].rdyFl1[sch]==rT && funit[fu3].rdy[sch[8]]) funit[fu3].rdy[sch[9]]=1'b1;
              end
              aligned[PHY][fu]<=|dreqmort_flags[LDI][4:3];
              if (&aligned) begin
                dreqmort_flags[LDI_reg][4]<=1'b1;
              end
              instr<=poo_c_reg2;
              instr_clopp<=poo_c2_reg2;
              if (rT_en_reg && opcode_reg[10] | opcode_reg[5]) data_gen[rT_reg[5:0]][31:0]<=res[31:0];
              if (rT_en0_reg3 && opcode[7]) data_gen[rTMem_reg2[5:0]][31:0]<=pppoe_reg[31:0];
              if (rT_en0_reg3 && opcode[7:3]==3) data_gen[rTMem_reg2[5:0]][31:0]<=res_mul[31:0];
              if (rT_en_reg2 && opcode_reg2[10] | opcode_reg2[5]) data_gen[rT_reg2[5:0]][65:32]<={c64,s64,res[63:32]};
              if (rT_en_reg2) data_genFL[rT_reg2[5:0]][3:0]<=opcode_reg2[7:0]==1 && dataBI_reg2[22] ? {dataAF_reg[65:63],~|dataAF_reg[62:53]} : {c64|~chk,s64,res[63],~|resX[63:0]};
              if (rT_en_reg2) data_retFL[LQ_reg][3:0]<=opcode_reg2[7:5]==0 ? {dataAF[65:63],~|dataAF[62:53]} : {c64|~chk,s64,res[63],~|resX[63:0],1'b0};
              if (rT_en_reg2 && opcode_reg2[10] && ~|opcode_reg2[7:6]) data_retFL[LQ_reg][3:0]<=opcode_reg2[9]==0 ? {res_loop0,res_loop2,res_loop2,res_loop1,1'b0} : {res_cloop0,res_cloop2,res_cloop2,res_cloop1,1'b0};
            if (rT_en_reg5 &&(opcode_reg4[7:6]=0 && opcode_reg4[4:0]==1 && dataBI_reg4[20])) data_fpu[rT_reg4[5:0]]<=dataBI_reg4[22] ? dataAF_reg2 : xaddres;
              if (rT_en_reg6 &&(opcode_reg5[7:6]=0 && opcode_reg5[4:0]==1 && dataBI_reg5[21])) data_fpu[rTMem_reg5[5:0]]<=xmulres;
            if (rT_en_reg6 &&(opcode_reg5[7] && dataBI_reg5[21])) data_fpu[rTMem_reg5[5:0]]<=flconv(pppoe_reg3,opcode_reg5[8]);
              if (rT_en0_reg4 && opcode_reg3[7:3]==3) data_gen[rTMem_reg3[5:0]][65:32]<=res_mul[63:32];
              if (rT_en0_reg4 && opcode_reg3[7]) data_gen[rTMem_reg2[5:0]][65:32]<=pppoe_reg2[65:32];
              if (rT_en0_reg3 && opcode_reg2[7:0]==1 && dataBI_reg2[22]) data_gen[rTMem_reg3[5:0]][65:32]<=fsconv(dataAF_reg,dataBI_reg3[24:23])>>32;
              if (rT_en0_reg2 && opcode_reg[7:0]==1 && dataBI_reg[22]) data_gen[rTMem_reg3[5:0]][31:0]<=fsconv(dataAF,dataBI_reg2[24:23]);
              if (rT_en0_reg4 && fu==idj0p) begin
                   jcond0[LQ]<=res_reg3;
                   jcondx0[LQ]<=!opcode_reg4[8] || opcode_reg4[7:5]!=0 ? 11 : opcode_reg4 [10]  ? 4 : cond;
                   if (opcode_reg4[10]) jcond0[LQ]<=srcIPOff[LQ]+data_cloop[rT_reg4[5:0]];
                   if (opcode_reg4[8]) jcond0[LQ]<=srcIPOff[LQ]+res_reg3;
                   jcc0[LQ]<=opcode_reg4[10] ?(opcode_reg4[9]==0 ? {res_loop0_reg2,res_loop2_reg2,res_loop2_reg2,res_loop1_reg2,1'b0} : {res_cloop0_reg2,res_cloop2_reg2,res_cloop2_reg2,res_cloop1_reg2,1'b0}):opcode_reg2[7:5]==0 ? {dataAF_reg4[65:63],~|dataAF_reg4[62:53]} : {c64_reg4|~chk_reg4,s63_reg4,res_reg4[63],~|resX_reg4[63:0],1'b0};
               end
               if (rT_en0_reg4 && fu==idj1p) begin
                   jcond1[LQ]<=res_reg3;
                   jcondx1[LQ]<=!opcode_reg4[8] || opcode_reg4[7:5]!=0 ? 11 : opcode_reg4 [10]  ? 4 : cond;
                   if (opcode_reg4[10]) jcond1[LQ]<=srcIPOff[LQ]+data_cloop[rT_reg4[5:0]];
                   if (opcode_reg4[8]) jcond1[LQ]<=srcIPOff[LQ]+res_reg3;
                   jcc1[LQ]<=opcode_reg4[10] ?(opcode_reg4[9]==0 ? {res_loop0_reg2,res_loop2_reg2,res_loop2_reg2,res_loop1_reg2,1'b0} : {res_cloop0_reg2,res_cloop2_reg2,res_cloop2_reg2,res_cloop1_reg2,1'b0}):opcode_reg2[7:5]==0 ? {dataAF_reg4[65:63],~|dataAF_reg4[62:53]} : {c64_reg4|~chk_reg4,s63_reg4,res_reg4[63],~|resX_reg4[63:0],1'b0};
               end
               if (insert_en && (fu>=insn_cloop[3:0] && IP[4:0]==insn_cloop[9:5])|
                    (fu>=insn_cloop[13:10] && IP[4:0]==insn_cloop[19:15])|
                    (fu>=insn_cloop[23:10] && IP[4:0]==insn_cloop[29:25])  ) begin
                  data_op[alloc][7:6]=instr[39:38];
                  if (&instr[39:38]) data_op[alloc][7:6]=2'b0;
                 if (instr[39:38]==2'b10 && instr[33]|instr[34]&~instr[12]) begin
                   data_imm[alloc]=&instr[34:33] ? ret_cookie : {{41{instr[24]}}^{17'b0,insn_cloop[31],13'b0},instr[24:14],instr[11:0]};
                   data_op[alloc][11]<=instr[13]; //1=call 0=jump
                   data_cond[alloc]={instr[37:35],instr[32]};
                   data_cond2[alloc]=instr[31:28];
                   data_op[10:8]=instr[27:25];
                   if (instr[34:33]==2 && !instr[25]) data_imm[alloc]<=instr[1:0];
                   if (instr[25]) data_imm[alloc]<=0;
                   data_op[7:0] = instr[25] || instr[34:33]==2 ? 0 : op_movi;
                  end else if (^instr[39:38]) begin
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
                    data_op[alloc][8]=flagi;
                    if (flagi)
                      data_imm[alloc]={spgcookie,6'b0,instr[32:15],instr[8:4],15'b0};
                      
                  end
                  if (!|instr[39:38]) begin
                    data_op[alloc][4:0]={instr[37:34],instr[12]};
                      data_op[alloc][5]=1'b1;
                      data_cond[alloc][3:0]=instr[32:27];
                    data_imm[alloc]={{20{instr[26]}},instr[26:14],instr[11:9],18'b0};
                      if ({instr[37:34],instr[14]}==19) begin
                        data_imm[alloc]={{30{instr[26]}},instr[26:25],{20{instr[24]}},instr[24:14]};
                        data_op[alloc][4:0]=2;
                      end
                  end
                  if (instr[39:38]==2) begin
                    rTT[{insn_cloop[4]&&~|instr[3:2],instr_clopp[14]|(insn_cloop[4]&&~|instr[3:2]),instr[3:0]}]<=alloc2;
                    rTTOldm[INSI]<=rTT[{insn_cloop[4]&&~|instr[3:2],instr_clopp[14]|(insn_cloop[4]&&~|instr[3:2]),instr[3:0]}];
                    rTTNewm[INSI]<=alloc2;
                    rTTe[alloc2][0]<=1'b1;
                    if (instr[34]) begin
                        rTT[{insn_cloop[4]&&~|instr[7:6],instr_clopp[24]|(insn_cloop[4]&&~|instr[7:6]),instr[7:4]}]<=alloc;
                        rTTOld[INSI]<=rTT[{insn_cloop[4]&&~|instr[7:6],instr_clopp[24],instr[7:4]}];
                        rTTNew[INSI]<=alloc;
                        rTTe[alloc][0]<=1;
                    end
                  end
                  if (~^instr[39:38]) begin
                       rTT[{insn_cloop[4]&&~|instr[3:2],instr_clopp[14]|(insn_cloop[4]&&~|instr[3:2]),instr[3:0]}]<=alloc;
                       rTTOld[INSI]<=rTT[{insn_cloop[4]&&~|instr[3:2],instr_clopp[14],instr[3:0]}];
                       rTTNew[INSI]<=alloc;
                       rTTe[alloc][0]<=1'b1;
                  end
                   data_retFL[INSI]<=1;
                   rdyA[alloc]<=rTT[{insn_cloop[4]&&~|instr[7:6],instr[39:38]==2 ? instr_clopp [24]|(insn_cloop[4]&&~|instr[7:6]) : instr_clopp[14]|(insn_cloop[4]&&~|instr[7:6]),instr[7:4]}];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[7:4] && funit[fuZ].instr[39:38]==2)
                       rdyA<=funit[fuZ].alloc2;
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[7:4] && ~^funit[fuZ].instr[39:38])
                       rdyA<=funit[fuZ].alloc;
                   end
                   rdyB[alloc]<=rTT[{insn_cloop[4]&&~|instr[11:10],instr_clopp[14]|(insn_cloop[4]&&~|instr[11:10]),instr[11:8]}];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[11:8] && funit[fuZ].instr[39:38]==2)
                       rdyB<=funit[fuZ].alloc2;
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[11:8] && ~^funit[fuZ].instr[39:38])
                       rdyB<=funit[fuZ].alloc;
                   end
                   rdyFL[alloc]<=rTT[instr[33]];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[33] && funit[fuZ].instr[39:32]==2)
                       rdyFL<=funit[fuZ].alloc2;
                     if(fuZ<fu && funit[fuZ].instr[3:0]==instr[33] && ~^funit[fuZ].instr[39:38])
                       rdyFL<=funit[fuZ].alloc;
                   end
                   rdyFL2[alloc]<=rTT[2];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && funit[fuZ].instr[3:0]==2 && funit[fuZ].instr[39:32]==2)
                       rdyFL2<=funit[fuZ].alloc2;
                     if(fuZ<fu && funit[fuZ].instr[3:0]==2 && ~^funit[fuZ].instr[39:38])
                       rdyFL2<=funit[fuZ].alloc;
                   end
                  rdy[alloc]<={1'b1,instr[39],1'b1,instr[32:27]==3,instr[39]};  
                  data_op[alloc][12:11]=instr[13:12];
              end
          end
          always @* begin
                  wstall[PHY][fu]<=1'b0;
                  lderror<=64'b0;
                  missus=0;
                  miss=0;
                  for(ldi=0;ldi<64;ldi++) begin
                      if (is_wconfl(dreqmort[LDI_reg],dreqmort_flags[LDI_reg],dreqmort[ldi],dreqmort_flags[ldi]))
                          wstall[PHY][fu]<=1'b1;
                      if (is_lconfl(dreqmort[indexLDU],dreqmort_flags[indexLDU],dreqmort[ldi],dreqmort_flags[ldi]))
                          lderror[ldi]<=1'b1;
                      if (!anyhitw_reg && is_store_reg && ldi==indexLSU_ALU_reg3) begin
                          miss[ldi]=1;
                          missus[resX[18:11]][PHY]=1;
                      end
                      if (!anyhit_reg && opcode_reg2[7] && ldi==indexLSU_ALU_reg3) begin
                          miss[ldi]=1;
                          missus[res_reg[18:11]][PHY]=1;
                      end
                  end
                  missrs=0;
                  for(ldi=0;ldi<64;ldi++) begin
                    if (!anyhitw_reg && is_store_reg && ldi==indexLSU_ALU_reg3) missrs[ldi]=missrs[ldi]|missus[resX[18:11]];
                    if (!anyhit_reg && opcode_reg2[7] && ldi==indexLSU_ALU_reg3) missrs[ldi]=missrs[ldi]|missus[resX[18:11]];
                  end
          end
      end
      reg [9:0][38:0] tr;
      reg wway,hway,vway;
      for(way2=0;way2<8;way2=way2+1) always @* begin
        if (insert_en && cache_way[way2].cache_line[insetr_addr[5:0]].tag[insetr_addr[6]]==insetr_addr[36:6]) 
                  wway=1;
        if (inserth_en && cache_way[way2].cache_line[insetrh_addr[5:0]].tag[insetrh_addr[6]]==insetrh_addr[36:6]) 
                  hway=1;
     //   if (insertv_en && cache_way[way2].cache_line[insetrv_addr[5:0]].tag[insetrv_addr[6]]==insetrv_addr[36:6]) 
     //             vway=1;
      end
      for(way=0;way<8;way=way+1) begin : cache_way
          wire [11:0][65:0] poo_e;
          wire [66*8-1:0] poo_c;
          reg [66*8-1:0] poo_c_reg;
          reg [11:0][65:0] poo_e_reg;
          always @(posedge clk) begin
              poo_e_reg<=poo_e;
              poo_c_reg<=poo_c;
          end
        for(line=0;line<64;line=line+1) begin : cache_line
          reg [15:0][65:0] line_data;
          reg [1:0][52:0] tag;
             assign poo_c2[fuB]=cache_line[IP[12:7]][line][IP[6:3]][40*12+:32];
             always @(posedge clk) begin
                if (way==0) wway=0;
                if (line==expaddr[5:0] && expen)
                  tag[expaddr[6]][67:66]<=0;
                   if (way==random && insetr_en && !wway) begin
                   if (line==insetr_addr[5:0]) begin
                       tag[insetr_addr[6]]<={insetr_wrtable,1'b1,insetr_addr[36:7]};
                       line_data[8*insetr_addr[6]+:8]<=insetr_daata;
                       expun_data<=line_data[8*insetr_addrh[6]+:8];
                       expun_tag<=tag[insetrh_addr[6]];
                   end
                 end
                if (way==random && insetrh_en && !hway) begin
                  if (line==insetrh_addr[5:0] && instetrh_phy[PHY]) begin
                      tag[insetrh_addr[6]]<={insetr_wrtableh,1'b1,inser_addrh[36:7]};
                      expunH_data<=line_data[8*insetr_addrh[6]+:8];
                      expunH_tag<=tag[insetrh_addr[6]];
                      line_data[8*insetr_addrh[6]+:8]<=insetr_daatah;
                  end
                end
                if (way==random && insertv_en && !vway) begin
                  if (line==insetr_addrv[5:0] && instetrv_phy[PHY]) begin
                      tag[insetr_addrv[6]]<={insetr_wrtablev,1'b1,inser_addrv[36:7]};
                      line_data[8*insetr_addrv[6]+:8]<=insetr_daatav;
                      expunV_data<=line_data[8*insetr_addrh[6]+:8];
                      expunV_tag<=tag[insetrh_addr[6]];
                 end
             end
             end
             for(fuB=0;fuB<12;fuB=fuB+1) begin : funit2
                wire [65:-64] poo_mask;
                integer byte_;
                assign poo_e[fuB]=line_data[phy[PHY].funit[fuB].res[6:3]]>>(phy[PHY].funit[fuB].res[2:0]*8)<<(56-phy[PHY].funit[fuB].ldsizes[2:0]*8)>>>(56-phy[PHY].funit[fuB].ldsizes[2:0]*8);
                assign poo_c[66*fuB+:66]=line_data[IP[8:5]];
                assign poo_mask=(130'h3ffff_ffff_ffff_ffff<<(phy[PHY].funit[fuB].ldsize_reg[2:0]*8))&{phy[PHY].funit[fuB].resX[65],65'h1ffff_ffff_ffff_ffff};
                if (line==0) assign pppoe[fuB]=tag[51]&&tag[18:0][phy[PHY].funit[fuB].res[6]]=={res[31:26],res[25:13]} ? poo_e_reg && poo_mask_reg[65:0] : 'z;
                if (line==1) assign anyhit[fuB][way]=tag[51]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]==phy[PHY].funit[fuB].resX[37:6];
                if (line==3) assign anyhitW[fuB][way]=tag[52]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]==phy[PHY].funit[fuB].resX[37:6];
                if (line==4) assign anyhitcc[fuB][way]=tag[51]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]=={7'h7f,IP_reg[37],IP_reg[27:5]} && {1'b1,IP_reg[37:28]}=={poo_c_reg[224+30],poo_c_reg[224+8:224+5],poo_c_reg[224+3:224+0]};
                if (line==5) assign anyhitC[fuB][way]=tag[51]&&tag[50:19][phy[PHY].funit[fuB].resX[6]]==IP_reg[36:5] && !poo_c_reg[224+30];
              //  if (line==4) assign tlbhit=tr_reg[phy[PHY].funit[fuB].resX[31:22]][37:6]==phy[PHY].funit[fuB].resX[63:37] && tr_reg[phy[PHY].funit[fuB].resX[31:22]][38];
                always @(posedge clk) begin
                  if (fuB==ids0_reg || fuB==ids1_reg)
                    for (byte_=0;byte_<8;byte_=byte_+1)
                      if (anyhitW[fuB][way] && phy[PHY].funit[fuB].is_write_reg && phy[PHY].funit[fuB].resW[12:7]==line[5:0] && byte_<phy[PHY].funit[fuB].is_write_size_reg); 
                  line_data[phy[PHY].funit[fuB].resW[6:3]][8*(byte_+phy[PHY].funit[fuB].resW[2:0])+:8]<=phy[PHY].funit[fuB].resWX[8*byte_+:8];
                //        if (][way] && phy[PHY].funit[fuB].is_write_reg && phy[PHY].funit[fuB].resW[2:0]==line[5:3] && byte_<phy[PHY].funit[fuB].is_write_size_reg &&
                //            phy[PHY].funit[fuB].resX[63:9]=='1); 
                //            line_data[line][phy[PHY].funit[fuB].resW[6:3]]<=phy[PHY].funit[fuB].resW[8*phy[PHY].funit[fuB].resW[2:0]+:8];
                end
             end
          end
      end
    end
    end end //multicore loop
  endgenerate
endmodule
