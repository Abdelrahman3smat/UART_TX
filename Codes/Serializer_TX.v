module Serializer_TX (
    input   wire    [7:0]   P_Data,
    input   wire            ser_en,
    input   wire            clk,
    input   wire            rst,
    input   wire            busy,
    output  reg             ser_data,
    output  reg             ser_done
);


//signals
reg     [7:0]   ser_reg;    // To Load P_data
reg     [3:0]   counter;



always @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin
                ser_data <= 1'b0;
                ser_reg  <= 8'b0;
            end
        
        
        else if (ser_en && !busy)  // Loading P_Data
            begin
                ser_reg <= P_Data;
            end
        
        
        else if (ser_en && counter < 8 && busy)   // Serializer Operation 
            begin              
                ser_data <= ser_reg[0];
                ser_reg <= ser_reg >> 1'd1;
                /*ser_reg[0] <= ser_reg[1];
                ser_reg[1] <= ser_reg[2];
                ser_reg[2] <= ser_reg[3];
                ser_reg[3] <= ser_reg[4];
                ser_reg[4] <= ser_reg[5];
                ser_reg[5] <= ser_reg[6];
                ser_reg[6] <= ser_reg[7];*/
            end

    end


  
always @ (posedge clk or negedge rst)   // to count byte for the data for the frame (8 clk_cycles)
    begin
        if (!rst)
            begin
                counter <= 4'd8;
                ser_done <= 1'b0;
            end
        
        else if (ser_en && !busy) 
            begin
                counter <= 4'b0;
                ser_done <= 1'b0;
            end

        else if (ser_en && busy  && counter < 8)  
            begin
                counter <= counter + 1;   
                ser_done <= (counter == 4'd7);    // Indication for compilation of Serializer operation
            end

        
           
    end


endmodule
