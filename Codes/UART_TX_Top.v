module UART_TX_Top (
    //input
    input   wire    [7:0]   P_Data,
    input   wire            Data_valid,
    input   wire            Par_EN,
    input   wire            Par_type,
    input   wire            CLK,
    input   wire            RST,
    // ouput
    output  wire            TX_OUT,
    output  wire            Busy
);



// Internal Connections
wire            ser_en;
wire            ser_done;
wire            ser_data;
wire            par_bit;
wire    [2:0]   mux_sel;



// FSM
FSM_TX ins_FSM_TX (
    .data_valid (Data_valid),
    .ser_done (ser_done),
    .par_en (Par_EN),
    .clk (CLK),
    .rst (RST),
    .mux_sel (mux_sel),
    .ser_en (ser_en),
    .busy (Busy)
);



// Serializer
Serializer_TX ins_Serializer_TX (
    .P_Data (P_Data),
    .ser_en (ser_en),
    .clk (CLK),
    .rst (RST),
    .busy (Busy),
    .ser_data (ser_data),
    .ser_done (ser_done)
);



// Parity Calc
Parity_calc_TX ins_Parity_calc_TX (
    .P_Data (P_Data),
    .data_valid (Data_valid),
    .par_type (Par_type),
    .clk (CLK),
    .rst (RST),
    .par_en (Par_EN),
    .par_bit (par_bit)
);



// MUX 8x1
MUX_TX ins_MUX_TX (
    .mux_sel (mux_sel),
    .ser_data (ser_data),
    .par_bit (par_bit),
    .tx_out (TX_OUT)
);



endmodule
