vlib work
vlog *.v
vsim -gui work.UART_TX_Top_tb -novopt
do wave.do
run -all