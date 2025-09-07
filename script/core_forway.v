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
                assign poo_u[fuB]=xopcode_reg[fuB][5] ? 0 : line_data[res_reg[fuB][6:3]];
                if (fuB<8) assign poo_c[64*fuB+:64]=line_data[{IP[8],fuB[2:0]}][63:0];
                if (fuB<8) assign poo_cp[3*fuB+:3]=line_data[{IP[8],fuB[2:0]}][65:63];
                assign {poo_mask}=(130'h3ffff_ffff_ffff_ffff_00<<(ldsize_reg[fuB][2:0]*8))&{66'h3ffff_ffff_ffff_ffff,64'b0};
                assign pppoe[fuB]=anyhit[fuB][way]   ? 
                   poo_e_reg[fuB] & poo_mask_reg[65:0] : 'z;
                assign anyhitU[fuB][way]=line==res_reg2[fuB][12:7] ? tag[res_reg2[fuB][6]][37]&&tag[res_reg2[fuB][6]][36:0]=={res_reg[fuB][42:32],res_reg2[fuB][31:6]} : 1'bz;
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
                    if (anyhitE_reg[fuB][way] && srcIPOff[reti_reg2][12:7]==line[5:0] && xdreqmort_flags[fuB][7][reti_reg2]); 
                  line_data[{srcIPOff[reti_reg2][6],3'b111}][fee_undex(fuB)]<=1'b0;
                //        if (][way] && is_write_reg[fuB] && funit[fuB].resW[2:0]==line[5:3] && byte_<write_size_reg[fuB] &&
                //            resX[fuB][63:9]=='1); 
                //            line_data[line][funit[fuB].resW[6:3]]<=funit[fuB].resW[8*funit[fuB].resW[2:0]+:8];
                /* verilator lint_on WIDTHEXPAND */
                end
             end
          end
      end
  endgenerate
endmodule
