onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /UART_TX_Top_tb/CLK_tb
add wave -noupdate -expand -group TB /UART_TX_Top_tb/RST_tb
add wave -noupdate -expand -group TB /UART_TX_Top_tb/operation
add wave -noupdate -expand -group TB /UART_TX_Top_tb/P_Data_tb
add wave -noupdate -expand -group TB /UART_TX_Top_tb/Data_valid_tb
add wave -noupdate -expand -group TB -color Cyan /UART_TX_Top_tb/Par_EN_tb
add wave -noupdate -expand -group TB /UART_TX_Top_tb/Par_type_tb
add wave -noupdate -expand -group TB -color Violet /UART_TX_Top_tb/TX_OUT_tb
add wave -noupdate -expand -group TB -color Orange /UART_TX_Top_tb/Busy_tb
add wave -noupdate -expand -group TB /UART_TX_Top_tb/PARALLEL_IN
add wave -noupdate -expand -group TB /UART_TX_Top_tb/Excpec_OUT
add wave -noupdate -expand -group TB -color White -radix binary /UART_TX_Top_tb/Serialization_with_par/serial_data
add wave -noupdate -expand -group TB -color Gray55 -radix binary /UART_TX_Top_tb/Serialization_without_par/serial_data
add wave -noupdate -expand -group TOP /UART_TX_Top_tb/DUT/ser_en
add wave -noupdate -expand -group TOP -color {Green Yellow} /UART_TX_Top_tb/DUT/ser_done
add wave -noupdate -expand -group TOP /UART_TX_Top_tb/DUT/ser_data
add wave -noupdate -expand -group TOP /UART_TX_Top_tb/DUT/par_bit
add wave -noupdate -expand -group TOP /UART_TX_Top_tb/DUT/mux_sel
add wave -noupdate -expand -group FSM /UART_TX_Top_tb/DUT/ins_FSM_TX/par_en
add wave -noupdate -expand -group FSM /UART_TX_Top_tb/DUT/ins_FSM_TX/Current_State
add wave -noupdate -expand -group FSM /UART_TX_Top_tb/DUT/ins_FSM_TX/next_state
add wave -noupdate -expand -group Serializer /UART_TX_Top_tb/DUT/ins_Serializer_TX/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {603500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {645750 ps}
