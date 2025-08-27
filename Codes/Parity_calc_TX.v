module Parity_calc_TX (
    input   wire   [7:0]   P_Data,
    input   wire           data_valid,
    input   wire           par_type,
    input   wire           clk,
    input   wire           rst,
    input   wire           par_en,

    output  reg            par_bit
);





always @ (posedge clk or negedge rst)
    if (!rst)
        begin
            par_bit <= 1'b0;
        end

    else if (data_valid && par_en) 
        begin
            par_bit <= par_type ? ~(^P_Data) : (^P_Data);     // odd P_Data = 1'b1 : even P_Data = 1'b0
        end



endmodule
