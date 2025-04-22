module pmp_registers (
    input logic clock ,reset,wr_en,
    input logic [1:0]prive_mode,
    input logic [31:0]wdata,rw_addr,
    output logic [31:0]rdata,
    pmpaddr0_data,pmpaddr1_data1,pmpaddr2_data,pmpaddr3_data,pmpaddr4_data,pmpaddr5_data,pmpaddr6_data,pmpaddr7_data,
    pmpaddr8_data,pmpaddr9_data,pmpaddr10_data,pmpaddr11_data,pmpaddr12_data,pmpaddr13_data14,pmpaddr_data,pmpaddr15_data,
    output logic [31:0] pmpcfg0_data, pmpcfg1_data, pmpcfg2_data, pmpcfg3_data
);

     
    logic [31:0]pmpaddr0,pmpaddr1,pmpaddr2,pmpaddr3,pmpaddr4,pmpaddr5,pmpaddr6,pmpaddr7,
    pmpaddr8,pmpaddr9,pmpaddr10,pmpaddr11,pmpaddr12,pmpaddr13,pmpaddr14,pmpaddr15;

    logic [31:0] pmpcfg0, pmpcfg1, pmpcfg2, pmpcfg3;
    always_ff @( negedge clock ) begin
        if (reset)begin
            pmpcfg0<=32'b0;
            pmpcfg1<=32'b0;
            pmpcfg2<=32'b0;
            pmpcfg3<=32'b0;

            pmpaddr0<=32'b0;
            pmpaddr1<=32'b0;
            pmpaddr2<=32'b0;
            pmpaddr3<=32'b0;
            pmpaddr4<=32'b0;
            pmpaddr5<=32'b0;
            pmpaddr6<=32'b0;
            pmpaddr7<=32'b0;
            pmpaddr8<=32'b0;
            pmpaddr9<=32'b0;
            pmpaddr10<=32'b0;
            pmpaddr11<=32'b0;
            pmpaddr12<=32'b0;
            pmpaddr13<=32'b0;
            pmpaddr14<=32'b0;
            pmpaddr15<=32'b0;

        end
        else if (wr_en && (prive_mode==2'b0)) begin
            case (rw_addr)
                CSR_PMPCFG0:
                    if (~(pmpcfg0[7]  || pmpcfg0[15] || pmpcfg0[23] || pmpcfg0[31]))
                        pmpcfg0 <= data;
            
                CSR_PMPCFG1:
                    if (~(pmpcfg1[7]  || pmpcfg1[15] || pmpcfg1[23] || pmpcfg1[31]))
                        pmpcfg1 <= data;
            
                CSR_PMPCFG2:
                    if (~(pmpcfg2[7]  || pmpcfg2[15] || pmpcfg2[23] || pmpcfg2[31]))
                        pmpcfg2 <= data;
            
                CSR_PMPCFG3:
                    if (~(pmpcfg3[7]  || pmpcfg3[15] || pmpcfg3[23] || pmpcfg3[31]))
                        pmpcfg3 <= data;
                
                CSR_PMPADDR0:
                    if (~pmpcfg0[7])        pmpaddr0  <= data;
                CSR_PMPADDR1:
                    if (~pmpcfg0[15])       pmpaddr1  <= data;
                CSR_PMPADDR2:
                    if (~pmpcfg0[23])       pmpaddr2  <= data;
                CSR_PMPADDR3:
                    if (~pmpcfg0[31])       pmpaddr3  <= data;
            
                CSR_PMPADDR4:
                    if (~pmpcfg1[7])        pmpaddr4  <= data;
                CSR_PMPADDR5:
                    if (~pmpcfg1[15])       pmpaddr5  <= data;
                CSR_PMPADDR6:
                    if (~pmpcfg1[23])       pmpaddr6  <= data;
                CSR_PMPADDR7:
                    if (~pmpcfg1[31])       pmpaddr7  <= data;
            
                CSR_PMPADDR8:
                    if (~pmpcfg2[7])        pmpaddr8  <= data;
                CSR_PMPADDR9:
                    if (~pmpcfg2[15])       pmpaddr9  <= data;
                CSR_PMPADDR10:
                    if (~pmpcfg2[23])       pmpaddr10 <= data;
                CSR_PMPADDR11:
                    if (~pmpcfg2[31])       pmpaddr11 <= data;
            
                CSR_PMPADDR12:
                    if (~pmpcfg3[7])        pmpaddr12 <= data;
                CSR_PMPADDR13:
                    if (~pmpcfg3[15])       pmpaddr13 <= data;
                CSR_PMPADDR14:
                    if (~pmpcfg3[23])       pmpaddr14 <= data;
                CSR_PMPADDR15:
                    if (~pmpcfg3[31])       pmpaddr15 <= data;
            
                default: /* do nothing */;
            endcase
            
        end
    end

    always_comb begin 
        case (rw_addr)
              // PMP Configuration CSRs
            CSR_PMPCFG0:   rdata = pmpcfg0;
            CSR_PMPCFG1:   rdata = pmpcfg1;
            CSR_PMPCFG2:   rdata = pmpcfg2;
            CSR_PMPCFG3:   rdata = pmpcfg3;
        
            // PMP Address CSRs
            CSR_PMPADDR0:  rdata = pmpaddr0;
            CSR_PMPADDR1:  rdata = pmpaddr1;
            CSR_PMPADDR2:  rdata = pmpaddr2;
            CSR_PMPADDR3:  rdata = pmpaddr3;
            CSR_PMPADDR4:  rdata = pmpaddr4;
            CSR_PMPADDR5:  rdata = pmpaddr5;
            CSR_PMPADDR6:  rdata = pmpaddr6;
            CSR_PMPADDR7:  rdata = pmpaddr7;
            CSR_PMPADDR8:  rdata = pmpaddr8;
            CSR_PMPADDR9:  rdata = pmpaddr9;
            CSR_PMPADDR10: rdata = pmpaddr10;
            CSR_PMPADDR11: rdata = pmpaddr11;
            CSR_PMPADDR12: rdata = pmpaddr12;
            CSR_PMPADDR13: rdata = pmpaddr13;
            CSR_PMPADDR14: rdata = pmpaddr14;
            CSR_PMPADDR15: rdata = pmpaddr15;
            default:       rdata = 32'b0;
        endcase
    end

    assign pmpcfg0_data = pmpcfg0;
    assign pmpcfg1_data = pmpcfg1;
    assign pmpcfg2_data = pmpcfg2;
    assign pmpcfg3_data = pmpcfg3;
    
    // Assigning PMP address outputs
    assign pmpaddr0_data  = pmpaddr0;
    assign pmpaddr1_data  = pmpaddr1;
    assign pmpaddr2_data  = pmpaddr2;
    assign pmpaddr3_data  = pmpaddr3;
    assign pmpaddr4_data  = pmpaddr4;
    assign pmpaddr5_data  = pmpaddr5;
    assign pmpaddr6_data  = pmpaddr6;
    assign pmpaddr7_data  = pmpaddr7;
    assign pmpaddr8_data  = pmpaddr8;
    assign pmpaddr9_data  = pmpaddr9;
    assign pmpaddr10_data = pmpaddr10;
    assign pmpaddr11_data = pmpaddr11;
    assign pmpaddr12_data = pmpaddr12;
    assign pmpaddr13_data = pmpaddr13;
    assign pmpaddr14_data = pmpaddr14;
    assign pmpaddr15_data = pmpaddr15
endmodule