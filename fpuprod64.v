module fpuprod64(
  input clk,
  input rst,
  input [63:0] A,
  input [63:0] B,
  input rnd,
  input pookg,
  output [63:0] res
);
  localparam [9:0] bias=10'h200;

  wire [107:0] prodA;
  wire [107:0] prodB;
  reg [107:0] prodA_reg;
  reg [107:0] prodB_reg;
  reg [107:0] prodA_reg2;
  reg [107:0] prodB_reg2;
  wire c;
  wire [9:0] ae;
  reg c_reg,c_reg2;
  reg [9:0] ae_reg;
  reg [9:0] ae_reg2;
  reg [63:63] A_reg;
  reg [63:63] A_reg2;
  reg [63:63] B_reg;
  reg [63:63] B_reg2;
  reg pookg_reg;
  reg pookg_reg2;

  always @(posedge clk) begin
    prodA_reg<=prodA;
    prodA_reg2<=prodA_reg;
    prodB_reg<=prodB;
    prodB_reg2<=prodB_reg;
    c_reg<=c;
    c_reg2<=c_reg;
    ae_reg<=ae;
    ae_reg2<=ae_reg;
    A_reg<=A[63];
    A_reg2<=A_reg;
    B_reg<=B[63];
    B_reg2<=B_reg;
    pookg_reg<=pookg;
    pookg_reg2<=pookg_reg;
  end


assign prodA={1'b1,A[52:0]}*{1'b1,B[52:0]}+{107'b0,rnd}<<53;

assign prodB={1'b1,A[52:0]}*{1'b1,B[52:0]}+{107'b0,rnd}<<52;

assign res[52:0]=prodA_reg2[107] | prodB_reg2[107] && ~pookg_reg2 ? prodA_reg2[106:54] : 53'bz;
assign res[52:0]=~(prodA_reg2[107] | prodB_reg2[107]) && ~pookg_reg2 ? prodB_reg2[105:53] : 53'bz;
assign res[52:0]=prodA_reg2[107] | prodB_reg2[107] && pookg_reg2 ? prodA_reg2[53:1] : 53'bz;
assign res[52:0]=~(prodA_reg2[107] | prodB_reg2[107]) && pookg_reg2 ? prodB_reg2[52:0] : 53'bz;
assign {c,ae}=A[62:53]+B[62:53]-bias;
assign res[62:53]=~pookg ? ae_reg2|{10{c_reg2}} : 10'bz;
assign res[63]=A_reg2[63]^B_reg2[63];
assign res[62:53]=pookg ? (ae_reg2-10'd53)|{10{c_reg2}} :  10'bz;
endmodule

