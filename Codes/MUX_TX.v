module MUX_TX (                         // MUX 8x1
    input   wire    [2:0]   mux_sel,    // from FSM
    input   wire            ser_data,   // from Serializer
    input   wire            par_bit,    // from parity_calc

    output  reg             tx_out      // UART Output
);


                               
localparam [2:0]    start_bit   = 3'b001,     // 4 selections, 1-bit transition between 'em
                    ser_data_st = 3'b011,
                    par_bit_st  = 3'b010,
                    stop_bit    = 3'b110;     // stop_bit for the frame


always @ (*) 
    begin
        tx_out = 1'b1;

        case (mux_sel)

        start_bit   :   begin
                          tx_out = 1'b0;
                        end


        ser_data_st :   begin
                          tx_out = ser_data;
                        end


        par_bit_st  :   begin
                          tx_out = par_bit;
                        end


        stop_bit    :   begin
                          tx_out = 1'b1;
                        end


        default     :   begin
                          tx_out = 1'b1;
                        end

        endcase
    end




endmodule
