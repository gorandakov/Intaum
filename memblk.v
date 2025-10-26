module memblk(
  input clk,
  input rst,
  output reg stall,
  input [15:0] random,  
  input [35:0][38:0] rdaddr0,
  input [35:0][39:0] rdphydata0,
  output reg [35:0][8*66+4:0] rddata,
  input [35:0] rden_in,
  output reg [35:0][3:0][36:0] rdaddr,
  output reg [35:0] rd_pltpage,
  output reg [35:0][39:0] rdphydata,
  output reg [35:0] rden_out,
  input [35:0][38:0] wraddr0,
  input [35:0][8*66+4:0] wrdata,
  input [35:0] wren_in,
  output reg [35:0][3:0][36:0] wraddr,
  output reg [35:0] wren_out
);
  parameter [1:0] tileX=0;
  parameter [1:0] tileY=0;

  reg [63:0][35:0][1:0] wsz0_reg;
  reg [63:0][35:0][32:0] waddr0_reg;
  reg [35:0][3:0][33:0] waddr0_xtra;
  reg [35:0][3:0][33:0] waddr0_xtra_reg;
  reg [35:0][32:0] waddr0_rexx;
  reg [35:0][32:0] waddr0_rexx2;
  reg [63:0][35:0][66*8-1:0] wrdata_reg;
  reg [63:0][35:0] wren_in_reg;
  reg [63:0][35:0][32:0] rdaddr0_reg;
  reg [63:0][35:0][39:0] rdphydata0_reg;
  reg [35:0][32:0] rdaddr0_rexx;
  reg [35:0][32:0] rdaddr0_rexx2;
  reg [35:0][3:0][33:0] rdaddr0_xtra;
  reg [35:0][3:0][33:0] rdaddr0_xtra_reg;
  reg [63:0][35:0] rden_in_reg;
  reg [63:0][35:0][32:0] rdaddr_reg;
  reg [63:0][35:0][3:0] rdxdata_reg;
  `ifndef production
  reg [1<<24-1+1<<22+1<<19:0][66*8-1:0] ram_block;
  reg [1<<24-1+1<<22+1<<19:0][4:0] ram_blockx;
  `else
  reg [1<<25-1+1<<22+1<<19:0][66*8-1:0] ram_block;
  reg [1<<25-1+1<<22+1<<19:0][4:0] ram_blockx;
  `endif
  integer wport;
  integer rdport;
  integer regcnt;
  integer tlbptr;

  wire rdnshare;
  wire [35:0][4*66-1:0] tlbdata;
  wire [35:0][4*66-1:0] tlbdataw;
  reg [35:0][4*66-1:0] tlbdata_reg;
  reg [35:0][4*66-1:0] tlbdataw_reg;
  
  
  assign rdnshare=(random&16'h1ff)==16'd5;
  generate
    genvar k;
    for(k=0;k<36;k=k+1) begin
        /* verilator lint_off WIDTHTRUNC */
        assign tlbdata[k]=ram_block[1<<25+rdaddr0_reg[44][k][25:6]]>>rdaddr0_reg[44][k][26]*4*66;
        assign tlbdataw[k]=ram_block[1<<25+waddr0_reg[44][k][25:6]]>>waddr0_reg[44][k][26]*4*66;
        /* verilator lint_on WIDTHTRUNC */
        assign {rd_pltpage[k],rdaddr[k][0]}={rdaddr0_xtra[k][0],tileX[1:0],tileY[1:0]};
        assign rdaddr[k][1]={rdaddr0_xtra[k][1],tileX[1:0],tileY[1:0]};
        assign rdaddr[k][2]={rdaddr0_xtra[k][2],tileX[1:0],tileY[1:0]};
        assign rdaddr[k][3]={rdaddr0_xtra[k][3],tileX[1:0],tileY[1:0]};
        assign wraddr[k][0]={waddr0_xtra[k][0],tileX[1:0],tileY[1:0]};
        assign wraddr[k][1]={waddr0_xtra[k][1],tileX[1:0],tileY[1:0]};
        assign wraddr[k][2]={waddr0_xtra[k][2],tileX[1:0],tileY[1:0]};
        assign wraddr[k][3]={waddr0_xtra[k][3],tileX[1:0],tileY[1:0]};
        assign rden_out[k]=rden_in_reg[47][k];
        assign rddata[k]={ram_blockx[rdaddr0_reg[47][k][24:0]],ram_block[rdaddr0_reg[47][k][24:0]]};
        assign rdphydata[k]=rdphydata0_reg[47][k];
    end
  endgenerate
  always @* begin
    stall=0;
    for(rdport=0;rdport<16;rdport=rdport+1) begin
       if (rdaddr0_reg[47]==rdaddr0_reg[48+rdport] && rden_in_reg[48+rdport][wport] && rden_in_reg[47][wport]) stall=1;
    end
  end
  always @(posedge clk) if (!stall) begin
    //     wrdata_reg[0]<=wrdata;    
    for(regcnt=1;regcnt<(48+16);regcnt=regcnt+1) begin
         waddr0_reg[regcnt]<=waddr0_reg[regcnt-1];
         wren_in_reg[regcnt]<=wren_in_reg[regcnt-1];
         wrdata_reg[regcnt]<=wrdata_reg[regcnt-1];
         rdaddr0_reg[regcnt]<=rdaddr0_reg[regcnt-1];
         rdphydata0_reg[regcnt]<=rdphydata0_reg[regcnt-1];
         rden_in_reg[regcnt]<=rden_in_reg[regcnt-1];
         rdxdata_reg[regcnt]<=rdxdata_reg[regcnt-1];
    end
    for(wport=0;wport<36;wport=wport+1) begin
          rdaddr0_reg[0][wport]<=rdaddr0[wport][36:4];
          rdphydata0_reg[0][wport]<=rdphydata0[wport];
          waddr0_reg[0][wport]<=wraddr0[wport][36:4];
          rdxdata_reg[0][wport]<=rdaddr0[wport][3:0];
          wren_in_reg[0][wport]<=wren_in[wport]|rden_in[wport]&rdaddr0[wport][37];
          rden_in_reg[0][wport]<=rden_in[wport];
          wrdata_reg[0][wport]<=wrdata[wport][8*66-1:0];
          if (rden_in_reg[47][wport] && ram_blockx[rdaddr0_reg[47][wport][24:0]][0]||wren_in_reg[47][wport]) ram_blockx[rdaddr0_reg[47][wport][24:0]]<=
             {rdxdata_reg[47][wport],wren_in_reg[47][wport]||ram_blockx[rdaddr0_reg[47][wport][24:0]][0]&~rdnshare};

          if (wren_in_reg[47][wport] && !rden_in_reg[47][wport]) ram_block[waddr0_reg[47][wport][24:0]]<=wrdata_reg[47][wport][8*66-1:0];
          
          for(tlbptr=0;tlbptr<4;tlbptr=tlbptr+1) begin
              if (tlbdata[wport][66*tlbptr+:17]=={1'b1,rdaddr0_reg[44][wport][32:17]} && rden_in_reg[44][wport]) begin
                  rdaddr0_reg[45][wport]<={tlbdata[wport][66*tlbptr+16+:16],rdaddr0_reg[44][wport][16:0]};
              end
              if (tlbdata_reg[wport][66*tlbptr+17+:16]=={rdaddr0_reg[45][wport][32:17]} && rden_in_reg[45][wport] && tlbdata_reg[wport][66*tlbptr+16]) begin
                rdaddr0_xtra[wport][tlbptr]<={tlbdata_reg[wport][66*tlbptr+63],tlbdata_reg[wport][66*tlbptr+:16],rdaddr0_reg[45][wport][16:0]};
              end
              if (rdaddr0_xtra[wport][tlbptr]==rdaddr0_rexx2[wport]) begin
                  rdaddr0_xtra_reg[wport][0]<=rdaddr0_xtra[wport][tlbptr];
                  rdaddr0_xtra_reg[wport][tlbptr]<=rdaddr0_reg[46][wport];
              end
              if (tlbdataw[wport][66*tlbptr+:17]=={1'b1,waddr0_reg[44][wport][32:17]} && wren_in_reg[44][wport]) begin
                  waddr0_reg[45][wport]<={tlbdataw[wport][66*tlbptr+16+:16],waddr0_reg[44][wport][16:0]};
              end
              if (tlbdataw_reg[wport][66*tlbptr+17+:16]=={waddr0_reg[45][wport][32:17]} && wren_in_reg[45][wport] && tlbdataw_reg[wport][66*tlbptr+16]) begin
                waddr0_xtra[wport][tlbptr]<={tlbdataw_reg[wport][66*tlbptr+63],tlbdataw_reg[wport][66*tlbptr+:16],waddr0_reg[45][wport][16:0]};
              end
              if (waddr0_xtra[wport][tlbptr]==waddr0_rexx2[wport]) begin
                  waddr0_xtra_reg[wport][0]<=waddr0_xtra[wport][tlbptr];
                  waddr0_xtra_reg[wport][tlbptr]<=waddr0_reg[46][wport];
              end
              waddr0_rexx[wport]<=waddr0_reg[45][wport];
              waddr0_rexx2[wport]<=waddr0_rexx[wport];
              rdaddr0_rexx[wport]<=rdaddr0_reg[45][wport];
              rdaddr0_rexx2[wport]<=rdaddr0_rexx[wport];
              tlbdata_reg<=tlbdata;
              tlbdataw_reg<=tlbdataw;
          end 
    end
        
  end
  
endmodule
