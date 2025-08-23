module memblk(
  input clk,
  input rst,
  output reg stall,
  input [15:0] random,  
  input [35:0][36:0] rdaddr0,
  input [35:0][3:0] rdxdata,
  output reg [35:0][8*66+4:0] rddata,
  input [35:0] rden_in,
  output reg [35:0][3:0][36:0] rdaddr,
  output reg [35:0] rden_out,
  input [35:0][36:0] wraddr0,
  input [35:0][8*66+4:0] wrdata,
  input [35:0] wren_in,
  output reg [35:0][3:0][36:0] wraddr,
  output reg [35:0] wren_out
);
  reg [63:0][35:0][1:0] wsz0_reg;
  reg [63:0][35:0][32:0] waddr0_reg;
  reg [35:0][32:0] waddr0_xtra;
  reg [35:0][32:0] waddr0_xtra_reg;
  reg [35:0][32:0] waddr0_rexx;
  reg [35:0][32:0] waddr0_rexx2;
  reg [63:0][35:0][65:0] wrdata_reg;
  reg [63:0][35:0] wren_in_reg;
  reg [63:0][35:0][26:0] rdaddr0_reg;
  reg [35:0][26:0] rdaddr0_rexx;
  reg [35:0][26:0] rdaddr0_rexx2;
  reg [35:0][26:0] rdaddr0_xtra;
  reg [35:0][26:0] rdaddr0_xtra_reg;
  reg [63:0][35:0] rden_in_reg;
  reg [63:0][35:0][26:0] rdaddr_reg;
  reg [63:0][35:0][3:0] rdxdata_reg;
  `ifndef production
  reg [1<<24-1+1<<22+1<<19:0][66*8+4:0] ram_block;
  `else
  reg [1<<25-1+1<<22+1<<19:0][66*8+4:0] ram_block;
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
  
  
  assign rdnshare=random&16'h1ff==16'd5;
  generate
    genvar k;
    for(k=0;k<36;k=k+1) begin
        assign tlbdata[k]=ram_block[1<<25+rdaddr0_reg[k][44][25:6]]>>rdaddr0_reg[k][44][26]*4*66;
        assign tlbdataw[k]=ram_block[1<<25+waddr0_reg[k][44][25:6]]>>waddr0_reg[k][44][26]*4*66;
        assign rdaddr[k]=rdaddr0_xtra[k];
        assign wraddr[k]=waddr0_xtra[k];
        assign rden_out[k]=rden_in_reg[k][47];
        assign rddata[k]=ram_block[rdaddr0_reg[k][47]];
    end
  endgenerate
  always @* begin
    stall=0;
    for(rdport=0;rdport<16;rdport=rdport+1) begin
       if (rdaddr0_reg[47]==rdaddr0_reg[48+rdport] && rden_in_reg[48+rdport] && rden_in_reg[47]) stall=1;
    end
  end
  always @(posedge clk) if (!stall) begin
    waddr0_reg[0]<=wraddr0;
    wren_in_reg[0]<=wren_in;
    wrdata_reg[0]<=wrdata;
    rdaddr0_reg[0]<=rdaddr0;
    rden_in_reg[0]<=rden_in;
    rdxdata_reg[0]<=rdxdata;
    //     wrdata_reg[0]<=wrdata;    
    for(regcnt=1;regcnt<(48+16);regcnt++) begin
         waddr0_reg[regcnt]<=waddr0_reg[regcnt-1];
         wren_in_reg[regcnt]<=wren_in_reg[regcnt-1];
         wrdata_reg[regcnt]<=wrdata_reg[regcnt-1];
         rdaddr0_reg[regcnt]<=rdaddr0_reg[regcnt-1];
         rden_in_reg[regcnt]<=rden_in_reg[regcnt-1];
         rdxdata_reg[regcnt]<=rdxdata_reg[regcnt-1];
    end
    for(wport=0;wport<36;wport++) begin
          if (rden_in_reg[47][wport] && ram_block[rdaddr0_reg[47][wport]][8*66]||wren_in_reg[47]) ram_block[rdaddr0_reg[47][wport]][8*66+4:8*66]<={rdxdata_reg[47][wport],wren_in_reg[47]||ram_block[rdaddr0_reg[47][wport]][8*66]&~rdnshare};

          if (wren_in_reg[47][wport] && !rden_in_reg[47]) ram_block[waddr0_reg[47][wport]][8*66-1:0]<=wrdata_reg[47][wport][8*66-1:0];
          
          for(tlbptr=0;tlbptr<4;tlbptr=tlbptr+1) begin
              if (tlbdata[wport][66*tlbptr+:16]=={1'b1,rdaddr0_reg[wport][44][36:23]} && rden_in_reg[wport][44]) begin
                  rdaddr0_reg[wport][44]<={tlbdata[wport][66*tlbptr+16+:17],rdaddr0_reg[wport][44][19:0]};
              end
              if (tlbdata_reg[wport][66*tlbptr+16:17]=={1'b1,rdaddr0_reg[wport][45][36:20]} && rden_in_reg[wport][45] && tlbdata_reg[wport][66*tlbptr+16]) begin
                  rdaddr0_xtra[wport][tlbptr]<={tlbdata_reg[wport][66*tlbptr+16+:17],rdaddr0_reg[wport][45][17:0]};
              end
              if (rdaddr0_xtra[tlbdata]==rdaddr0_rexx2[wport]) begin
                  rdaddr0_xtra_reg[wport][0]<=rdaddr0_xtra[wport][tlbdata];
                  rdaddr0_xtra_reg[wport][tlbdata]<=rdaddr0_reg[wport][46];
              end
              if (tlbdataw[wport][66*tlbptr+:16]=={1'b1,waddr0_reg[wport][44][36:23]} && wren_in_reg[wport][44]) begin
                  waddr0_reg[wport][44]<={tlbdataw[wport][66*tlbptr+16+:17],waddr0_reg[wport][44][19:0]};
              end
              if (tlbdataw_reg[wport][66*tlbptr+16:17]=={1'b1,waddr0_reg[wport][45][36:20]} && wren_in_reg[wport][45] && tlbdataw_reg[wport][66*tlbptr+16]) begin
                  waddr0_xtra[wport][tlbptr]<={tlbdataw_reg[wport][66*tlbptr+16+:17],waddr0_reg[wport][45][17:0]};
              end
              if (waddr0_xtra[wport][tlbdata]==waddr0_rexx2[wport]) begin
                  waddr0_xtra_reg[wport][0]<=waddr0_xtra[wport][tlbdata];
                  waddr0_xtra_reg[wport][tlbdata]<=waddr0_reg[wport][46];
              end
              waddr0_rexx[wport]<=waddr0_reg[wport][45];
              waddr0_rexx2[wport]<=waddr0_rexx[wport];
              rdaddr0_rexx[wport]<=rdaddr0_reg[wport][45];
              rdaddr0_rexx2[wport]<=rdaddr0_rexx[wport];
              tlbdata_reg<=tlbdata;
              tlbdataw_reg<=tlbdataw;
          end 
    end
        
  end
  
endmodule
