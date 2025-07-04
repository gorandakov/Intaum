
module bit_find_index #(ALLOC=0) (
  input [63:0] sel,
  output [5:0] dout,
  output hasany
  );

  wire [7:0] tmp1;
  wire [2:0] lo;
  wire [2:0] hi;
  wire [7:0][2:0] lo0; 
  generate
    genvar a,b;
    if (ALLOC) begin : ALLOC_IN
        for(a=0;a<8;a=a+1) begin
                wire [7:0] tmp2;
                wire [7:0] dummy2;
                assign tmp1[a]=|sel[8*a+:8];
                assign {tmp2,dummy2}=255<<a;
            for(b=0;b<8;b=b+1) begin
                assign lo0[b]=tmp2==sel[8*b+:8] ? a[2:0] : 'z;
          
            end
            assign lo0[a]=sel[8*a+:8]==8'b0 ? '0 : 'z;
            assign lo=hi==a ? lo0[a] : 'z;
            assign hi=tmp2==tmp1 ? a[2:0] : 'z;
        end
    end else begin : SHEDULE_IN
        for(a=0;a<8;a=a+1) begin
                wire [7:0] tmp2;
                wire [7:0] tmp3;
                wire [7:0] dummy2;
                wire [7:0] dummy3;
                assign tmp1[a]=|sel[8*a+:8];
                assign {tmp2,dummy2}=255<<a;
                assign {dummy3,tmp3}=255*256>>a;
            for(b=0;b<8;b=b+1) begin
                assign lo0[b]=tmp2==sel[8*b+:8] ? a[2:0] : 'z;
          
            end
            assign lo0[a]=sel[8*a+:8]==8'b0 ? '0 : 'z;
            assign lo=hi==a ? lo0[a] : 'z;
            assign hi=tmp3==tmp1 ? a[2:0] : 'z;
        end
    end
  endgenerate

  assign hasany=|sel;
  assign dout={hasany ? hi : '0,lo};
endmodule
