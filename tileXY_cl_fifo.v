`define wrreq_data 591:0
`define wrreq_XDONE 592
`define wrreq_YDONE 593
`define wrreq_TX 598:594
`define wrreq_TY 603:599
`define wrreq_sz 643:604
`define wrreq_addr 680:644
`define wrreq_snd 681
`define wrreq_expun 682
`define wrreq_size 683
`define wrreq_extra 683

`define wrAreq_data 73:0
`define wrAreq_XDONE 74
`define wrAreq_YDONE 75
`define wrAreq_TX 80:76
`define wrAreq_TY 85:81
`define wrAreq_sz 123:86
`define wrAreq_addr 160:124
`define wrAreq_snd 161
`define wrAreq_size 162
`define wrAreq_extra 162

module tileXY_cl_fifo #(tile_X,tile_Y,IDX) (
  input clk,
  input rst,
  input [1:0][`wrreq_size:0] X_intf_in, 
  output [1:0][`wrreq_size:0] X_intf_out,
  input [1:0][`wrAreq_size:0] XA_intf_in, 
  output [1:0][`wrAreq_size:0] XA_intf_out,
  input in_en,
  input [66*8-1:0] in_datum, 
  input [36:0] in_addr,
  input [41:0] insize,//{shared,exclusive,phymsk}
  output reqmort_expun,
  output [66*8-1:0] reqmort_data,
  output [3:0][36:0] reqmortaddr,
  output [41:0] reqmort_size,
//  output reqmort_flush_only,
  output outen,
  input [2:0] missue_en,
  input [2:0][38:0] missue_addr,
  input [2:0][39:0] missue_phy,
  output fiq_en,
  output [36:0] fiq_addr,
  output fiq_want_shared,
  output fiq_want_exclusive,
  output fiq_wb,
  input [8*66-1:0] fiq_data,
  output [8*66-1:0] fiq_data_out,
  input  fiq_en_in,
  input fiq_fwd,
  input [3:0] fiq_fwd_XY,
  input [3:0][36:0] fiq_addr_fwd,
  inout [5:0] shareX);

  wire [`wrreq_size-1:0] wrreq;

  reg [7:0][`wrreq_size-1:0] queue;
  reg [7:0][`wrreq_size-1:0] oqueue;
  reg [7:0] data_in;
  reg [7:0] odata_in;
  reg stall;
  reg [42:0] in_addr_reg;
  reg [1:0] in_size_reg;
  reg in_en_reg;
  integer qrpos0,qrpos1,qrposr0,qrposr1;
  integer qpos0,qpos1,qposr0,qposr1;
  wire [8:0] sharX;
  wire fwd,back;
  wire [8:0] pdatacnt0;
  wire [8:0] pdatacnt1;
  wire [8:0] datacnt0;
  wire [8:0] datacnt1;
  wire [1:0] match;

  wire [1:0][`wrreq_size-1:0] XA_intf_in_chg;

  wire [`wrreq_size-1:0] wrAreq;

  reg [7:0][38:0] Aqueue;
 // reg [7:0][`wrAreq_size-1:0] Aoqueue;
  reg [7:0] Adata_in;
  reg [7:0] Aodata_in;
  reg Astall;
  reg [42:0] inA_addr_reg;
  reg [1:0] inA_size_reg;
  reg inA_en_reg;
  integer Aqrpos0,Aqrpos1,Aqrposr0,Aqrposr1;
  integer Aqpos0,Aqpos1,Aqposr0,Aqposr1;
  wire fwdA,backA;
  wire [8:0] Apdatacnt0;
  wire [8:0] Apdatacnt1;
  wire [8:0] Adatacnt0;
  wire [8:0] Adatacnt1;
  wire [1:0] amatch;

  assign shareX[IDX]=|odata_in;

  assign sharX={3'b0,shareX};

  assign outen=&shareX || (|pdatacnt0[7:4] || |pdatacnt1[7:4])&(~(sharX[IDX+3]));

  assign wrreq[`wrreq_data]=in_datum;
  assign wrreq[`wrreq_XDONE]=IDX<2;
  assign wrreq[`wrreq_YDONE]=IDX>=2;
  assign wrreq[`wrreq_TX]=in_addr_reg[1:0];
  assign wrreq[`wrreq_TY]=in_addr_reg[3:2];
  assign wrreq[`wrreq_addr]=in_addr_reg[36:0];
  assign wrreq[`wrreq_sz]=in_size_reg;
  assign wrreq[`wrreq_expun]=1'b0;

  assign XA_intf_in_chg[0][`wrreq_addr]=XA_intf_in[0][`wrAreq_addr];
  assign XA_intf_in_chg[0][`wrreq_sz]={2'b11,XA_intf_in[0][`wrAreq_sz]};
  assign XA_intf_in_chg[1][`wrreq_addr]=XA_intf_in[1][`wrAreq_addr];
  assign XA_intf_in_chg[1][`wrreq_sz]={2'b11,XA_intf_in[1][`wrAreq_sz]};

  assign X_intf_out[0][`wrreq_size-1:0]=in_en_reg & back ? wrreq : queue[0][qposr0];
  assign X_intf_out[1][`wrreq_size-1:0]=in_en_reg & fwd ? wrreq : queue[1][qposr1];

  assign fwd=IDX<2 ? in_addr_reg[1:0]>tile_X : in_addr_reg[3:2]>tile_Y;
  assign back=IDX<2 ? in_addr_reg[1:0]<=tile_X : in_addr_reg[3:2]<=tile_Y;

  assign X_intf_out[0][`wrreq_extra]=|datacnt0[8:4];
  assign X_intf_out[1][`wrreq_extra]=|datacnt1[8:4];
 
  assign match[0]=IDX<3 ? X_intf_in[0][`wrreq_TX]==tile_X : X_intf_in[0][`wrreq_TY]==tile_Y;
  assign match[1]=IDX<3 ? X_intf_in[1][`wrreq_TX]==tile_X : X_intf_in[1][`wrreq_TY]==tile_Y;

  assign reqmort_data=|odata_in[0] ? oqueue[0][qrpos0][`wrreq_data] : oqueue[1][qrpos1][`wrreq_data];
  assign reqmortaddr=|odata_in[0] ? {tile_Y[4:0],tile_X[4:0],oqueue[0][qrpos0][`wrreq_addr]} : {tile_Y[4:0],tile_X[4:0],oqueue[1][qrpos1][`wrreq_addr]};
  assign reqmort_size=|odata_in[0] ? oqueue[0][qrpos0][`wrreq_sz] : oqueue[1][qrpos1][`wrreq_sz];
  assign reqmort_expun=|odata_in[0] ? oqueue[0][qrpos0][`wrreq_expun] : oqueue[1][qrpos1][`wrreq_expun];

  popcnt12 pa(data_in[0],datacnt0);
  popcnt12 pb(data_in[1],datacnt1);
  
  popcnt12 pxa(odata_in[0],pdatacnt0);
  popcnt12 pxb(odata_in[1],pdatacnt1);

  always @(posedge clk) begin
      if (rst) begin
          data_in<='0;
          in_en_reg<='0;
      end else begin
          if (in_en_reg && X_intf_in[0][`wrreq_snd]) begin
              queue[0][qpos0]=X_intf_in[0];
              data_in[0][qpos0]<=1'b1;
              qpos0<=qpos0+1;
          end
          if (in_en_reg && X_intf_in[1][`wrreq_snd]) begin
              queue[1][qpos1]=X_intf_in[1];
              data_in[1][qpos1]<=1'b1;
              qpos1<=qpos1+1;
          end
          if (!in_en_reg || fwd) begin
              if (data_in[0]!=0 && X_intf_out[0][`wrreq_extra]) begin
                  qposr0<=qposr0+1;
                  data_in[0][qposr0]<=1'b0;
              end
          end
          if (!in_en_reg || back) begin
              if (data_in[1]!=0 && X_intf_out[1][`wrreq_extra]) begin
                  qposr1<=qposr1+1;
                  data_in[1][qposr1]<=1'b0;
              end
          end
          if (match[0]) begin
              oqueue[0][qpos0]=X_intf_in[0];
              odata_in[qpos0]=1'b1;
              qpos0=qpos0+1;
          end
          if (match[1]) begin
              oqueue[1][qpos1]=X_intf_in[1];
              odata_in[qpos1]=1'b1;
              qpos1=qpos1+1;
          end
          if (amatch[0]) begin
              oqueue[0][qpos0]=XA_intf_in_chg[0];
              odata_in[qpos0]=1'b1;
              qpos0=qpos0+1;
          end
          if (amatch[1]) begin
              oqueue[1][qpos1]=XA_intf_in_chg[1];
              odata_in[qpos1]=1'b1;
              qpos1=qpos1+1;
          end
          if (outen && |odata_in[0]) begin
              qrpos0<=qrpos0+1;
              odata_in[0][qrpos0]<=1'b0;
          end else if (outen) begin
              qrpos1<=qrpos1+1;
              odata_in[1][qrpos1]<=1'b0;
          end
          in_addr_reg<=in_addr;
          in_en_reg<=in_en;
          in_size_reg<=insize;
      end
  end
 // assign outen=&shareX || |match_overflow_begin&(~(sharX[IDX+3]));
  wire [5:0][38:0] missue0;
  wire [5:0] missue0_en;
  wire [5:0][35:0] missue0_phy;
  wire [1:0] missue_idx_first;
  wire [1:0][38:0] mqueue;
  wire [1:0] mqueue_en;
  wire [1:0][35:0] mqueue_phy;

  assign wrAreq[`wrAreq_data]=missue0[missue_idx_first];
  assign wrAreq[`wrAreq_XDONE]=IDX<2;
  assign wrAreq[`wrAreq_YDONE]=IDX>=2;
  assign wrAreq[`wrAreq_TX]=~|missue0[36:4] ? tile_X[1:0] : missue0[missue_idx_first][1:0];
  assign wrAreq[`wrAreq_TY]=~|missue0[36:4] ? tile_Y[1:0] : missue0[missue_idx_first][3:2];
 // assign wrAreq[`wrAreq_addr]=in_addr_reg[32:0];
  assign wrAreq[`wrAreq_sz]=missue0_phy[missue_idx_first];

  assign missue0[2:0]=missue_addr;
  assign missue0_phy[2:0]=missue_phy;
  assign missue0_en[2:0]=missue_en;
  assign {missue0[3],missue0_phy[3]}=Aqueue[0][Aqposr0];
  assign missue0_en[3]=Aqposr0!=Aqpos0;
  assign missue_idx_first=missue_en[0] ? 0 : 'z;
  assign missue_idx_first=missue_en[1:0]==2'b10 ? 1 : 'z;
  assign missue_idx_first=missue_en[2:0]==3'b100 ? 2 : 'z;
  assign missue_idx_first=missue_en[2:0]==3'b0 ? 3 : 'z;

  assign mqueue[0]=missue0[missue_idx_first+1];
  assign mqueue[1]=missue0[missue_idx_first+2];
  assign mqueue_en[0]=missue0_en[missue_idx_first+1] && missue_idx_first<2;
  assign mqueue_en[1]=missue0_en[missue_idx_first+2] && missue_idx_first<1;
  assign mqueue_phy[0]=missue0_phy[missue_idx_first+1];
  assign mqueue_phy[1]=missue0_phy[missue_idx_first+2];
  
  assign XA_intf_out[0][`wrAreq_size-1:0]=inA_en_reg & backA ? wrAreq : Aqueue[0][Aqposr0];
  assign XA_intf_out[1][`wrAreq_size-1:0]=inA_en_reg & fwdA ? wrAreq : Aqueue[1][Aqposr1];

  assign fwdA=IDX<2 ? inA_addr_reg[1:0]>tile_X : inA_addr_reg[3:2]>tile_Y;
  assign backA=IDX<2 ? inA_addr_reg[1:0]<=tile_X : inA_addr_reg[3:2]<=tile_Y;

  assign XA_intf_out[0][`wrreq_extra]=|Adatacnt0[8:4];
  assign XA_intf_out[1][`wrreq_extra]=|Adatacnt1[8:4];
 
  assign amatch[0]=IDX<3 ? XA_intf_in[0][`wrAreq_TX]==tile_X : XA_intf_in[0][`wrAreq_TY]==tile_Y;
  assign amatch[1]=IDX<3 ? XA_intf_in[1][`wrAreq_TX]==tile_X : XA_intf_in[1][`wrAreq_TY]==tile_Y;

  //assign reqmort_data=|Aodata_in[0] ? Aoqueue[0][Aqrpos0][`wrAreq_data] : Aoqueue[1][Aqrpos1][`wrAreq_data];
  //assign reqmortaddr=|Aodata_in[0] ? {tile_Y[4:0],tile_X[4:0],Aoqueue[0][Aqrpos0][`wrAreq_addr]} : {tile_Y[4:0],tile_X[4:0],Aoqueue[1][Aqrpos1][`wrAreq_addr]};
  //assign reqmort_size=|Aodata_in[0] ? Aoqueue[0][Aqrpos0][`wrAreq_sz] : Aoqueue[1][Aqrpos1][`wrAreq_sz];

  popcnt12 a_pa(Adata_in[0],Adatacnt0);
  popcnt12 a_pb(Adata_in[1],Adatacnt1);
  
  popcnt12 a_pxa(Aodata_in[0],Apdatacnt0);
  popcnt12 a_pxb(Aodata_in[1],Apdatacnt1);

  always @(posedge clk) begin
      if (rst) begin
          Adata_in<='0;
          inA_en_reg<='0;
      end else begin
          if (mqueue_en[0]) begin
              Aqueue[Aqpos0]=mqueue[0];
              Adata_in[Aqpos0]=1'b1;
              Aqpos0=Aqpos0+1;
          end
          if (mqueue_en[1]) begin
              Aqueue[Aqpos1]=mqueue[1];
              Adata_in[Aqpos1]=1'b1;
              Aqpos1=Aqpos1+1;
          end
          if (fwdA) begin
            if (!mqueue_en[0] && XA_intf_out[0][`wrAreq_extra]) begin
                  Aqposr0=Aqposr0+1;
                  Adata_in[Aqposr0]<=1'b0;
              end
          end
          if (backA) begin
              if (!mqueue_en[0] && XA_intf_out[1][`wrAreq_extra]) begin
                  Aqposr1=Aqposr1+1;
                  Adata_in[Aqposr1]=1'b0;
              end
          end
/*          if (amatch[0]) begin
              Aoqueue[0][Aqpos0]<=XA_intf_in[0];
              Aodata_in[Aqpos0]<=1'b1;
              Aqpos0<=Aqpos0+1;
          end
          if (amatch[1]) begin
              Aoqueue[1][Aqpos1]<=XA_intf_in[1];
              Aodata_in[Aqpos1]<=1'b1;
              Aqpos1<=Aqpos1+1;
          end
          if (Aouten && |Aodata_in[0]) begin
              Aqrpos0<=Aqrpos0+1;
              Aodata_in[0][Aqrpos0]<=1'b0;
          end else if (Aouten) begin
              Aqrpos1<=Aqrpos1+1;
              Aodata_in[1][Aqrpos1]<=1'b0;
          end
          //inA_addr_reg<=inA_addr;
          //inA_en_reg<=inA_en;
          //inA_size_reg<=inA_size;*/
      end
  end
endmodule

