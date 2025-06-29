`define wrreq_data 591:0
`define wrreq_XDONE 592
`define wrreq_YDONE 593
`define wrreq_TX 598:594
`define wrreq_TY 603:599
`define wrreq_sz 615:604
`define wrreq_addr 652:616
`define wrreq_snd 653
`define wrreq_size 654
`define wrreq_extra 655

`define wrAreq_data 73:0
`define wrAreq_XDONE 74
`define wrAreq_YDONE 75
`define wrAreq_TX 80:76
`define wrAreq_TY 85:81
`define wrAreq_sz 87:86
`define wrAreq_addr 120:88
`define wrAreq_snd 121
`define wrAreq_size 122
`define wrAreq_extra 123

module tileXY_cl_fifo #(tile_X,tile_Y,IDX) (
  input [1:0][`wrreq_size:0] X_intf_in, 
  output [1:0][`wrreq_size:0] X_intf_out,
  input [1:0][`wrAreq_size:0] XA_intf_in, 
  output [1:0][`wrAreq_size:0] XA_intf_out,
  input in_en,
  input [66*8-1:0] in_datum, 
  input [36:0] in_addr,
  input [11:0] insize,//{shared,exclusive,phymsk}
  output wrt_stall,
  output [66*8-1:0] reqmort_data,
  output [36:0] reqmortaddr,
  output [11:0] reqmort_size,
  input outen,
  input [2:0] missue_en,
  input [2:0][38:0] missue_addr,
  input [2:0][9:0] missue_phy,
  inout [5:0] shareX);

  wire [`wrreq_size-1:0] wrreq;

  reg [7:0][`wrreq_size-1:0] queue;
  reg [7:0] data_in;
  reg stall;
  reg [42:0] in_addr_reg;
  reg [1:0] in_size_reg;
  reg in_en_reg;

  assign shareX[IDX]=|odata_in;

  assign sharX={3'b0,shareX};

  assign outen=&shareX || |match_overflow_begin&(~(sharX[IDX+3]));

  assign wrreq[`wrreq_data]=in_datum;
  assign wrreq[`wrreq_XDONE]=IDX<2;
  assign wrreq[`wrreq_YDONE]=IDX>=2;
  assign wrreq[`wrreq_TX]=in_addr_reg[37:33];
  assign wrreq[`wrreq_TY]=in_addr_reg[42:38];
  assign wrreq[`wrreq_addr]=in_addr_reg[32:0];
  assign wrreq[`wrreq_sz]=in_size_reg;

  assign X_intf_out[0][`wrreq_size-1:0]=in_en_reg & back ? wrreq : queue[0][qposr0];
  assign X_intf_out[1][`wrreq_size-1:0]=in_en_reg & fwd ? wrreq : queue[1][qposr1];

  assign fwd=IDX<2 ? in_addr_reg[37:33]>tileX : in_addr_reg[42:38]>tileY;
  assign back=IDX<2 ? in_addr_reg[37:33]<=tileX : in_addr_reg[42:38]<=tileY;

  assign X_intf_in[0][`wrreq_extra]=|datacnt0[8:4];
  assign X_intf_in[1][`wrreq_extra]=|datacnt1[8:4];
 
  assign match[0]=IDX<3 ? X_intf_in[0][`wrreq_TX]==tileX : X_intf_in[0][wrreq_TY]==tileY;
  assign match[1]=IDX<3 ? X_intf_in[1][`wrreq_TX]==tileX : X_intf_in[1][wrreq_TY]==tileY;

  assign reqmort_data=|odata_in[0] ? oqueue[0][orpos0][`wrreq_data] : oqueue[1][orpos1][`wrreq_data];
  assign reqmortaddr=|odata_in[0] ? {tileY[4:0],tileX[4:0],oqueue[0][orpos0][`wrreq_addr]} : {tileY[4:0],tileX[4:0],oqueue[1][orpos1][`wrreq_addr]};
  assign reqmort_size=|odata_in[0] ? oqueue[0][orpos0][`wrreq_sz] : oqueue[1][orpos1][`wrreq_sz];

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
              oqueue[0][qpos0]<=X_intf_in[0];
              odata_in[qpos0]<=1'b1;
              qpos0<=qpos0+1;
          end
          if (match[1]) begin
              oqueue[1][qpos1]<=X_intf_in[1];
              odata_in[qpos1]<=1'b1;
              qpos1<=qpos1+1;
          end
          if (outen && |odata_in[0]) begin
              orpos0<=orpos0+1;
              odata_in[0][orpos0]<=1'b0;
          end else if (outen) begin
              orpos1<=orpos1+1;
              odata_in[1][orpos1]<=1'b0;
          end
          in_addr_reg<=in_addr;
          in_en_reg<=in_en;
          in_size_reg<=in_size;
      end
  end
 // assign outen=&shareX || |match_overflow_begin&(~(sharX[IDX+3]));

  assign wrAreq[`wrAreq_data]=missue0[missue_idx_first];
  assign wrAreq[`wrAreq_XDONE]=IDX<2;
  assign wrAreq[`wrAreq_YDONE]=IDX>=2;
  assign wrAreq[`wrAreq_TX]=missue0[missue_idx_first][35:31];
  assign wrAreq[`wrAreq_TY]=missue0[missue_idx_first][36:32];
 // assign wrAreq[`wrAreq_addr]=in_addr_reg[32:0];
  assign wrAreq[`wrAreq_sz]=missue0_phy[missue_idx_first];

  assign missue0[2:0]=missue;
  assign missue0_en[2:0]=missue_en;
  assign missue0[3]=Aqueue[0][Aqposr0];
  assign missue0_en[3]=Aqposr0!=Aqpos0;

  assign XA_intf_out[0][`wrAreq_size-1:0]=inA_en_reg & backA ? wrAreq : queueA[0][Aqposr0];
  assign XA_intf_out[1][`wrAreq_size-1:0]=inA_en_reg & fwdA ? wrAreq : queueA[1][Aqposr1];

  assign fwdA=IDX<2 ? inA_addr_reg[37:33]>tileX : inA_addr_reg[42:38]>tileY;
  assign backA=IDX<2 ? inA_addr_reg[37:33]<=tileX : inA_addr_reg[42:38]<=tileY;

  assign XA_intf_in[0][`wrreq_extra]=|Adatacnt0[8:4];
  assign XA_intf_in[1][`wrreq_extra]=|Adatacnt1[8:4];
 
  assign Amatch[0]=IDX<3 ? XA_intf_in[0][`wrAreq_TX]==tileX : XA_intf_in[0][`wrAreq_TY]==tileY;
  assign Amatch[1]=IDX<3 ? XA_intf_in[1][`wrAreq_TX]==tileX : XA_intf_in[1][`wrAreq_TY]==tileY;

  assign reqmort_data=|Aodata_in[0] ? Aoqueue[0][Aorpos0][`wrAreq_data] : Aoqueue[1][Aorpos1][`wrAreq_data];
  assign reqmortaddr=|Aodata_in[0] ? {tileY[4:0],tileX[4:0],Aoqueue[0][Aorpos0][`wrAreq_addr]} : {tileY[4:0],tileX[4:0],Aoqueue[1][Aorpos1][`wrAreq_addr]};
  assign reqmort_size=|Aodata_in[0] ? Aoqueue[0][Aorpos0][`wrAreq_sz] : Aoqueue[1][Aorpos1][`wrAreq_sz];

  popcnt12 pa(Adata_in[0],Adatacnt0);
  popcnt12 pb(Adata_in[1],Adatacnt1);
  
  popcnt12 pxa(Aodata_in[0],pAdatacnt0);
  popcnt12 pxb(Aodata_in[1],pAdatacnt1);

  always @(posedge clk) begin
      if (rst) begin
          Adata_in<='0;
          inA_en_reg<='0;
      end else begin
          if (in_en_reg && XA_intf_in[0][`wrAreq_snd]) begin
              Aqueue[0][Aqpos0]=XA_intf_in[0];
              Adata_in[0][Aqpos0]<=1'b1;
              Aqpos0<=Aqpos0+1;
          end
          if (inA_en_reg && XA_intf_in[1][`wrAreq_snd]) begin
              Aqueue[1][Aqpos1]=XA_intf_in[1];
              Adata_in[1][Aqpos1]<=1'b1;
              Aqpos1<=Aqpos1+1;
          end
          if (!inA_en_reg || fwdA) begin
              if (Adata_in[0]!=0 && XA_intf_out[0][`wrAreq_extra]) begin
                  Aqposr0<=Aqposr0+1;
                  Adata_in[0][Aqposr0]<=1'b0;
              end
          end
          if (!inA_en_reg || backA) begin
              if (Adata_in[1]!=0 && XA_intf_out[1][`wrAreq_extra]) begin
                  Aqposr1<=Aqposr1+1;
                  Adata_in[1][Aqposr1]<=1'b0;
              end
          end
          if (Amatch[0]) begin
              Aoqueue[0][Aqpos0]<=XA_intf_in[0];
              Aodata_in[Aqpos0]<=1'b1;
              Aqpos0<=Aqpos0+1;
          end
          if (Amatch[1]) begin
              Aoqueue[1][Aqpos1]<=XA_intf_in[1];
              Aodata_in[Aqpos1]<=1'b1;
              Aqpos1<=Aqpos1+1;
          end
          if (Aouten && |Aodata_in[0]) begin
              Aorpos0<=Aorpos0+1;
              Aodata_in[0][Aorpos0]<=1'b0;
          end else if (Aouten) begin
              Aorpos1<=Aorpos1+1;
              Aodata_in[1][Aorpos1]<=1'b0;
          end
          inA_addr_reg<=inA_addr;
          inA_en_reg<=inA_en;
          inA_size_reg<=inA_size;
      end
  end
endmodule

