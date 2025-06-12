module memblk(
  input clk,
  input rst,
  input [39:0][1:0] wsz0,
  input [39:0][32:0] waddr0,
  input [39:0][65:0] wdata0,
  input [39:0] wen0,
  input [4:0][26:0] rdaddr0,
  output reg [4:0][8*66-1:0] rddata,
  input [4:0] rden_in,
  output reg [4:0][26:0] rdaddr,
  output reg [4:0] rden_out
);
  reg [10:0] [39:0][1:0] wsz0_reg;
  reg [10:0] [39:0][32:0] waddr0_reg;
  reg [10:0] [39:0][65:0] wdata0_reg;
  reg [10:0] [39:0] wen0;
  reg [10:0][4:0][26:0] rdaddr0_reg;
  reg [10:0] [4:0] rden_in_reg;
  reg [10:0] [4:0][26:0] rdaddr_reg;
  reg [1<<30-1][66:0] ram_block;
  integer wport;
  integer rdport;
  integer regcnt;
  always @(posedge clk) begin
    for(wport=0;wport<40;wport++) begin
             for(regcnt=0;regcnt<11;regcnt++) begin
end
             for(byte=0;byte<8;byte++)
             if (waddr[wport][2:0]<=byte && waddr[wport][2:0]+(1<<wsz[wport])>=byte) ram_block[waddr[wport][32:3]][byte*8+:8]=
wdata[wport][(byte-waddr[wport][2:0])*8+:8];
            if (wsz[wport]==3 && waddr[wport][2:0]==0) ram_block[waddr[wport][32:3]][65:64]=wdata[65:64];
if ($random&511==5) ram_block[waddr[wport][32:3]][66]=1'b1;
//bit 66==shared
    end
    for(rdport=0;rdport<5;rdport++) begin
              for(regcnt=0;regcnt<11;regcnt++) begin
end
rddata[rdport]<=ram_block[rdaddr[rdport]*8+:8];
    end
        
  end
