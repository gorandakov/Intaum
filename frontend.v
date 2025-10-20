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
  parameter tile_X=0;
  parameter tile_Y=0;
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
      1: fsconv={34'b10,din[63:62],din[59:30]};
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
      for(k=0;k<12;k=k+1) vaff[k]=|din[k];
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
          byminus=(boogie>>7)=={43{1'b1}};
          byzero=(boogie>>7)==0;
          if (on_low) begin
            addition_check=(boogie[6:0]+val1[6:0])>=cookie[19:13]-{6'b0,!protect_cookie};
              if (cookie[12:6]>cookie[19:13] && (boogie[6:0]+val1[6:0])>cookie[12:6])
                  addition_check=0;
            if (!byone && !byzero || isand & byminus)
                addition_check=0;
          end else begin
            addition_check=(boogie[7:0]+val1[7:0])>=cookie[20:13]-{7'b0,!protect_cookie};
              if (cookie[12:6]>cookie[19:13] && (boogie[6:0]+val1[6:0])>cookie[12:6])
                  addition_check=0;
            if (!byminus && !byzero&!isand)
                addition_check=0;
          end
      end
  endfunction
generate
  wire iscall,isret;
  wire [1:0] ucjmp;
  reg [7:0] sttop;
  reg [65535:0][1:0] predA;
  reg [65535:0][1:0] predB;
  reg [65535:0][1:0] predC;
  reg [(1<<9)-1:0][41:0] htlb;

  wire [35:0] missx_en;
  wire [35:0][38:0] missx_addr;
  wire [11:0][39:0] missx_phy;

  wire except;
  wire except_ldconfl;
  wire [1:0][41:0] retIP;
  wire [41:0] retSRCIP;
  reg [41:0] retSRCIP_reg; 
  wire [31:0] random;
  `define wrreq_size 731
  `define wrAreq_size 164
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
  reg [255:0][35:0] missus;
  reg [255:0][35:0] missus_reg;
  reg [255:0][35:0] missus_reg2;
  reg [255:0][35:0] missus_reg3;
  reg [255:0][35:0] missus_reg4;
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
  wire [35:0][39:0] rdphy;
  wire [35:0][39:0] rdphy0;
  wire [41:0] irq_IP={31'b1,irqnum[3:0],7'b0};
  wire [35:0][11:0] resource_stall;
  wire [11:0] resource_stallx;
  wire memstall;
  wire [35:0] ccmiss;
  integer z;
  
  always @(posedge clk) begin
    missus_reg<=missus;
    missus_reg2<=missus_reg;
    missus_reg3<=missus_reg2;
    missus_reg4<=missus_reg3;
    retSRCIP_reg<=retSRCIP;
    resource_stallx=12'b0;
    for(z=0;z<36;z=z+1) resource_stallx=resource_stallx|resource_stall[z];
  end
  memblk #(tile_X,tile_Y) blkmem(clk,rst,memstall,random[15:0],
    rdaddr0,
    rdphy0,
    rddata,
    rden_in,
    rdaddr,
    rdphy,
    rden_out,
    rdaddr0,
    wrdata,
    wren_in,
    wraddr,
    wren_out);

      genvar fu,fuB;
      genvar way,way2;
      genvar line;
      genvar PHY;
    for(PHY=0;PHY<36;PHY=PHY+1) begin : phy
    core #(tile_X,tile_Y,PHY) one(
  clk,
  irqload,
  irqnum,
  iscall,isret,
  ucjmp,
  sttop,
  predA,
  predB,
  predC,
  htlb,

  missx_en,
  missx_addr,
  missx_phy,

  except,
  except_ldconfl,
  retIP,
  retSRCIP,
  retSRCIP_reg, 
  random,
  XH_intf_in[tile_X],
  XV_intf_in[tile_Y],
  XH_intf_out[tile_X],
  XV_intf_out[tile_Y],
    
  AXH_intf_in[tile_X],
  AXV_intf_in[tile_Y],
  AXH_intf_out[tile_X],
  AXV_intf_out[tile_Y],
  jretire, 
  jtaken, 
  jmpmispred,
  missus,
  missus_reg,
  missus_reg2,
  missus_reg3,
  missus_reg4,
  ret0,
  mret0,
  mxret0,
  wstall,
  wstall_reg,
  aligned,
  xdataA,
   rdaddr0,
   rddata,
   rden_in,
   rdaddr,
  rden_out,
   wrdata,
   wren_in,
   wraddr,
  wren_out,
  rdphy,
  rdphy0,
  irq_IP,
  resource_stall[PHY],
  resource_stallx,
  ccmiss,
  memstall
  );
    //end
  end
  endgenerate
endmodule
