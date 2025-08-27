module FSM_TX (
    input   wire             data_valid,
    input   wire             ser_done,
    input   wire             par_en,
    input   wire             clk,
    input   wire             rst,
    
    output  reg     [2:0]    mux_sel,   
    output  reg              ser_en,
    output  reg              busy
);


localparam [2:0]    idle      = 3'b000,          // 5 states, 1-bit transition between 'em 
                    start_bit = 3'b001,
                    ser_data  = 3'b011,
                    par_bit   = 3'b010,
                    stop_bit  = 3'b110;

reg [2:0]   Current_State;
reg [2:0]   next_state ;


always @ (posedge clk or negedge rst)
    begin
        if (!rst)
            begin 
                Current_State <= idle;
                
            end
        else
            begin
                Current_State <= next_state;
            end
    end


always @ (*)
    begin
        next_state = idle;

        case (Current_State)

        idle        :   if (data_valid)
                            begin
                                next_state = start_bit; 
                            end
                        else 
                            begin
                                next_state = idle;
                            end


                                    
        start_bit   :       begin
                                next_state = ser_data;      // Tranmission of serial data
                            end


        ser_data    :   if (!ser_done)
                            begin
                                next_state = ser_data;
                            end
                        else if (ser_done && par_en)     
                            begin
                                next_state = par_bit;
                            end
                        else
                            begin
                                next_state = stop_bit;
                            end


        par_bit     :       begin
                                next_state = stop_bit;
                            end


        stop_bit    :       begin
                                next_state = idle;
                            end


        default     :       begin
                                next_state = idle;
                            end
        endcase
    end


always @ (*)
    begin
        
        ser_en = 1'b0;
        busy   = 1'b0;
        mux_sel = idle;
        
        case (Current_State)

        idle        :   if (data_valid && !busy)
                            begin
                                ser_en = 1'b1; 
                                busy   = 1'b0;
                                mux_sel = idle;
                            end
                        else 
                            begin
                                ser_en = 1'b0;
                                busy   = 1'b0;
                                mux_sel = idle;
                            end


                                    
        start_bit   :   begin
                            ser_en = 1'b1;
                            busy   = 1'b1;
                            mux_sel = start_bit;      // Tranmission of serial data
                        end


        ser_data    :   if (!ser_done)
                            begin
                                ser_en = 1'b1;
                                busy   = 1'b1;
                                mux_sel = ser_data;
                            end
                        else if (ser_done && par_en)     
                            begin
                                ser_en = 1'b0;
                                busy   = 1'b1;
                                mux_sel = ser_data;
                            end
                        else
                            begin
                                ser_en = 1'b0;
                                busy   = 1'b0;
                                mux_sel = ser_data;
                            end


        par_bit     :       begin
                                ser_en = 1'b0;
                                busy   = 1'b0;
                                mux_sel = par_bit;
                            end

        stop_bit    :       begin
                                ser_en = 1'b0;
                                busy   = 1'b0;
                                mux_sel = stop_bit;
                            end
        
        default     :   begin
                            ser_en = 1'b0;
                            busy   = 1'b0;
                            mux_sel = 1'b0;
                        end  
        
        endcase
    end                 







endmodule