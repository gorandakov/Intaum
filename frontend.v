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
no UK tech mogul's money were used to make this project.
no UK nobility member owns or has contributed to this project.
not accept free hint on debugging in exchange of the entire core.
*/

module frontend (
  input clk,
  input irqload,
  input [3:0] irqnum
  );
  reg rst=1;
  reg rst0=1;
  reg rst_reg;
  reg rst_reg2;
  reg rst_reg3;
  reg rst_reg4;
  reg rst_reg5;
  always @(posedge clk) begin
      if (rst0) rst0<=0;
      else if (rst) rst<=0;
      rst_reg<=rst;
      rst_reg2<=rst_reg;
      rst_reg3<=rst_reg2;
      rst_reg4<=rst_reg3;
      rst_reg5<=rst_reg4;
  end
  function flcond;
    input [3:0] cond;
    input [3:0] FL;
    case (cond)
      0: flcond=^cond[3:2];
      1: flcond=^cond[3:2]^1;
      2: flcond=^cond[3:2]^cond[0];
      3: flcond=^cond[3:2]^cond[0]^1;
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
      14: flcond=~cond[3]^cond[2]&&^cond[2:1];//pointer set
      15: flcond=!(~cond[3]^cond[2]&&^cond[2:1]); //pointer clear
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
      input [7:0] flag_aligned;
      input [63:0] addrl;
      input [7:0] flagkl;
      begin
          is_wconfl=addr_aligned[63:3]==addrl[63:3] && flagkl[4] && flagkl[2] && flag_aligned[2];
          if (addr_aligned[2:0]>(addrl[2:0]+(1<<flagkl[1:0]))) is_wconfl=0;
          if (addrl[2:0]>(addr_aligned[2:0]+(1<<flag_aligned[1:0]))) is_wconfl=0;
      end
  endfunction

  function [6:0] fee_undex;
//{insn_clopp[31:30],insn_clopp[24],insn_clopp[9:5],insn_clopp[3:0]}
      input [3:0] inp;
      case(inp)
          0: fee_undex=32;
          1: fee_undex=33;
          2: fee_undex=34;
          3: fee_undex=35;
          4: fee_undex=36;
          5: fee_undex=37;
          6: fee_undex=38;
          7: fee_undex=39;
          8: fee_undex=40;
          9: fee_undex=32+24;
          10: fee_undex=62;
default:
             fee_undex=63;         
      endcase
   endfunction
  function is_lconfl;
      input [63:0] addr_aligned;
      input [7:0] flag_aligned;
      input [63:0] addrl;
      input [7:0] flagkl;
      begin
          is_lconfl=addr_aligned[63:3]==addrl[63:3] && ~flagkl[4] && flagkl[3] && flag_aligned[2];
          if (addr_aligned[2:0]>(addrl[2:0]+(1<<flagkl[1:0]))) is_lconfl=0;
          if (addrl[2:0]>(addr_aligned[2:0]+(1<<flag_aligned[1:0]))) is_lconfl=0;
      end
  endfunction
  function [11:0] vaff;
      input [11:0][7:0] din;
      integer k;
      for(k=0;k<12;k++) vaff[k]=|din[k];
  endfunction
  function bndnonred;
      input [20:0] from;
      input [20:0] to;
      bndnonred=to[5:0]<=from[5:0] && {1'b0,from[19:13]}<={from[20]^to[20],to[19:13]} && from[12:6]>=to[12:6];
  endfunction
  function [20:0] spgcookie;
     input [7:0] on_low;
     spgcookie={on_low,on_low[6:0],6'd17};
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
  genvar tile_X,tile_Y,subPHY;
  for(tile_X=0;tile_X<1;tile_X=tile_X+1) 
  for(tile_Y=0;tile_Y<1;tile_Y=tile_Y+1) begin : HV
  wire iscall,isret,ucjmp;
  reg [7:0] sttop;
  reg [65535:0][1:0] predA;
  reg [65535:0][1:0] predB;
  reg [65535:0][1:0] predC;
  reg [(1<<9)-1:0][65:0] htlb;

  wire [35:0] missx_en;
  wire [35:0][38:0] missx_addr;
  wire [35:0][37:0] missx_phy;

  wire except;
  wire except_ldconfl;
  wire [1:0][42:0] retIP;
  wire [41:0] retSRCIP;
  reg [41:0] retSRCIP_reg; 
  wire [31:0] random;
  `define wrreq_size 681
  `define wrAreq_size 160
  wire [1:0][`wrreq_size:0] XH_intf_in[3:0];
  wire [1:0][`wrreq_size:0] XV_intf_in[3:0];
  wire [1:0][`wrreq_size:0] XH_intf_out[3:0];
  wire [1:0][`wrreq_size:0] XV_intf_out[3:0];
    
  wire [1:0][`wrAreq_size:0] AXH_intf_in[3:0];
  wire [1:0][`wrAreq_size:0] AXV_intf_in[3:0];
  wire [1:0][`wrAreq_size:0] AXH_intf_out[3:0];
  wire [1:0][`wrAreq_size:0] AXV_intf_out[3:0];
  wire [1:0][35:0] jretire; 
  wire [1:0][35:0] jtaken; 
  wire [1:0][35:0] jmpmispred;
  reg [255:0][4:0] missus;
  reg [255:0][4:0] missus_reg;
  reg [255:0][4:0] missus_reg2;
  reg [255:0][4:0] missus_reg3;
  reg [255:0][4:0] missus_reg4;
  wire [11:0][35:0] ret0;
  wire [11:0][35:0] mret0;
  wire [11:0][35:0] mxret0;
  reg [35:0][11:0] wstall;
  reg [35:0][11:0] wstall_reg;
  reg [35:0][11:0] aligned;
  wire [35:0][11:0][65:0] xdataA;
  wire [35:0][38:0]  rdaddr0;
  wire [35:0][8*66+4:0]  rddata;
  wire [35:0]  rden_in;
  wire [35:0][3:0][36:0]  rdaddr;
  wire [35:0] rden_out;
  wire [35:0][8*66+4:0]  wrdata;
  wire [35:0]  wren_in;
  wire [35:0][3:0][36:0]  wraddr;
  wire [35:0] wren_out;

  always @(posedge clk) begin
    missus_reg<=missus;
    missus_reg2<=missus_reg;
    missus_reg3<=missus_reg2;
    missus_reg4<=missus_reg3;
    retSRCIP_reg<=retSRCIP;
  end
  wire memstall;
  memblk blkmem(clk,rst,random,memstall,
    rdaddr0[36:4],
    rdaddr0[3:0],
    rddata,
    rden_in,
    rdaddr,
    rden_out,
    rdaddr0[36:4],
    wrdata,
    wren_in||rdaddr0[37]&rden_in,
    wraddr,
    wren_out);

  wire irq_IP={31'b1,irqnum[3:0],7'b0};
      genvar fu,fuB;
      genvar way,way2;
      genvar line;
      genvar PHY;
    for(PHY=0;PHY<36;PHY=PHY+1) begin : phy
      reg [31:0] insn_clopp;
      reg [41:0] IP; //shl 1
      reg [41:0] IP_reg;
      reg [41:0] IP_reg2;
      reg [41:0] IP_reg3;
      reg [41:0] IP_reg4;
      reg [13:0] GHT;
      wire ccmiss;
      reg [63:0] lderror;
      integer ldi;
      integer insi;
      wire [11:0] ret1;
      wire [11:0] mret1;
      wire [11:0] mxret1;
      reg [38:0][9:0] rTT;
      reg [38:0][9:0] rTTB;
      reg [63:0][1:0] rTTE;
      reg [63:0][9:0] rTTNew;
      reg [63:0][9:0] rTTOld;
      reg [63:0][9:0] rTTNewm;
      reg [63:0][9:0] rTTOldm;
      reg [63:0][5:0] rTT_arch;
      reg [63:0][5:0] rTT_archm;
      reg [63:0] ret_is_alu;
      reg [63:0] ret_is_load;
      wire [11:0] isJump;
      reg [63:0][5:0] data_loopstop;
      wire insetr_en;
      wire insetrh_en;
      wire insetrv_en;
      wire insetr_expen;
      wire insetrh_expen;
      wire insetrv_expen;
      wire [36:0] insetr_addr;
      wire [3:0][36:0] insetrh_addr;
      wire [3:0][36:0] insetrv_addr;
      wire [527:0] insetr_data;
      wire [527:0] insetrh_data;
      wire [527:0] insetrv_data;
      wire [35:0] insetrh_phy;
      wire insetrh_shared;
      wire insetrh_exclusive;
      wire [35:0] insetrv_phy;
      wire insetrv_shared;
      wire insetrv_exclusive;
      wire [35:0] insetr_phy;
      wire insetr_shared;
      wire insetr_exclusive;
      reg [38:0] expun_addr_reg;
      reg [35:0] expun_phy_reg;
      reg [38:0] expunh_addr_reg;
      reg [35:0] expunh_phy_reg;
      reg [38:0] expunv_addr_reg;
      reg [35:0] expunv_phy_reg;
      reg [38:0] expun_addr;
      reg [35:0] expun_phy;
      reg [38:0] expunh_addr;
      reg [35:0] expunh_phy;
      reg [38:0] expunv_addr;
      reg [35:0] expunv_phy;
      reg [8*66-1:0] expun_data_reg;
      reg [8*66-1:0] expunv_data_reg;
      reg [8*66-1:0] expunh_data_reg;
      reg [8*66-1:0] expun_data;
      reg [8*66-1:0] expunv_data;
      reg [8*66-1:0] expunh_data;
      wire [1:0][35:0] pred_en;
      reg [1:0][35:0] pred_en_reg;
      reg [1:0][35:0] pred_en_reg2;
      wire [1:0][85:0] tbuf;
      wire [1:0] jen;
      //reg [63:0][35:0] miss;
      //reg [63:0][11:0] missus;
      reg [255:0][85:0] tbufl;
      wire [11:0] retire;
      reg [11:0] retire_reg;
      reg [63:0][3:0] jcondx0;
      reg [63:0][3:0] jcondx1;
      reg [63:0][4:0] jcc0;
      reg [63:0][4:0] jcc1;
      //reg reti;
      //reg reti_reg;
      wire [11:0][65:0] pppoe;
      reg [11:0][65:0] pppoe_reg;
      reg [11:0][65:0] pppoe_reg2;
      reg [11:0][65:0] pppoe_reg3;
      reg [11:0][7:0] anyhit;
      reg [11:0][7:0] anyhitU;
      reg [11:0][7:0] anyhitE;
      reg [11:0][7:0] anyhitW;
      reg [11:0][7:0] anyhitC;
      reg [11:0] anyhit_reg;
      reg [11:0] anyhitW_reg;
      reg [11:0] anyhitC_reg;
      reg [11:0] anyhitC_reg2;
      reg [11:0] anyhitC_reg3;
      reg [11:0][7:0] anyhitE_reg;
      wire tbuf_error;
      reg [3:0] ifu_stage_valid;
      wire insert_en=ifu_stage_valid[3] && anyhitC_reg3;
      reg [63:0][41:0] jcond0;
      reg [63:0][41:0] jcond1;
      wire [11:0][5:0] index_miss;
      wire [11:0] index_miss_has;
      wire [11:0][3:0] index12m_idx;
      wire [11:0][11:0] index12m_pos;
      wire [11:0] index12m_idx_has;
      reg [11:0][5:0] index_miss_reg;
      reg [11:0] index_miss_has_reg;
      reg [11:0][3:0] index12m_idx_reg;
      reg [11:0] index12m_idx_has_reg;
      reg [11:0][5:0] index_miss_reg2;
      reg [11:0] index_miss_has_reg2;
      reg [11:0][3:0] index12m_idx_reg2;
      reg [11:0] index12m_idx_has_reg2;
      reg [11:0][5:0] index_miss_reg3;
      reg [11:0] index_miss_has_reg3;
      reg [11:0][3:0] index12m_idx_reg3;
      reg [11:0] index12m_idx_has_reg3;
      reg [11:0][5:0] index_miss_reg4;
      reg [11:0] index_miss_has_reg4;
      wire [3:0] idj0p;
      wire [3:0] idj1p;
      wire [11:0] idj0;
      wire [11:0] idj1;
      wire[11:0] instr_clextra;
      reg [5:0] reti;
      reg [5:0] reti_reg;
      reg [5:0] reti_reg2;
      wire idj0_has;
      wire idj1_has;
      wire retire_bndl;
      reg [63:0][1:0] data_jpred;
      reg [63:0][15:0] data_GHT;
      wire [15:0] retGHT=data_GHT[reti_reg];
      reg [63:0][42:0] srcIPOff;
      reg [63:0][6:0] data_cloop;
      wire [5:0] idxpreda;
      wire idxpreda_has;
      wire [5:0] idxpredb;
      wire idxpredb_has;
      reg [5:0] idxpreda_reg;
      reg [5:0] idxpreda_reg2;
      reg [5:0] idxpreda_reg3;
      reg [5:0] idxpredb_reg;
      reg [5:0] idxpredb_reg2;
      reg [5:0] idxpredb_reg3;
      reg idxpreda_has_reg,idxpreda_has_reg2,idxpreda_has_reg3;
      reg idxpredb_has_reg,idxpredb_has_reg2,idxpredb_has_reg3;
      reg [3:0] ids0_reg;
      reg [3:0] ids1_reg;
      //wire [3:0] ids0p;
      //wire [3:0] ids1p;
      //wire ids0_has;
      //wire ids1_has;
      wire [511:0] pppoc;
      wire [23:0] pppoc2;
      reg [511:0] poo_c_reg;
      reg [511:0] pppoc_reg;
      reg [511:0] pppoc_reg2;
      reg [23:0] pppoc2_reg;
      reg [23:0] pppoc2_reg2; 
      wire [511:0] poo_c;
      wire [23:0] poo_cp;
      reg [23:0] poo_cp_reg;
      reg vec,vec_reg,vec_reg2,vec_reg3;
          reg [11:0][63:0][63:0] data_gen;
          reg [11:0][63:0][65:0] data_fp;
          reg [11:0][63:0][4:0] data_genFL;
          reg [11:0][63:0][5:0] data_retFL;
          reg signed [11:0][63:0][63:0] data_imm;
          reg [11:0][63:0][19:0] data_imm2;
          reg [11:0][63:0][20:0] data_op;
          reg [11:0][63:0][3:0] data_cond;
          reg [11:0][63:0][3:0] data_cond2;
          reg [11:0][63:0][5:0] ldi2reg;
          reg [11:0][63:0][5:0] data_imm_phy;
        //  reg [11:0][63:0][5:0] data_loopstop;
          reg [5:0][11:0][63:0] rdy; //port lsu/alu=bits 2:1 a,b; port store data=bit 0,A,B; upper 3 bits=needed bits
          reg [11:0][63:0][4+5:0] rdyA;
          reg [11:0][63:0][4+5:0] rdyB;
          reg [11:0][63:0][4+5:0] rdyFL0;
          reg [11:0][63:0][4+5:0] rdyFL1;
          reg [11:0][63:0][5:0] rdyM; // also used for cloop second condition
          reg [11:0][63:0] free;
          reg [11:0][65:0] resX;
          reg [11:0][65:0] resX_reg;
          reg [11:0][65:0] resWD;
          reg [11:0] write_upper;
          reg [11:0][4:0] write_size;
          wire [11:0][2:0] ldsize;
          wire [11:0][2:0] ldsizes;
          reg [11:0] is_write;
          wire [11:0][63:0] resA;
          reg [11:0][4:0] write_size_reg;
          reg [11:0] is_write_reg;
          reg [11:0][63:0] resA_reg;
          reg [11:0][63:0] resA_reg2;
          reg [11:0][63:0] res_reg;
          reg [11:0][63:0] res_reg2;
          reg [11:0][63:0] res_reg3;
          reg [11:0][2:0] ldsize_reg;
          wire [11:0][20:0] opcode_reg;
          wire [11:0][39:0] inssr;
          wire [11:0][5:0] xalloc;
          wire [11:0][5:0] xalloc2;
          wire [11:0][7:0][63:0] dreqmort_flags;
          wire [11:0][63:0][63:0] xdreqmort;
          wire [11:0] indexST_has;
          wire [3:0] ids0;
          wire [3:0] ids1;
          wire ids0_has;
          wire ids1_has;
          wire [11:0] ids0p;
          wire [11:0] ids1p;
          reg irqload_reg;
          reg irqload_reg2;
          reg irqload_reg3;
          reg irqload_reg4;
          reg irqload_reg5; 
      wire [41:0] ret_cookie;
      reg [41:0] ret_cookie_reg;
      reg [41:0] ret_cookie_reg2;
      reg [41:0] ret_cookie_reg3;
      assign ret_cookie=htlb[sttop];
      bit_find_index j0pred(~pred_en_reg2[0][35:0],idxpreda,idxpreda_has);
      bit_find_index j1pred(~pred_en_reg2[1][35:0],idxpredb,idxpredb_has);
      assign {pred_en[1][PHY],pred_en[0][PHY]}=predA[{IP[17:5],GHT[1:0]}]^predB[{IP[12:5],GHT[7:0]}]^predC[{IP[6:5],GHT[13:0]}]||ucjmp;
      assign tbuf=tbufl[IP[13:5]];
      assign jen[0]=tbuf[0][43] && IP[42:4]==tbuf[0][82:44];
      assign jen[1]=tbuf[1][43] && IP[42:4]==tbuf[1][82:44];
      assign iscall=jen[0] && tbuf[0][83] || jen[1] && tbuf[1][83];
      assign isret=jen[0] && tbuf[0][84] || jen[1] && tbuf[1][84];
      assign ucjmp=jen[0] && tbuf[0][85] || jen[1] && tbuf[1][85];
      assign jtaken[0][PHY]=&retire_reg[11:0] && flcond(jcondx0[reti_reg],jcc0[reti_reg][4:1]);
      assign jtaken[1][PHY]=&retire_reg[11:0] && flcond(jcondx1[reti_reg],jcc1[reti_reg][4:1]);
      assign jmpmispred[0][PHY]=&retire_reg[11:0] && jtaken[0][PHY]^data_jpred[reti_reg][0];
      assign jmpmispred[1][PHY]=&retire_reg[11:0] && jtaken[1][PHY]^data_jpred[reti_reg][1];
      assign jretire[0][PHY]=jtaken[0][PHY]|jmpmispred[0][PHY];
      assign jretire[1][PHY]=jtaken[1][PHY]|jmpmispred[1][PHY];
      always @(posedge clk) begin
          if (isret) sttop--;
          if (iscall|irqload) begin
              htlb[sttop+1]<=irqload? IP[35:0] : {IP_reg4[35:6]+1,5'b0};
              sttop=sttop+1;
          end
          if (rst) reti<=0;
          else if (except|except_ldconfl) reti<=insi;
          else if (retire_bndl) reti<=reti+1;
          ret_cookie_reg<=ret_cookie;
          ret_cookie_reg2<=ret_cookie_reg;
          ret_cookie_reg3<=ret_cookie_reg2;
          reti_reg<=reti;
          reti_reg2<=reti_reg;
          pred_en_reg<=pred_en;
          pred_en_reg2<=pred_en_reg;
          irqload_reg<=irqload;
          irqload_reg2<=irqload_reg;
          irqload_reg3<=irqload_reg2;
          irqload_reg4<=irqload_reg3;
          irqload_reg5<=irqload_reg4;
          expun_addr_reg<=expun_addr;
          expun_data_reg<=expun_data;
          expun_phy_reg<= expun_phy;
          expunh_addr_reg<=expunh_addr;
          expunh_data_reg<=expunh_data;
          expunh_phy_reg<= expunh_phy;
          expunv_addr_reg<=expunv_addr;
          expunv_data_reg<=expunv_data;
          expunv_phy_reg<= expunv_phy;
          pppoe_reg<=pppoe;
          pppoe_reg2<=pppoe_reg;
          pppoe_reg3<=pppoe_reg2;
          anyhit_reg<=vaff(anyhit);
          anyhitW_reg<=vaff(anyhitW);
          anyhitC_reg<=vaff(anyhitC);
          anyhitC_reg2<=anyhitC_reg;
          anyhitC_reg3<=anyhitC_reg2;
          anyhitE_reg<=vaff(anyhitE);
          IP_reg<=IP;
          IP_reg2<=IP_reg;
          IP_reg3<=IP_reg2;
          IP_reg4<=IP_reg3;
          index_miss_reg<=index_miss;
          index_miss_has_reg<=index_miss_has;
          index12m_idx_reg<=index12m_idx;
          index12m_idx_has_reg<=index12m_idx_has;
          index_miss_reg2<=index_miss_reg;
          index_miss_has_reg2<=index_miss_has_reg;
          index12m_idx_reg2<=index12m_idx_reg;
          index12m_idx_has_reg2<=index12m_idx_has_reg;
          index_miss_reg3<=index_miss_reg2;
          index_miss_has_reg3<=index_miss_has_reg2;
          index12m_idx_reg3<=index12m_idx_reg2;
          index12m_idx_has_reg3<=index12m_idx_has_reg2;
          index_miss_reg4<=index_miss_reg3;
          index_miss_has_reg4<=index_miss_has_reg3;
          poo_c_reg<=poo_c;
          //poo_c_reg2<=poo_c_reg;
          pppoc_reg<=pppoc;
          pppoc_reg2<=pppoc_reg;
          pppoc2_reg<=pppoc2;
          pppoc2_reg2<=pppoc2_reg;
      end
      wire [1:0] is_cloop;
      assign ccmiss=ifu_stage_valid[3] &&  !anyhitC_reg3;
      assign is_cloop[0]=tbuf[0][IP[12:4]][44];
      assign is_cloop[1]=tbuf[1][IP[12:4]][44];

      always @(posedge clk) begin
        ids0_reg<=ids0p;
        ids1_reg<=ids1p;
        idxpreda_reg<=idxpreda;
        idxpreda_reg2<=idxpreda_reg;
        idxpreda_reg3<=idxpreda_reg2;
        idxpreda_has_reg<=idxpreda_has;
        idxpreda_has_reg2<=idxpreda_has_reg;
        idxpreda_has_reg3<=idxpreda_has_reg2;
        idxpredb_reg<=idxpredb;
        idxpredb_reg2<=idxpredb_reg;
        idxpredb_reg3<=idxpredb_reg2;
        idxpredb_has_reg<=idxpredb_has;
        idxpredb_has_reg2<=idxpredb_has_reg;
        idxpredb_has_reg3<=idxpredb_has_reg2;
        vec_reg<=vec;
        vec_reg2<=vec_reg;
        vec_reg3<=vec_reg2;
        if (rst) ifu_stage_valid<=1;
        else if (except) ifu_stage_valid<=1;
        else ifu_stage_valid={ifu_stage_valid[2:0],1'b1};
      if (irqload|ccmiss|except_ldconfl) begin
          IP<=irqload ? irq_IP : except_ldconfl ? retSRCIP_reg : IP_reg4;
      end else if (&jen[1:0]) begin
        if (is_cloop[1:0]) vec<=1'b1;
        if (&pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=isret[0] ? ret_cookie : tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        else if (&pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=isret[1] ? ret_cookie : tbuf[1][IP[12:4]][42:0]; if (tbuf[1][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+32;  vec<=1'b0; end
      end else if (^jen[1:0]) begin
        if (is_cloop[0]) vec<=1'b1;
        if (&pred_en[0]) begin GHT<={GHT[14:0],1'b1}; IP<=isret[0] ? ret_cookie : tbuf[0][IP[12:4]][42:0]; if (tbuf[0][IP[12:0]][123:63]!=IP[63:13]) tbuf_error<=1'b1; end
        //else if (pred_en[1]) begin GHT<={GHT[13:0],2'b1}; IP<=tbuf[1][IP[12:4]][42:0]; end
          else begin GHT<={GHT[13:0],2'b0}; IP<=IP+32; vec<=1'b0; end
      end else begin
          IP=IP+32;
      end
      if (|jretire[0] && except) begin
          tbufl[0][IP[12:4]]={retSRCIP[63:13],retIP[0][63:13]};
          if (|jmpmispred[0]) begin
              if (random&3==3) predA[{retSRCIP[13:0],retGHT[1:0]}]^=2'b1;
              if (random&4'hf==4'hf) predB[{retSRCIP[7:0],retGHT[7:0]}]^=2'b1;
              if (random&8'hff==8'hff) predC[{retSRCIP[1:0],retGHT[13:0]}]^=2'b1;
              GHT<=retGHT;
              //tbufl[retSRCIP[13:5]][0]={retJPR0,1'b1,retSRCIP,retIPA};
              IP<=|jtaken[0] ? retIP[0] : retSRCIP + 32;
           end
      end else if (|jretire[1] && except) begin
          tbufl[1][IP[12:4]]={retSRCIP[63:13],retIP[1][63:13]};
          if (|jmpmispred[1]) begin
              if (random&3==3) predA[{retSRCIP[13:0],retGHT[1:0]}]^=2'b10;
              if (random&4'hf==4'hf) predB[{retSRCIP[7:0],retGHT[7:0]}]^=2'b10;
              if (random&8'hff==8'hff) predC[{retSRCIP[1:0],retGHT[13:0]}]^=2'b10;
              GHT<=retGHT;
            //tbufl[retSRCIP[13:5]][1]={retJPR1,1'b1,retSRCIP,retIPB  };                 
              IP<=|jtaken[1] ? retIP[1] : retSRCIP + 32;
         end
      end
      end
      assign retIP[0]=jcond0[reti_reg];
      assign retIP[1]=jcond1[reti_reg];
      assign retire_bndl=insi!=reti;
      bit_find_index12 fst(indexST_has,ids0p,ids0,ids0_has);
      bit_find_index12r fstb(indexST_has,ids1p,ids1,ids1_has);
      bit_find_index12 fjmp(isJump, idj0p,idj0,idj0_has);
      bit_find_index12r fjmp2(isJump, idj1p,idj1,idj1_has);
      for(fu=0;fu<12;fu=fu+1) begin : funit
          reg [39:0] insn;
          wire chk;
          wire chkA;
          reg isand_reg;
          integer fuZ;
          wire [63:0] xmulres;
          wire [63:0] xaddres;
          reg [4+5:0] rA;
          reg [4+5:0] rB;
          reg [4+5:0] rBX;
          reg [4+5:0] rFL;
          reg [4+5:0] rFL2;
          reg [4+5:0] rT;
          reg rA_en, rB_en, rT_en;
          reg [4+5:0] rA_reg;
          reg [4+5:0] rB_reg;
          reg [4+5:0] rBX_reg;
          reg [4+5:0] rFL_reg;
          reg [4+5:0] rFL2_reg;
          reg [4+5:0] rT_reg;
          reg rA_en_reg, rB_en_reg, rT_en_reg;
          reg [4+5:0] rA_reg2;
          reg [4+5:0] rB_reg2;
          reg [4+5:0] rBX_reg2;
          reg [4+5:0] rFL_reg2;
          reg [4+5:0] rFL2_reg2;
          reg [4+5:0] rT_reg2;
          reg rA_en_reg2, rB_en_reg2, rT_en_reg2;
          reg [4+5:0] rA_reg3;
          reg [4+5:0] rB_reg3;
          reg [4+5:0] rBX_reg3;
          reg [4+5:0] rFL_reg3;
          reg [4+5:0] rFL2_reg3;
          reg [4+5:0] rT_reg3;
          wire [5:0] alloc;
          wire [5:0] alloc2;
          wire [5:0] indexLDU;
          wire indexLDU_has;
          wire [5:0] indexLSU_ALU;
          wire indexLSU_ALU_has;
          reg [5:0] indexLDU_reg;
          reg indexLDU_has_reg;
          reg [5:0] indexLSU_ALU_reg;
          reg indexLSU_ALU_has_reg;
          reg [5:0] indexLDU_reg2;
          reg indexLDU_has_reg2;
          reg [5:0] indexLSU_ALU_reg2;
          reg [5:0] indexLSU_ALU_reg3;
          reg indexLSU_ALU_has_reg2;
          reg rA_en_reg3, rB_en_reg3, rT_en_reg3;
          reg [4+5:0] rA_reg4;
          reg [4+5:0] rB_reg4;
          reg [4+5:0] rBX_reg4;
          reg [4+5:0] rFL_reg4;
          reg [4+5:0] rFL2_reg4;
          reg [4+5:0] rT_reg4;
          reg rA_en_reg4, rB_en_reg4, rT_en_reg4;
          reg rA_en_reg5, rB_en_reg5, rT_en_reg5;
          reg rT_en0_reg,rT_en0_reg2,rT_en0_reg3,rT_en0_reg4,rT_en0_reg5;
          wire rT_en0;
          reg [4+5:0] rTMem;
          reg [4+5:0] rTMem_reg;
          reg [4+5:0] rTMem_reg2;
          reg [4+5:0] rTMem_reg3;
          reg [4+5:0] rTMem_reg4;
          wire [65:0] dataA;
          wire [65:0] dataB;
          wire [65:0] dataBX;
          wire [65:0] dataBIX;
          wire [63:0] dataBIXH;
          reg [63:0] dataBIXH_reg;
          wire c32h;
          wire [3:0] dataFL;
          wire [3:0] dataFL2;
          wire [63:0] dataMF;
          wire [63:0] dataBF;
          reg [63:0] dataMF_reg;
          reg [63:0] dataBF_reg;
          reg [63:0] dataMF_reg2;
          reg [63:0] dataBF_reg2;
          reg [63:0] dataMF_reg3;
          reg [63:0] dataBF_reg3;
          reg c32_reg;
          wire signed [65:0] dataBI;
          reg [65:0] dataA_reg;
          reg [65:0] dataB_reg;
          reg [65:0] dataBIX_reg;
          reg signed [65:0] dataBI_reg;
          reg [65:0] dataA_reg2;
          reg [65:0] dataB_reg2;
          reg [65:0] dataBIX_reg2;
          reg signed [65:0] dataBI_reg2;
          reg [65:0] dataA_reg3;
          reg signed [65:0] dataAS_reg3;
          reg [65:0] dataB_reg3;
          reg [65:0] dataBIX_reg3;
          reg signed [65:0] dataBIXS_reg3;
          reg signed [65:0] dataBI_reg3;
          reg [65:0] dataA_reg4;
          reg [65:0] dataAS_reg4;
          reg [65:0] dataB_reg4;
          reg [65:0] dataBIX_reg4;
          reg signed [65:0] dataBIXS_reg4;
          reg signed [65:0] dataBI_reg4;
          wire [5:0] data_phy;
          wire [63:0] res;
          wire [63:0] res_logic;
          wire [63:0] res_shift;
          wire [63:0] val_sxt;
          wire [63:0] val_else;
          wire [63:0] res_mul;
          reg  [63:0] res_shift_reg;
          reg [63:0] res_mul_reg;
          reg [20:0] opcode;
          reg [20:0] opcodex;
          reg [20:0] opcode_reg;
          reg [20:0] opcodex_reg;
          reg [20:0] opcode_reg2;
          reg [20:0] opcodex_reg2;
          reg [20:0] opcode_reg3;
          reg [20:0] opcodex_reg3;
          reg [20:0] opcode_reg4;
          reg [20:0] opcodex_reg4;
          reg [20:0] opcode_reg5;
          wire [4:0] cond;
          wire cond_tru;
          reg cond_tru_reg;
          wire [4:0] cond2;
          wire cond_xtru;
          reg cond_xtru_reg;
          integer fu3;
          integer sch;
          wire isand,op_anx,c32,c64,s64,foo,clres,clres2,clres3,res_cloop0,res_cloop1,res_cloop2,res_loop0,res_loop1,res_loop2;
          reg res_loop0_reg,res_loop1_reg,res_loop2_reg;
          reg res_cloop0_reg,res_cloop1_reg,res_cloop2_reg;
          reg c64_reg,s64_reg,chk_reg;
          reg res_loop0_reg2,res_loop1_reg2,res_loop2_reg2;
          reg res_cloop0_reg2,res_cloop1_reg2,res_cloop2_reg2;
          reg c64_reg2,s64_reg2,chk_reg2;
          reg res_loop0_reg3,res_loop1_reg3,res_loop2_reg3;
          reg res_cloop0_reg3,res_cloop1_reg3,res_cloop2_reg3;
          reg c64_reg3,s64_reg3,chk_reg3;
          reg res_loop0_reg4,res_loop1_reg4,res_loop2_reg4;
          reg res_cloop0_reg4,res_cloop1_reg4,res_cloop2_reg4;
          reg c64_reg4,s64_reg4,chk_reg4;
          reg [36:0] misaddr0;
          reg [63:0][63:0] dreqmort;
          reg [63:0][65:0] dreqdata;
          reg [7:0][63:0] dreqmort_flags;
          reg [63:0][3:0] dreqdata_flags;
          reg [63:0] missrs;
          reg [63:0] missrs_reg;
          reg [63:0] missrs_reg2;
          reg [63:0] missrs_reg3;
          reg [63:0] missrs_reg4;
          reg [63:0] miss;
          reg [63:0] miss_reg;
          reg [63:0] miss_reg2;
          reg [63:0] miss_reg3;
          reg [63:0] miss_reg4;
          reg miss_recover;
          reg write_upper_reg;
          wire [5:0] indexFLG;
          wire indexFLG_has;
          reg [5:0] indexFLG_reg;
          reg indexFLG_has_reg;
          wire [5:0] missphyfirst;
          wire [5:0] indexST;
          wire indexST_has;
          wire alloc_en,alloc2_en;
          wire [5:0] LQ;
          wire [5:0] LQX;
          reg [5:0] LQ_reg;
          reg [5:0] LQX_reg;
          wire c32a;
          wire opand;
          reg opand_reg;
          reg [36:0] missaddr0;
          wire [5:0] loopstop;
          reg [5:0] loopstop_save;
          reg is_flg_ldi;
          reg foo_reg;
          wire retire_ret;
          wire [3:0] cond_early;
          bit_find_index indexMiss(miss_reg2,index_miss[fu],index_miss_has[fu]);
          bit_find_index12 index12Miss(index_miss_has_reg2,index12m_idx,index12m_pos,index12m_idx_has);
          bit_find_index pfaff_mod({7'b0,missus_reg4[dreqmort[index_miss_reg4][18:11]]},missphyfirst,);
          assign missx_en[PHY]=index12m_idx_reg==fu;
          assign missx_addr[PHY]= fu==index12m_idx_reg ? xdreqmort[index12m_idx_reg][index_miss_reg3[index12m_idx_reg]] : 'z;
          assign missx_phy[PHY]={missus_reg4[dreqmort[index_miss_reg4][18:11]] && {5{index12m_idx==fu & (missphyfirst==(PHY/4))}},fu[3:0],1'b0};
          bit_find_index indexLSU_ALU_mod(~wstall & is_flg_ldi ? 1<<ldi2reg[fu][ldi] : rdy[2][fu][63:0]&rdy[1][fu][63:0]&rdy[3][fu][63:0]&rdy[4][fu][63:0]&{64{~index_miss_has && ~|miss_reg}},indexLSU_ALU,indexLSU_ALU_has);
          bit_find_index indexFLG_mod(rdy[3]&{64{~index_miss_has && ~|miss_reg}},indexFLG,indexFLG_has);
          bit_find_index indexLDU_mod(rdy[0][fu][63:0],indexLDU,indexLDU_has);
          bit_find_index indexAlloc(free,alloc[5:0],alloc_en);
          bit_find_indexR indexAlloc2(free,alloc2[5:0],alloc2_en);
          bit_find_index indexST_mod(dreqmort_flags[4][63:0] && dreqmort_flags[2][63:0] ,indexST,indexST_has);
          fpuadd64 Xadd(clk,rst,dataMF,dataBF,1'b1,xaddres);
          fpuprod64 Xmul(clk,rst,dataMF,dataBF,1'b1,xmulres);
          assign ret0[fu][PHY]=!data_retFL[reti][0];
          assign ret1[fu]=&ret0[fu];
          assign mret0[fu][PHY]=dreqmort_flags[5][reti] & dreqmort_flags[5][reti];
          assign mret1[fu]=&mret0[fu];
          assign mxret0[fu][PHY]=dreqmort_flags[5][reti]^dreqmort_flags[4][reti];
          assign mxret1[fu]=&mxret0[fu];
          assign retire_ret=&retire;
          assign rT[9:6]=fu;
          assign instr_clextra={insn_clopp[31:30],insn_clopp[24],insn_clopp[9:5],insn_clopp[3:0]};
          assign clres={dataA_reg[63:32],dataA_reg2[31:0]}<{dataB_reg[63:32],dataB_reg2[31:0]}-1;
          assign clres2={dataA_reg[63:32],dataA_reg2[31:0]}<{dataB_reg[63:32],dataB_reg2[31:0]};
          assign clres3={dataA_reg[63:32],dataA_reg2[31:0]}<={dataB_reg[63:32],dataB_reg2[31:0]};
          assign res_cloop0=cond_tru_reg && cond_xtru_reg && clres;
          assign res_cloop1=cond_tru_reg && cond_xtru_reg && clres2;
          assign res_cloop2=cond_tru_reg && cond_xtru_reg && clres3;
          assign res_loop0=clres;
          assign res_loop1=clres2;
          assign res_loop2=clres3;

          assign rT_en0=indexLSU_ALU_has;
          assign rT_en=opcode[5] && rT_en0;
          assign ldsize=1<<opcode[9:8]-1;
          assign ldsizes=ldsize & {3{opcode[10]}};
          assign LQ=opcode[19:14];
          assign LQX=opcodex[19:14];
          assign op_anx=opcode[7:5]==0 && |opcode[10:9];
          assign opand=opcode[7:5]!=0;
         // assign jindir=fu!=10 && !opcode[10];
          assign dataA[31:0]=data_gen[rA[9:6]][rA[5:0]][31:0] & {32{opand}};
          assign dataB[31:0]=data_gen[rB[9:6]][rB[5:0]][31:0];
          assign dataBI[31:0]=opcode[11] ?data_imm2[fu][rT[9:6]][rT[5:0]][9:0]*(data_phy): data_imm[fu][rT[9:6]][rT[5:0]][31:0];
          assign data_phy[31:0]=data_imm_phy[rT[9:6]][rT[5:0]][31:0];
          assign dataBX[31:0]=data_gen[rBX[9:6]][rBX[5:0]][31:0];
          assign dataBIX[31:0]=opcode[0] || opcode[7:0]==2 ? dataBI[31:0] : dataBX[31:0];
          assign {c32h,dataBIXH[31:0]}=dataBI_reg[31:0]+({32{opcode[11]}}&data_imm[fu][rT[9:6]][rT[5:0]][31:0]);
          assign dataA[63:32]=data_gen[rA_reg[9:6]][rA_reg[5:0]][63:32] & {34{opand_reg}};
          assign dataB[63:32]=data_gen[rB_reg[9:6]][rB_reg[5:0]][63:32];
          assign dataMF[63:0]=data_gen[rA_reg3[9:6]][rA_reg2[5:0]][63:0];
          assign dataBF[63:0]=data_gen[rB_reg3[9:6]][rB_reg2[5:0]][63:0];
          assign dataBI[63:32]=data_imm[fu][rT_reg[9:6]][rT_reg[5:0]][57:0]*(data_phy)>>32;
          assign dataBX[63:32]=data_gen[rBX_reg[9:6]][rBX_reg[5:0]][63:32];
          assign dataBIX[63:32]=opcode_reg[0] || opcode_reg[7:0]==2 ? dataBI[63:32] : dataBX[63:32];
          assign dataBIXH[63:32]=dataBI[63:32]+{32{dataBIXH[31]}}+c32h;
          assign dataFL=data_genFL[rFL[9:6]][rFL[5:0]][3:0];
          assign dataFL2=data_genFL[rFL2[9:6]][rFL2[5:0]][3:0];
          assign cond_tru=flcond(cond[3:0],dataFL);
          assign cond_xtru=flcond(cond2[3:0],dataFL2);
          assign {c32,res[31:0]}=opcode[7:0]==0 && cond_tru && !dataBI[32] ?
          dataA[31:0]+dataB[31:0]^{32{dataBI[33]}}+dataBI[33] : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==0 && cond_tru_reg ?
             {dataA[63],dataA[63:32]}+{dataBI_reg[34],dataB[63]&dataBI_reg[34],dataB[63:32]}^
          {32{dataBI_reg[33]}}+(c32_reg) : 'z;
          assign {c32,res[31:0]}=(opcode[7:2]==1 || opcode[4:3]==1) 
               && cond_tru  ?
             res_shift[32:0] : 'z;
          assign {s64,c64,res[63:32]}=(opcode_reg[7:2]==1 || opcode_reg[4:3]==1) 
              && cond_tru_reg ?
             {1'b0,res_shift[64:32]}&{33{opcode[7:2]==1}}|{33{opcode[7:2]!=1 && res_shift_reg[31]}} : 'z;
          assign {c32,res[31:0]}=opcode[4:3]==2 && cond_tru ?
             {1'b0,res_logic[31:0]} : 'z;
          assign isand=opcode[7:1]==8;
          assign {c64,s64,res[63:32]}=opcode_reg[4:3]==2 && cond_tru_reg ?
          {dataA_reg[65:64]|{!isand_reg|!chk,1'b0},res_logic[64:32]} : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==1 && cond_tru ?
          {1'b0,val_sxt[31:0]} : 'z;
          assign {s64,c64,res[63:32]}=opcode_reg[7:0]==1 && cond_tru_reg ?
          {val_sxt[63],val_sxt[64:32]} : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==2 && cond_tru ?
            dataA[31:0]+dataBI[31:0] : 'z;
          assign {c32a,resA[fu][31:0]}=dataA[31:0]+dataBI[31:0]+({32{opcode[11]}}&data_imm[fu][rT[9:6]][rT[5:0]][31:0]);
          assign resA[fu][63:32]=dataA_reg[63:32]+{32{resA_reg[fu][31]}}+c32a;
          assign {c64,s64,res[63:32]}=(opcode_reg[7:0]==2 || opcode_reg[7:0]==0 && dataBI_reg[32])&& cond_tru_reg ?
            {dataA[63],dataA[63:32]}+{dataBI_reg[63],dataBI_reg[63:32]} + (dataBI_reg[32] ? !res_reg[31] :c32_reg) : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==3 && opcode[8] && cond_tru ?
            dataBI[31:0] : 'z;
          assign {c32,res[31:0]}=opcode[7:0]==3 && ~opcode[8] && cond_tru ?
            dataB[31:0] : 'z;
          assign chk=addition_check(dataA[63:43],{dataA[42:32],dataA_reg[31:0]},{dataBIX[42:32],dataBIX_reg[31:0]},opcode_reg[11],isand)
             || ~dataA_reg[65]^dataA_reg[64] || ^dataA_reg[64:63];
          assign chkA=addition_check(dataA[63:43],{dataA[42:32],dataA_reg[31:0]},{dataBIXH[42:32],dataBIXH_reg[31:0]},opcode_reg[11],isand)
             || ~dataA_reg[65]^dataA_reg[64] || ^dataA_reg[64:63];
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==3 && opcode_reg[8] && cond_tru_reg ?
          {1'b0,dataBI_reg[63],dataBI_reg[63:32]} : 'z;
          assign {c64,s64,res[63:32]}=opcode_reg[7:0]==3 && ~opcode_reg[8] && cond_tru_reg ?
          {1'b0,dataB_reg[63],dataB_reg[63:32]} : 'z;
          assign res_logic[31:0]=opcode[2:1]==0 &~foo ? dataA[31:0]&dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==1 &~foo ? dataA[31:0]^dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==2 &~foo ? dataA[31:0]|dataBIX[31:0] : 'z;
          assign res_logic[31:0]=opcode[2:1]==3 &~foo & dataBI[7] ? xdataA[({1'b0,loopstop[5:0]}+{1'b0,dataBIX[5:0]})%36][fu][31:0] 
              : 'z;
          assign res_logic[31:0]=opcode[2:1]==3 &~foo & ~dataBI[7] ? dataA[31:0] 
              : 'z;
          assign res_logic[31:0]=foo ? dataA[31:0] :'z;

          assign phy[PHY].opcode_reg[fu]=opcode_reg;
          assign phy[PHY].dreqmort_flags[fu]=dreqmort_flags;
          assign phy[PHY].indexST_has[fu]=indexST_has;

          assign res_logic[63:32]=opcode_reg[2:1]==0 &~foo_reg ? dataA[63:32]&dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==1 &~foo_reg ? dataA[63:32]^dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==2 &~foo_reg ? dataA[63:32]|dataBIX[63:32] : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==3 &~foo_reg & dataBI_reg[7] ? xdataA[({1'b0,loopstop[5:0]}+{1'b0,dataBIX_reg[5:0]})%36][fu][63:32] 
              : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==3 &~foo_reg & ~dataBI_reg[7] && dataA[58:43]>13 ? {dataA_reg[11:4],dataA_reg[10:4]+dataBI_reg[10:4],6'd4,dataA[42:32]}
              : 'z;
          assign res_logic[63:32]=opcode_reg[2:1]==3 &~foo_reg & ~dataBI_reg[7] && dataA[58:43]<=13 ? dataA_reg[63:32]
              : 'z;
          assign res_logic[63:32]=foo_reg && dataA[58:43]>13 ? {dataA_reg[13:6],dataA_reg[12:6]+dataBI_reg[12:6],6'd6,dataA[42:32]} : 'z; //stackframe alloc; chunks of 64 bytes up to 127
          assign res_logic[63:32]=foo_reg && dataA[58:43]<=13 ? {dataA[63:32]} : 'z; //stackframe alloc; chunks of 64 bytes up to 127

          assign res_mul[31:0]=opcode_reg2[4:3]==3 && opcode_reg2[2]==0 ? dataA_reg3[31:0]*dataBIX_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[4:3]==3 && opcode_reg2[2:1]==2'b10 ? dataAS_reg3[31:0]*dataBIXS_reg3[31:0] : 'z;
          assign res_mul[31:0]=opcode_reg2[4:3]==3 && opcode_reg2[2:1]==2'b11 && !dataBI_reg4[6] ? dataAS_reg3[63:0]>>>dataBIXS_reg3[5:0]: 'z;
          assign res_mul[31:0]=opcode_reg2[4:3]==3 && opcode_reg2[2:1]==2'b11 && dataBI_reg4[6] ? dataAS_reg3[63:0]>>dataBIXS_reg3[5:0]: 'z;
          assign res_mul[63:32]=opcode_reg3[4:3]==3 && opcode_reg3[2:1]==0 ? dataA_reg4[63:0]*dataBIX_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[4:3]==3 && opcode_reg3[2:1]==1 ? dataA_reg4[31:0]*dataBIX_reg4[31:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[4:3]==3 && opcode_reg3[2:1]==2'b10 ? dataAS_reg4[63:0]*dataBIXS_reg4[63:0]>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[4:3]==3 && opcode_reg3[2:1]==2'b11 && !dataBI_reg4[6] ? dataAS_reg4[63:0]>>>dataBIXS_reg4[5:0]>>>32 : 'z;
          assign res_mul[63:32]=opcode_reg3[4:3]==3 && opcode_reg3[2:1]==2'b11 && dataBI_reg4[6] ? dataAS_reg4[63:0]>>dataBIXS_reg4[5:0]>>32 : 'z;
          assign val_else[31:0]=opcode[12:11]==0 ? dataA[31:0] : 'z;
          assign val_else[31:0]=opcode[12:11]==1 ? 1 : 'z;
          assign val_else[31:0]=opcode[12:11]==2 ? 0: 'z;
          assign val_else[31:0]=opcode[12:11]==3 ? '1 : 'z;
          assign val_else[65:32]=opcode[12:11]==0 ? dataA[65:32] : 'z;
          assign val_else[65:32]=opcode[12:11]==1 ? 1<<33+1 : 'z;
          assign val_else[65:32]=opcode[12:11]==2 ? 1<<33 : 'z;
          assign val_else[65:32]=opcode[12:11]==3 ? 34'h1_ffff_ffff : 'z;
          assign val_sxt[31:0]=dataBI[25:24]!=3 ? dataA[31:0]<<(8<<dataBI[25:24])>>>(8<<dataBI[25:24]) : {dataA[7:0],dataA[15:8],dataA[23:16],dataA[31:24]};
          assign val_sxt[63:0]=dataBI_reg[25:24]!=3 ? dataA_reg[31:0]<<(8<<dataBI[25:24])>>>(8<<dataBI[25:24])>>>32 : {32{dataA_reg}};
          assign res_shift[31:0]=opcode[3:1]==2 ? dataA[31:0]<<dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:1]==3 ? dataA[31:0]<<dataBI[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==8 ? dataA[31:0]>>dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==9 ? dataA[31:0]>>dataBI[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==10 ? dataA[31:0]>>>dataB[5:0] : 'z;
          assign res_shift[31:0]=opcode[3:0]==11 ? dataA[31:0]>>>dataBI[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]==4 ? {dataA[63:32],dataA_reg[31:0]}<<dataB_reg[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]==6 ? {32{res_shift_reg[31]}} : 'z;
          assign res_shift[63:32]=opcode[3:0]==5 ? {dataA[63:32],dataA_reg[31:0]}<<dataBI_reg[5:0] : 'z;
          assign res_shift[63:32]=opcode[3:0]>=7 ? {32{res_shift_reg[31]}} : 'z;
          assign cond=data_cond[fu][indexLSU_ALU_reg];
          assign cond2=data_cond2[fu][indexLSU_ALU_reg];
          assign cond_early=data_cond[fu][indexFLG_reg];
          assign isJump[fu]=opcode[7:5]==0 && opcode[8];
          assign inssr[fu]=instr;
          assign xalloc[fu]=alloc;
          assign xalloc2[fu]=alloc2;
          assign xdataA[PHY][fu]=dataA;
          assign phy[PHY].xdreqmort=dreqmort;

          reg [5:0] LDI;
          reg [5:0] LDI_reg;
          reg [5:0] miss_rvi;
          reg [39:0] instr;
          reg [23:0] insn_isptr;
          assign loopstop=data_loopstop[indexLSU_ALU_reg]==63 ? loopstop_save : data_loopstop[indexLSU_ALU_reg];
          always @(posedge clk) begin
              loopstop_save<=loopstop;
              dataA_reg[63:32]<=dataA[63:32];
            //  dataA_rexx[31:0]<=dataA[31:0];
              dataA_reg[31:0]<=dataA[31:0];
              dataA_reg2<=dataA_reg;
              dataA_reg3<=dataA_reg2;
              dataAS_reg3<=dataA_reg2;
              dataA_reg4<=dataA_reg3;
              dataAS_reg4<=dataAS_reg4;
              resA_reg<=resA;
              resA_reg2<=resA_reg;
              write_size_reg<=write_size;
              ldsize_reg<=ldsize;
              dataBIX_reg[63:32]<=dataBIX[63:32];
             // dataBIX_rexx[31:0]<=dataBIX[31:0];
              dataBIX_reg[31:0]<=dataBIX[31:0];
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
              foo_reg<=foo;
              dataBIXH_reg<=dataBIXH;
              rA<=rdyA[fu][indexLSU_ALU];
              rB<=rdyB[fu][indexLSU_ALU];
              rBX<=rdyB[fu][indexLDU];
              rT<={fu[3:0],indexLSU_ALU};
              rTMem<={fu[3:0],rdyM[fu][indexLSU_ALU]};
              opcode<=data_op[fu][indexLSU_ALU];
              opcodex<=data_op[fu][indexLDU];
              rFL<=rdyFL0[fu][indexLSU_ALU];
              rFL2<=rdyFL1[fu][indexLSU_ALU];
              rA_reg<=rA;
              rB_reg<=rB;
              rBX_reg<=rBX;
              rT_reg<=rT;
              rTMem_reg<=rTMem;
              opcode_reg<=opcode;
              opcodex_reg<=opcodex;
              rFL_reg<=rFL;
              rFL2_reg<=rFL2;
              rA_reg2<=rA_reg;
              rB_reg2<=rB_reg;
              rBX_reg2<=rBX_reg;
              rT_reg2<=rT_reg;
              rTMem_reg2<=rTMem_reg;
              opcode_reg2<=opcode_reg;
              opcodex_reg2<=opcodex_reg;
              rFL_reg2<=rFL_reg;
              rFL2_reg2<=rFL2_reg;
              rA_reg3<=rA_reg2;
              rB_reg3<=rB_reg2;
              rBX_reg3<=rBX_reg2;
              rT_reg3<=rT_reg2;
              rTMem_reg3<=rTMem_reg2;
              opcode_reg3<=opcode_reg2;
              opcodex_reg3<=opcodex_reg2;
              rFL_reg3<=rFL_reg2;
              rFL2_reg3<=rFL2_reg2;
              rA_reg4<=rA_reg3;
              rB_reg4<=rB_reg3;
              rBX_reg4<=rBX_reg3;
              rT_reg4<=rT_reg3;
              rTMem_reg4<=rTMem_reg3;
              opcode_reg4<=opcode_reg3;
              opcodex_reg4<=opcodex_reg3;
              rFL_reg4<=rFL_reg3;
              rFL2_reg4<=rFL2_reg3;
              res_shift_reg<=res_shift;
              resX_reg<=resX;
              res_reg<=res;
              res_reg2<=res_reg;
              res_reg3<=res_reg2;
              res_mul_reg<=res_mul;
              isand_reg<=isand;
              c32_reg<=c32;
              retire_reg<=retire;
              rT_en_reg<=rT_en;
              rT_en_reg2<=rT_en_reg;
              rT_en_reg3<=rT_en_reg2;
              rT_en_reg4<=rT_en_reg3;
              rT_en_reg5<=rT_en_reg4;
              rT_en0_reg<=rT_en0;
              rT_en0_reg2<=rT_en0_reg;
              rT_en0_reg3<=rT_en0_reg2;
              rT_en0_reg4<=rT_en0_reg3;
              rT_en0_reg5<=rT_en0_reg4;
              miss_reg<=miss_reg ? miss_reg && ~{64{miss_recover}} : miss;
              miss_reg2<=miss_reg && ~{64{miss_recover}};
              miss_reg3<=miss_reg2 && ~{64{miss_recover}};
              miss_reg4<=miss_reg4|miss_reg3 && ~{64{miss_recover}};
              missrs_reg<=missrs_reg ? missrs_reg && ~{64{miss_recover}} : missrs;
              missrs_reg2<=missrs_reg && ~{64{miss_recover}};
              missrs_reg3<=missrs_reg2 && ~{64{miss_recover}};
              missrs_reg4<=missrs_reg4|missrs_reg3 && ~{64{miss_recover}};
              res_loop0_reg<=res_loop0;
              res_loop1_reg<=res_loop1;
              res_loop2_reg<=res_loop2;
              res_cloop0_reg<=res_cloop0;
              res_cloop1_reg<=res_cloop1;
              res_cloop2_reg<=res_cloop2;
              c64_reg<=c64;
              s64_reg<=s64;
              chk_reg<=chk;
              res_loop0_reg2<=res_loop0_reg;
              res_loop1_reg2<=res_loop1_reg;
              res_loop2_reg2<=res_loop2_reg;
              res_cloop0_reg2<=res_cloop0_reg;
              res_cloop1_reg2<=res_cloop1_reg;
              res_cloop2_reg2<=res_cloop2_reg;
              c64_reg2<=c64_reg;
              s64_reg2<=s64_reg;
              chk_reg2<=chk_reg;
              res_loop0_reg3<=res_loop0_reg2;
              res_loop1_reg3<=res_loop1_reg2;
              res_loop2_reg3<=res_loop2_reg2;
              res_cloop0_reg3<=res_cloop0_reg2;
              res_cloop1_reg3<=res_cloop1_reg2;
              res_cloop2_reg3<=res_cloop2_reg2;
              c64_reg3<=c64_reg2;
              s64_reg3<=s64_reg2;
              chk_reg3<=chk_reg2;
              res_loop0_reg4<=res_loop0_reg3;
              res_loop1_reg4<=res_loop1_reg3;
              res_loop2_reg4<=res_loop2_reg3;
              res_cloop0_reg4<=res_cloop0_reg3;
              res_cloop1_reg4<=res_cloop1_reg3;
              res_cloop2_reg4<=res_cloop2_reg3;
              c64_reg4<=c64_reg3;
              s64_reg4<=s64_reg3;
              chk_reg4<=chk_reg3;
              dataMF_reg<=dataMF;
              dataBF_reg<=dataBF;
              dataMF_reg2<=dataMF_reg;
              dataBF_reg2<=dataBF_reg;
              dataMF_reg3<=dataMF_reg2;
              dataBF_reg3<=dataBF_reg2;
              LQ_reg<=LQ;
              LQX_reg<=LQX;
              write_upper_reg<=write_upper;
              cond_tru_reg<=cond_tru;
              cond_xtru_reg<=cond_xtru;
              indexLDU_reg<=indexLDU;
              indexLDU_has_reg<=indexLDU_has;
              indexLSU_ALU_reg<=indexLSU_ALU;
              indexLSU_ALU_has_reg<=indexLSU_ALU_has;
              indexLDU_reg2<=indexLDU_reg;
              indexLDU_has_reg2<=indexLDU_has_reg;
              indexLSU_ALU_reg2<=indexLSU_ALU_reg;
              indexLSU_ALU_reg3<=indexLSU_ALU_reg2;
              indexLSU_ALU_has_reg2<=indexLSU_ALU_has_reg;
              indexFLG_reg<=indexFLG;
              indexFLG_has_reg<=indexFLG_has;
              if (missx_en) misaddr0<=missx_addr;
            //  if (miss_pfaff || missrs_reg4[index_miss] && miss_reg4[index_miss]) miss_reg4[index_miss]<=1'b0;
              miss_recover<=1'b0;
              if (insetr_addr==missaddr0 && insetr_en || insetrh_addr==missaddr0 && insetrh_en || insetrv_addr==missaddr0 && insetrv_en) begin
                  miss_rvi<=miss_reg4;
                  miss_reg4<=0;
                  miss_recover<=1'b1;
              end
              if (1<<indexLSU_ALU==miss_rvi) begin
                  miss_rvi<=0;
                  opcode[5]<=1'b0;
              end
              is_write<=1'b0;
              is_write_reg<=is_write;
              if (ids0_has && ids0==fu) begin
                   resX[fu]<=dreqmort[ids0];
                   resWD[fu]<=dreqdata[ids0];
                   write_size[fu]<=1<<{dreqmort_flags[1][ids0],dreqmort_flags[0][ids0]};
                   is_write[fu]<=1'b1;
                   write_upper[fu]<=dreqmort_flags[6][ids0];
              end
              if (ids1_has && ids1==fu) begin
                   resX[fu]<=dreqmort[ids1];
                   resWD[fu]<=dreqdata[ids1];
                   write_size[fu]<=1<<{dreqmort_flags[1][ids1],dreqmort_flags[0][ids1]};
                   is_write[fu]<=1'b1;
                   write_upper[fu]<=dreqmort_flags[6][ids1];
              end
              if (indexFLG_has_reg) begin
                  if (flcond(cond_early,data_cond[fu][indexFLG_reg])) begin
                      if (data_op[indexFLG_reg][4:0]==3) rdy[indexFLG_reg[1]]=1'b1;
                  end else begin
                      rdy[indexFLG_reg][2]=1'b1;
                  end
              end
              if (except) begin 
                  rTT<=rTTB;
                  rTTE<='1;
                  rdy<='0;
              end
              if (retire && retire_bndl && retire_ret) begin
                  if (ret_is_alu[reti]) begin
                      rTTE[rTTOld[reti]][1]<=1'b1;
                      rTTB[rTT_arch[reti]]<=rTTNew[reti];
                  end else begin
                      rTTE[rTTNew[reti]][1]<=1'b1;
                  end
              end
              if (rT_en0_reg | rT_en_reg && |opcode_reg[7:6]) begin
                  dreqmort[LQ][31:0]<=res[31:0];
                  dreqmort_flags[LQ]<={~opcode_reg[20],~chk&~opcode_reg[5]||~chkA,1'b0,opcode_reg[7:6],opcode_reg[9:8]};
              end
              if (rT_en0_reg2 | rT_en_reg2 && |opcode_reg2[7:6]) begin
                  dreqmort[LQ][65:32]<={chk ? res[63] : c64,chk ? ~res[63]:s64,res[63:32]};
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
                  if (rT_en && rdyB[fu3][sch]==rT && rdy[fu3][sch][5]) rdy[fu3][sch][2]=1'b1; 
                  if (rT_en && rdyB[fu3][sch]==rT && rdy[fu3][sch][3]) rdy[fu3][sch][0]=1'b1;
                  if (rT_en && rdyA[fu3][sch]==rT && rdy[fu3][sch][4]) rdy[fu3][sch][1]=1'b1;
                  if (rT_en && rdyFL0[fu3][sch]==rT && rdy[fu3][sch][6]) rdy[fu3][sch[7]]=1'b1;
                  if (rT_en && rdyFL1[fu3][sch]==rT && rdy[fu3][sch[8]]) rdy[fu3][sch[9]]=1'b1;
              end
              aligned[PHY][fu]<=dreqmort_flags[4][LDI]|dreqmort_flags[2][LDI];
              if (&aligned && !wstall && !wstall_reg) begin
                dreqmort_flags[4][LDI_reg]<=1'b1;
                dreqmort_flags[7][LDI_reg]<=lderror;
                LDI_reg<=LDI;
                LDI<=LDI+1;
                is_flg_ldi<=dreqmort_flags[6][LDI_reg];
                if (dreqmort_flags[LDI_reg][3]) begin
                      rTTE[rTTOldm[reti]][1]<=1'b1;
                      rTTB[rTT_archm[reti]]<=rTTNewm[reti];
                end
              end
              wstall_reg<=wstall;
              instr<=pppoc_reg2[fu*40+:40];
              insn_clopp<=pppoc_reg2[255-32+:32];
              insn_isptr<=pppoc2_reg2;
              if (rT_en_reg && opcode[10] | opcode[5]) data_gen[rT_reg[5:0]][31:0]<=res[31:0];
              if (rT_en0_reg3 && opcode_reg2[7]) data_gen[rTMem_reg2[5:0]][31:0]<=pppoe_reg[31:0];
              if (rT_en0_reg3 && opcode_reg2[5:3]==35) data_gen[rTMem_reg2[5:0]][31:0]<=res_mul[31:0];
              if (rT_en_reg2 && opcode_reg2[10] | opcode_reg2[5]) data_gen[rT_reg2[5:0]][65:32]<={chk ? res[63] : c64,chk ? ~res[63]:s64,res[63:32]}&{34{opcode_reg[20]}};
              if (rT_en_reg2) data_genFL[rT_reg2[5:0]][3:0]<=opcode_reg2[7:0]==1 && dataBI_reg2[22] ? {dataMF_reg[65:63],~|dataMF_reg[62:53]} : opcode_reg2[7] ? {1'b0,pppoe_reg3[63],pppoe_reg3[63],~|pppoe_reg3[63:0]}:
                  {chk_reg2 ? res_reg2[63] : c64_reg2,chk_reg2 ? ~res_reg2[63]:s64_reg2,res_reg2[63],~|res_reg2[63:0]};
              if (rT_en_reg2) data_retFL[LQ_reg][3:0]<=opcode_reg2[7:5]==0 ? {dataMF[65:63],~|dataMF[62:53]} : {chk ? res[63] : c64,chk ? ~res[63]:s64,res[63],~|res[63:0],1'b0};
              if (rT_en_reg2 && opcode_reg2[10] && ~|opcode_reg2[7:6]) data_retFL[LQ_reg][3:0]<=opcode_reg2[9]==0 ? {res_loop0,res_loop2,res_loop2,res_loop1,1'b0} : {res_cloop0,res_cloop2,res_cloop2,res_cloop1,1'b0};
              if (rT_en_reg5 &&(opcode_reg4[7:5]==0 && opcode_reg4[4:0]==1 && dataBI_reg4[20])) data_fp[rTMem_reg4[5:0]]<=dataBI_reg4[22] ? dataMF_reg2 : xaddres;
              if (rT_en_reg5 &&(opcode_reg4[7:5]==0 && opcode_reg4[4:0]==1 && dataBI_reg4[21])) data_fp[rTMem_reg4[5:0]]<=xmulres;
              if (rT_en_reg5 &&(opcode_reg4[7] )) data_fp[rTMem_reg4[5:0]]<=flconv(pppoe_reg3,opcode_reg4[8]);
              if (rT_en0_reg4 && opcode_reg3[5:3]==35) data_gen[rTMem_reg3[5:0]][65:32]<=res_mul[63:32];
              if (rT_en0_reg4 && opcode_reg3[7]) data_gen[rTMem_reg2[5:0]][65:32]<=pppoe_reg2[65:32];
              if (rT_en0_reg3 && opcode_reg2[7:0]==1 && dataBI_reg2[22]) data_gen[rTMem_reg3[5:0]][65:32]<=fsconv(dataMF_reg,dataBI_reg3[24:23])>>32;
              if (rT_en0_reg2 && opcode_reg[7:0]==1 && dataBI_reg[22]) data_gen[rTMem_reg3[5:0]][31:0]<=fsconv(dataMF,dataBI_reg2[24:23]);
              if (rT_en0_reg4 && fu==idj0p) begin
                   jcond0[LQ]<=res_reg3;
                   jcondx0[LQ]<=!opcode_reg4[8] || opcode_reg4[7:5]!=0 ? 11 : opcode_reg4 [10]  ? 4 : cond;
                   if (opcode_reg4[10]) jcond0[LQ]<=srcIPOff[LQ]+{data_cloop[rT_reg4[5:0]],5'b1};
                   if (opcode_reg4[8]) jcond0[LQ]<=srcIPOff[LQ]+res_reg3;
                   jcc0[LQ]<=opcode_reg4[10] ?(opcode_reg4[9]==0 ? {res_loop0_reg2,res_loop2_reg2,res_loop2_reg2,res_loop1_reg2,1'b0} : {res_cloop0_reg2,res_cloop2_reg2,res_cloop2_reg2,res_cloop1_reg2,1'b0}):opcode_reg2[7:5]==0 ? {dataMF_reg3[65:63],~|dataMF_reg3[62:53]} : {chk_reg3 ? res_reg3[63] : c64_reg3,chk_reg3 ? ~res_reg3[63]:s64_reg3,res_reg3[63],~|res_reg3[63:0],1'b0};
               end
               if (rT_en0_reg4 && fu==idj1p) begin
                   jcond1[LQ]<=res_reg3;
                   jcondx1[LQ]<=!opcode_reg4[8] || opcode_reg4[7:5]!=0 ? 11 : opcode_reg4 [10]  ? 4 : cond;
                   if (opcode_reg4[10]) jcond1[LQ]<=srcIPOff[LQ]+data_cloop[rT_reg4[5:0]];
                   if (opcode_reg4[8]) jcond1[LQ]<=srcIPOff[LQ]+res_reg3;
                   jcc1[LQ]<=opcode_reg4[10] ?(opcode_reg4[9]==0 ? {res_loop0_reg2,res_loop2_reg2,res_loop2_reg2,res_loop1_reg2,1'b0} : {res_cloop0_reg2,res_cloop2_reg2,res_cloop2_reg2,res_cloop1_reg2,1'b0}):opcode_reg2[7:5]==0 ? {dataMF_reg3[65:63],~|dataMF_reg3[62:53]} : {chk_reg3 ? res_reg3[63] : c64_reg3,chk_reg3 ? ~res_reg3[63]:s64_reg3,res_reg3[63],~|res_reg3[63:0],1'b0};
               end
               if (insert_en && (fu>=insn_clopp[13:10] && IP[4:0]==insn_clopp[19:15])|
                    (fu>=insn_clopp[23:10] && IP[4:0]==insn_clopp[29:25])  ) begin
                  data_op[fu][alloc][7:6]=instr[39:38];
                  if (&instr[39:38]) data_op[fu][alloc][7:6]=2'b0;
                 if (instr[39:38]==2'b10 && instr[33]|instr[34]&~instr[12]) begin
                   data_imm[fu][alloc]=&instr[34:33] ? ret_cookie_reg3 : {{41{instr[24]}}^{17'b0,insn_clopp[31],13'b0},instr[24:14],instr[11:0]};
                   data_op[fu][alloc][11]<=instr[13]; //1=call 0=jump
                   data_cond[fu][alloc]={instr[37:35],instr[32]};
                   data_cond2[fu][alloc]=instr[31:28];
                   data_op[fu][alloc][10:8]=instr[27:25];
                   if (instr[34:33]==2 && !instr[25]) data_imm[fu][alloc]<=instr[1:0];
                   if (instr[25]) data_imm[fu][alloc]<=0;
                   data_op[7:0] = instr[25] || instr[34:33]==2 ? 0 : 3;
                   if (instr[27]) data_loopstop=idxpreda_has_reg3 ? idxpreda_reg3 : idxpredb_has_reg3 ? idxpredb_reg3 : 63;
                  end else if (^instr[39:38]) begin
                      data_op[fu][alloc][10:8]=instr[37:35];
                      data_op[fu][alloc][5]=instr[34];
                      data_op[fu][alloc][4:0]=5'b1;
                      data_op[fu][alloc][11]=instr[34];
                      data_imm[fu][alloc]={{52{instr[24]}},instr[24:13]};
                      data_imm2[fu][alloc]=instr[32:25];
                    if (!instr[12]) data_imm[fu][alloc]={{44{instr[32]}},instr[32:13]};
                      if (instr[12]) data_phy[alloc]=vec_reg3 ? 36 : PHY;
                      else data_phy[alloc]=0;
                    if (!instr[34]) begin
                        data_imm[fu][alloc]=- 64'b1<<instr[36:35];
                        data_imm2[fu][alloc]=instr[32:13];
                        data_phy[alloc]=1;
                    end
                  end
                  if (&instr[39:38]) begin
                    data_op[fu][alloc][4:0]={instr[37:34],instr[14]};
                      data_op[fu][alloc][5]=1'b1;
                    data_cond[fu][alloc][3:0]=instr[12:9];
                    data_imm[fu][alloc]={{46{instr[32]}},instr[32:15]};
                    data_op[fu][alloc][8]=1'b1;
                    if (!instr_clextra[fu]) begin
                      data_op[fu][alloc][8]=1'b0;
                      if (rst_reg5 || IP_reg4[41:5]==1) data_imm[fu][alloc]<={8'h0,7'h7f,6'd36,43'b0};
                      else if (irqload_reg5) data_imm[fu][alloc]<={15'b0,6'd63,1'b0,IP_reg4};
                      else if (IP_reg4[42]) data_imm[fu][alloc]={spgcookie({instr[17:15],instr[8:4]}),4'b0,instr[32:15],instr[8:4],17'b0};
                      else data_imm[fu][alloc]<={8'h0,7'h1,6'd3,43'b0};
                    end  
                  end
                  if (!|instr[39:38]) begin
                    data_op[fu][alloc][4:0]={instr[37:34],instr[12]};
                      data_op[fu][alloc][5]=instr[37:34]==0 || instr[37:34]==8 && !instr[12] ? instr[26] /*fpuinsn*/ : 1'b1;
                      data_cond[fu][alloc][3:0]=instr[32:27];
                    data_op[fu][alloc][8]=1'b0;
                    data_imm[fu][alloc]={{20{instr[26]}},instr[26:14],instr[11:8],18'b0};
                      if ({instr[37:34],instr[14]}==19) begin
                        data_imm[fu][alloc]={{30{instr[26]}},instr[26:25],{20{instr[24]}},instr[24:14]};
                        data_op[fu][alloc][4:0]=2;
                      end
                  end
                  ret_is_load[insi]<=1'b0;
                  ret_is_alu[insi]<=1'b0;
                  if (instr[39:38]==2) begin
                    rTT[{insn_clopp[4]&&~|instr[3:2],insn_clopp[14]|(insn_clopp[4]&&~|instr[3:2]),instr[3:0]}]<={fu[3:0],alloc2};
                    rTTOldm[insi]<=rTT[{insn_clopp[4]&&~|instr[3:2],insn_clopp[14]|(insn_clopp[4]&&~|instr[3:2]),instr[3:0]}];
                    rTTNewm[insi]<={fu[3:0],alloc2};
                    rTTE[alloc2][0]<=1'b1;
                    rTT_archm[insi]<={insn_clopp[4]&&~|instr[3:2],insn_clopp[14]|(insn_clopp[4]&&~|instr[3:2]),instr[3:0]};
                    ret_is_load[insi]<=1'b1;
                    //rTMem[insi]<=alloc2;
                    if (instr[34]) begin
                        rTT[{insn_clopp[4]&&~|instr[7:6],1'b0|(insn_clopp[4]&&~|instr[7:6]),instr[7:4]}]<={fu[3:0],alloc};
                        rTTOld[insi]<=rTT[{insn_clopp[4]&&~|instr[7:6],1'b0,instr[7:4]}];
                        rTTNew[insi]<={fu[3:0],alloc};
                        rTTE[alloc][0]<=1;
                        rTT_arch[insi]<={insn_clopp[4]&&~|instr[7:6],1'b0,instr[7:4]};
                        ret_is_alu[insi]<=1'b1;
                    end
                  end
                  if (~^instr[39:38] || instr[39:38]==1 && instr[34]) begin
                       rTT[{insn_clopp[4]&&~|instr[3:2],insn_clopp[14]|(insn_clopp[4]&&~|instr[3:2]),instr[3:0]}]<={fu[3:0],alloc};
                       rTTOld[insi]<=rTT[{insn_clopp[4]&&~|instr[3:2],insn_clopp[14],instr[3:0]}];
                       rTTNew[insi]<={fu[3:0],alloc};
                       rTTE[alloc][0]<=1'b1;
                       rTT_arch[insi]<={insn_clopp[4]&&~|instr[3:2],insn_clopp[14],instr[3:0]};
                       ret_is_alu[insi]<=1'b1;
                       //rTMem[insi]<=alloc;
                  end
                   data_retFL[insi]<=1;
                   rdyA[fu][alloc]<=rTT[{insn_clopp[4]&&~|instr[7:6],instr[39:38]==2 ? insn_clopp [24]|(insn_clopp[4]&&~|instr[7:6]) : insn_clopp[14]|(insn_clopp[4]&&~|instr[7:6]),instr[7:4]}];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && inssr[fuZ][3:0]==instr[7:4] && inssr[fuZ][39:38]==2)
                       rdyA[fu][alloc]<={fuZ[3:0],xalloc2[fuZ]};
                     if(fuZ<fu && inssr[fuZ][3:0]==instr[7:4] && ~^inssr[fuZ][39:38])
                       rdyA[fu][alloc]<={fuZ[3:0],xalloc[fuZ]};
                   end
                   rdyB[fu][alloc]<=rTT[{insn_clopp[4]&&~|instr[11:10],insn_clopp[14]|(insn_clopp[4]&&~|instr[11:10]),instr[11:8]}];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && inssr[fuZ][3:0]==instr[11:8] && inssr[fuZ][39:38]==2)
                       rdyB[fu][alloc]<={fuZ[3:0],xalloc2[fuZ]};
                     if(fuZ<fu && inssr[fuZ][3:0]==instr[11:8] && ~^inssr[fuZ][39:38])
                       rdyB[fu][alloc]<={fuZ[3:0],xalloc[fuZ]};
                   end
                   rdyFL0[fu][alloc]<=rTT[instr[33]];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && inssr[fuZ][3:0]=={3'b0,instr[33]} && inssr[fuZ][39:32]==2)
                       rdyFL0[fu][alloc]<={fuZ[3:0],xalloc2[fuZ]};
                     if(fuZ<fu && inssr[fuZ][3:0]=={3'b0,instr[33]} && ~^inssr[fuZ][39:38])
                       rdyFL0[fu][alloc]<={fuZ[3:0],xalloc[fuZ]};
                   end
                   rdyFL1[fu][alloc]<=rTT[2];
                   for(fuZ=0;fuZ<12;fuZ++) begin
                     if(fuZ<fu && inssr[fuZ][3:0]==2 && inssr[fuZ][39:32]==2)
                       rdyFL1[fu][alloc]<={fuZ[3:0],xalloc2[fuZ]};
                     if(fuZ<fu && inssr[fuZ][3:0]==2 && ~^inssr[fuZ][39:38])
                       rdyFL1[fu][alloc]<={fuZ[3:0],xalloc[fuZ]};
                   end
                   //NOTE: second flag needed only for cloop; correct later
                  {rdy[5][fu][alloc],rdy[4][fu][alloc],rdy[3][fu][alloc],rdy[2][fu][alloc],rdy[1][fu][alloc],rdy[0][fu][alloc]}<={1'b1,instr[39:38]==2'b10,instr[39:38]==2'b10,1'b0,instr[32:27]==3,instr[39:38]!=2'b01};  
                  data_op[fu][alloc][12:11]=instr[13:12];
                  data_op[fu][alloc][19:14]=insi[5:0];
                  insi<=insi+1;
                  data_op[fu][alloc][20]=instr_clextra[fu] && data_op[fu][alloc][4:0]!=3;
                  ldi2reg[fu][insi]<=alloc;
                  if (instr[37:34]==0 && !instr[12] || instr[37:34]==8 && !instr[12]) begin
                      data_op[fu][alloc][7:0]<=8'b10101001;
                      data_op[fu][alloc]<='0;
                  end 
              end
          end
          always @* begin
                  wstall[PHY][fu]<=1'b0;
                  lderror<=64'b0;
                  missus=0;
                  miss=0;
                  for(ldi=0;ldi<64;ldi++) begin
                      if (is_wconfl(dreqmort[LDI_reg],{dreqmort_flags[7][LDI_reg],dreqmort_flags[6][LDI_reg],dreqmort_flags[5][LDI_reg],
                          dreqmort_flags[4][LDI_reg],dreqmort_flags[3][LDI_reg],dreqmort_flags[2][LDI_reg],dreqmort_flags[1][LDI_reg],
                          dreqmort_flags[0][LDI_reg]},dreqmort[ldi],{dreqmort_flags[7][ldi],dreqmort_flags[6][ldi],dreqmort_flags[5][ldi],
                          dreqmort_flags[4][ldi],dreqmort_flags[3][ldi],dreqmort_flags[2][ldi],dreqmort_flags[1][ldi],dreqmort_flags[0][ldi]}))
                          wstall[PHY][fu]<=1'b1;
                      if (is_lconfl(dreqmort[indexLSU_ALU],{dreqmort_flags[7][indexLSU_ALU],
                          dreqmort_flags[6][indexLSU_ALU],dreqmort_flags[5][indexLSU_ALU],
                          dreqmort_flags[4][indexLSU_ALU],dreqmort_flags[3][indexLSU_ALU],dreqmort_flags[2][indexLSU_ALU],
                          dreqmort_flags[1][indexLSU_ALU],dreqmort_flags[0][indexLSU_ALU]},
                          dreqmort[ldi[5:0]],{dreqmort_flags[7][ldi[5:0]],dreqmort_flags[6][ldi[5:0]],dreqmort_flags[5][ldi[5:0]],
                          dreqmort_flags[4][ldi[5:0]],dreqmort_flags[3][ldi[5:0]],dreqmort_flags[2][ldi[5:0]],dreqmort_flags[1][ldi[5:0]],dreqmort_flags[0][ldi[5:0]]}))
                          lderror[ldi[5:0]]<=1'b1;
                      if (!anyhitW_reg[fu] && opcode_reg2[6] && ldi[5:0]==indexLSU_ALU_reg3) begin
                          miss[ldi[5:0]]=1;
                          missus[res[18:11]][PHY/4]=1;
                      end
                      if (!anyhit_reg[fu] && opcode_reg2[7] && ldi[5:0]==indexLSU_ALU_reg3) begin
                          miss[ldi[5:0]]=1;
                        missus[res_reg[fu][18:11]][PHY/4]=1;
                      end
                  end
                  missrs=0;
                  for(ldi=0;ldi<64;ldi++) begin
                    if (!anyhitW_reg[fu] && opcode_reg2[6] && ldi[5:0]==indexLSU_ALU_reg3) missrs[ldi[5:0]]=missrs[ldi[5:0]]| |missus[resX_reg[fu][18:11]];
                    if (!anyhit_reg[fu] && opcode_reg2[7] && ldi[5:0]==indexLSU_ALU_reg3) missrs[ldi[5:0]]=missrs[ldi[5:0]]| |missus[res_reg[fu][18:11]];
                  end
          end
  wire [5:0] shareX;
  bit_find_index12 ex(~(ret1|mret1),retire,,);
    tileXY_cl_fifo #(tile_X,tile_Y,0) busCLH (
      clk,rst,
      XH_intf_in[tile_X], 
      XH_intf_out[tile_X],
      AXH_intf_in[tile_X], 
      AXH_intf_out[tile_X],
      ~random[0],
      expunv_data_reg, 
      expunv_addr_reg[36:0],
      {expunv_addr_reg[38:37],expunv_phy_reg},
      insetrh_expen,
      insetrh_data,
      insetrh_addr,
      {insetrh_shared,insetrh_exclusive,insetrh_phy},
      insetrh_en,
      missx_en[2:0],
      missx_addr[2:0],
      missx_phy[2:0],
      rden_in[PHY],
      rdaddr0[PHY][36:0],
      rdaddr0[PHY][38],
      rdaddr0[PHY][37],
      wren_in[PHY],
      wrdata[PHY][8*66-1:0],
      rddata[PHY][8*66-1:0],
      rden_out[PHY],
      rddata[PHY][8*66],
      rddata[PHY][8*66+1+:4],
      rdaddr[PHY],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,3) busCLV (
      clk,rst,
      XV_intf_in[tile_Y], 
      XV_intf_out[tile_Y],
      AXV_intf_in[tile_X], 
      AXV_intf_out[tile_X],
      random[0],
      expunv_data_reg, 
      expunv_addr_reg[36:0],
      {expunv_addr_reg[38:37],expunv_phy_reg},
      insetrh_expen,
      insetrh_data,
      insetrh_addr,
      {insetrh_shared,insetrh_exclusive,insetrh_phy},
      insetrh_en,
      missx_en[5:3],
      missx_addr[5:3],
      missx_phy[5:3],
      rden_in[PHY],
      rdaddr0[PHY][36:0],
      rdaddr0[PHY][38],
      rdaddr0[PHY][37],
      wren_in[PHY],
      wrdata[PHY][8*66-1:0],
      rddata[PHY][8*66-1:0],
      rden_out[PHY],
      rddata[PHY][8*66],
      rddata[PHY][8*66+1+:4],
      rdaddr[PHY],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,1) busCHH (
      clk,rst,
      XH_intf_in[tile_X], 
      XH_intf_out[tile_X],
      AXH_intf_in[tile_X], 
      AXH_intf_out[tile_X],
      ~random[0],
      expunh_data_reg, 
      expunh_addr_reg[36:0],
      {expunh_addr_reg[38:37],expunh_phy_reg},
      insetrv_expen,
      insetrv_data,
      insetrv_addr,
      {insetrv_shared,insetrv_exclusive,insetrv_phy},
      insetrv_en,
      missx_en[8:6],
      missx_addr[8:6],
      missx_phy[8:6],
      rden_in[PHY],
      rdaddr0[PHY][36:0],
      rdaddr0[PHY][38],
      rdaddr0[PHY][37],
      wren_in[PHY],
      wrdata[PHY][8*66-1:0],
      rddata[PHY][8*66-1:0],
      rden_out[PHY],
      rddata[PHY][8*66],
      rddata[PHY][8*66+1+:4],
      rdaddr[PHY],
      shareX);
    tileXY_cl_fifo #(tile_X,tile_Y,4) busCHV (
      clk,rst,
      XV_intf_in[tile_Y], 
      XV_intf_out[tile_Y],
      AXV_intf_in[tile_X], 
      AXV_intf_out[tile_X],
      random[0],
      expunh_data_reg, 
      expunh_addr_reg[36:0],
      {expunh_addr_reg[38:37],expunh_phy_reg},
      insetrv_expen,
      insetrv_data,
      insetrv_addr,
      {insetrv_shared,insetrv_exclusive,insetrv_phy},
      insetrv_en,
      missx_en[11:9],
      missx_addr[11:9],
      missx_phy[11:9],
      rden_in[PHY],
      rdaddr0[PHY][36:0],
      rdaddr0[PHY][38],
      rdaddr0[PHY][37],
      wren_in[PHY],
      wrdata[PHY][8*66-1:0],
      rddata[PHY][8*66-1:0],
      rden_out[PHY],
      rddata[PHY][8*66],
      rddata[PHY][8*66+1+:4],
      rdaddr[PHY],
      shareX);
      end
      reg [9:0][38:0] tr;
      reg [7:0][3:0] hway;
      reg [7:0][3:0] vway;
      assign insetr_en=1'b0; //tile ccNUMA within die/package cut in favour of unaligned load
      for(way=0;way<8;way=way+1) begin : cache_way
          wire [11:0][65:0] poo_e;
          wire [11:0][65:0] poo_u;
         // wire [66*8-1:0] poo_c;
          reg [64*8-1:0] poo_c_reg;
          reg [11:0][65:0] poo_e_reg;
          always @(posedge clk) begin
              poo_e_reg<=poo_e;
              poo_c_reg<=poo_c;
              poo_cp_reg<=poo_cp;
          end
        for(line=0;line<64;line=line+1) begin : cache_line
          reg [15:0][65:0] line_data;
          reg [1:0][38:0] tag;
          always @* begin
              vway[way]=0;
              hway[way]=0;
              if (insetrh_en && insetrh_addr[0][5:0]==line && tag[insetrh_addr[0][6]][37:0]=={1'b1,insetrh_addr[0][36:0]}) 
                  hway[way][0]=1;
              if (insetrh_en && insetrh_addr[1][5:0]==line && tag[insetrh_addr[1][6]][37:0]=={1'b1,insetrh_addr[1][36:0]}) 
                  hway[way][1]=1;
              if (insetrh_en && insetrh_addr[2][5:0]==line && tag[insetrh_addr[2][6]][37:0]=={1'b1,insetrh_addr[2][36:0]}) 
                  hway[way][2]=1;
              if (insetrh_en && insetrh_addr[3][5:0]==line && tag[insetrh_addr[3][6]][37:0]=={1'b1,insetrh_addr[3][36:0]}) 
                  hway[way][3]=1;
              if (insetrv_en && insetrv_addr[0][5:0]==line && tag[insetrv_addr[0][6]][37:0]=={1'b1,insetrv_addr[0][36:0]}) 
                  vway[way][0]=1;
              if (insetrv_en && insetrv_addr[1][5:0]==line && tag[insetrv_addr[1][6]][37:0]=={1'b1,insetrv_addr[1][36:0]}) 
                  vway[way][1]=1;
              if (insetrv_en && insetrv_addr[2][5:0]==line && tag[insetrv_addr[2][6]][37:0]=={1'b1,insetrv_addr[2][36:0]}) 
                  vway[way][2]=1;
              if (insetrv_en && insetrv_addr[3][5:0]==line && tag[insetrv_addr[3][6]][37:0]=={1'b1,insetrv_addr[3][36:0]}) 
                  vway[way][3]=1;
          end
            // assign poo_c2[2*fuB+:2]=poo_c[fuB*66+64+:2];
             always @(posedge clk) begin
                if (line==insetrh_addr[0][5:0] && insetrh_expen | |hway)
                  tag[insetrh_addr[0][6]][38:37]<=0;
                if (line==insetrv_addr[0][5:0] && insetrv_expen | |vway)
                  tag[insetrv_addr[0][6]][38:37]<=0;
                if (way==random[2:0] && insetrh_phy[PHY] && ~|hway || hway[way][0]) begin
                  if (line==insetrh_addr[0][5:0] && insetrh_phy[PHY] && ~insetrh_expen) begin
                      tag[insetrh_addr[0][6]]<={insetrh_exclusive,1'b1,insetrh_addr[0][36:0]};
                      expunh_data<=line_data[8*insetrh_addr[0][6]+:8];
                      expunh_addr<={tag[insetrh_addr[0][6]][38],~tag[insetrh_addr[0][6]][38],tag[insetrh_addr[0][6]][36:0]};
                      expunh_phy<=1;
                      line_data[8*insetrh_addr[0][6]+:8]<=insetrh_data;
                  end
                end
                if (way==random[2:0] && insetrv_phy[PHY] && ~|vway || vway[way][0]) begin
                  if (line==insetrv_addr[0][5:0] && insetrv_phy[PHY] && ~insetrv_expen) begin
                      tag[insetrv_addr[0][6]]<={insetrv_exclusive,1'b1,insetrv_addr[0][36:0]};
                      line_data[8*insetrv_addr[0][6]+:8]<=insetrv_data;
                      expunv_data<=line_data[8*insetrv_addr[0][6]+:8];
                      expunv_addr<={tag[insetrv_addr[0][6]][38],~tag[insetrv_addr[0][6]][38],tag[insetrv_addr[0][6]][36:0]};
                      expunv_phy<=1;
                 end
             end
             end
             for(fuB=0;fuB<12;fuB=fuB+1) begin : funit2
                wire [65:-64] poo_mask;
                reg [65:0] poo_mask_reg;
                wire [63:0] dummy64;
                wire [63:0] dummy64B;
                integer byte_;
                /* verilator lint_off WIDTHTRUNC */
                assign poo_e[fuB][63:0]={poo_u[fuB][63:0],line_data[resA_reg[fuB][6:3]][63:0]}>>(resA_reg[fuB][2:0]*8)<<(56-ldsizes[fuB][2:0]*8)>>>(56-ldsizes[fuB][2:0]*8);
                /* verilator lint_on WIDTHTRUNC */
                assign {poo_e[fuB][65:64],dummy64}=line_data[resA_reg[fuB][6:3]]>>(resA_reg[fuB][2:0]*8)<<(56-ldsizes[fuB][2:0]*8)>>>(56-ldsizes[fuB][2:0]*8);
                assign poo_u[fuB]=opcode_reg[fuB][5] ? 0 : line_data[res_reg[fuB][6:3]];
                if (fuB<8) assign poo_c[64*fuB+:64]=line_data[{IP[8],fuB[2:0]}][63:0];
                if (fuB<8) assign poo_cp[3*fuB+:3]=line_data[{IP[8],fuB[2:0]}][65:63];
                assign {poo_mask}=(130'h3ffff_ffff_ffff_ffff_00<<(ldsize_reg[fuB][2:0]*8))&{66'h3ffff_ffff_ffff_ffff,64'b0};
                assign pppoe[fuB]=anyhit[fuB][way]   ? 
                   poo_e_reg[fuB] & poo_mask_reg[65:0] : 'z;
                assign anyhitU[fuB][way]=line==res_reg2[12:7] ? tag[res_reg2[fuB][6]][37]&&tag[res_reg2[fuB][6]][36:0]=={res_reg[fuB][42:32],res_reg2[fuB][31:6]} : 1'bz;
                assign anyhit[fuB][way] =line==resA_reg2[12:7] ? tag[resA_reg2[fuB][6]][37]&&tag[resA_reg2[fuB][6]][36:0]=={resA_reg[fuB][42:32],resA_reg2[fuB][31:6]} : 1'bz;
                assign anyhitW[fuB][way]=line==resX[12:7] ? tag[resX[fuB][6]][38]&&tag[resX[fuB][6]][36:0]==resX[fuB][42:6] : 1'bz;
                assign anyhitE[fuB][way]=line==srcIPOff[reti_reg][11:6] ? tag[srcIPOff[reti_reg][5]][38]&&tag[srcIPOff[reti_reg][5]][36:0]==srcIPOff[reti_reg][41:5] : 1'bz;
                assign anyhitC[fuB][way]=line==IP_reg[12:6] ? tag[IP_reg[5]][37]&&tag[IP_reg[5]][36:0]==IP_reg[41:5] : 1'bz;
              //  if (line==4) assign tlbhit=tr_reg[resX[fuB][31:22]][37:6]==resX[fuB][63:37] && tr_reg[resX[fuB][31:22]][38];
                if (fuB<8) assign pppoc[64*fuB+:64]=anyhitC[fuB][way ]&& line==IP_reg[11:6] ? poo_c_reg[64*fuB+:64] : 'z;
                if (fuB<8) assign pppoc2[3*fuB+:3]=anyhitC[fuB][way ]&& line==IP_reg[11:6] ? poo_cp_reg[3*fuB+:3] : 'z;
              //  assign pppoc2[64*fuB+:64]=anyhitC&& line==IP_reg[11:6] ? poo_c_reg[66*fuB+64+:2] : 'z;
                always @(posedge clk) begin
                  poo_mask_reg<=poo_mask[65:0];
                  /* verilator lint_off WIDTHEXPAND */
                  if (fuB==ids0_reg || fuB==ids1_reg)
                    for (byte_=0;byte_<8;byte_=byte_+1)
                      if (anyhitW[fuB][way] && is_write_reg[fuB] && resX[fuB][12:7]==line[5:0] && byte_<write_size_reg[fuB]); 
                  line_data[resX[fuB][6:3]][8*(byte_+resX[fuB][2:0]-8*write_upper[fuB])+:8]<=resWD[fuB][8*byte_+:8];
                    if (anyhitE_reg[fuB][way] && srcIPOff[reti_reg2][12:7]==line[5:0] && dreqmort_flags[fuB][7][reti_reg2]); 
                  line_data[{srcIPOff[reti_reg2][6],3'b111}][fee_undex(fuB)]<=1'b0;
                //        if (][way] && is_write_reg[fuB] && funit[fuB].resW[2:0]==line[5:3] && byte_<write_size_reg[fuB] &&
                //            resX[fuB][63:9]=='1); 
                //            line_data[line][funit[fuB].resW[6:3]]<=funit[fuB].resW[8*funit[fuB].resW[2:0]+:8];
                /* verilator lint_on WIDTHEXPAND */
                end
             end
          end
      end
    end

    end //multicore loop
  endgenerate
endmodule
