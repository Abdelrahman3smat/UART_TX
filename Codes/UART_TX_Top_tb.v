`timescale 1ns/1ps

module UART_TX_Top_tb ();



parameter CLK_Period = 5;
parameter Test_Cases = 6;


integer frame_width = 11;
integer frame_width_no_par = 10;    // without parity 
integer operation;





// DUT signals
reg     [7:0]   P_Data_tb;
reg             Data_valid_tb;
reg             Par_EN_tb;
reg             Par_type_tb;
reg             CLK_tb;
reg             RST_tb;
wire            TX_OUT_tb;
wire            Busy_tb;




// Memories
reg     [7:0]  PARALLEL_IN   [0:Test_Cases-1];
reg     [10:0]  Excpec_OUT   [0:Test_Cases-1];




// DUT instantiation
UART_TX_Top DUT (
    .P_Data (P_Data_tb),
    .Data_valid (Data_valid_tb),
    .Par_EN (Par_EN_tb),
    .Par_type (Par_type_tb),
    .CLK (CLK_tb),
    .RST (RST_tb),
    .TX_OUT (TX_OUT_tb),
    .Busy (Busy_tb)
);



//Clock Generation
always #(0.5*CLK_Period) CLK_tb = ~CLK_tb;




// Initial Block
initial
    begin
        
        $monitor("** Time = %0t, Data Valid = %d, Busy = %d **", $time, Data_valid_tb, Busy_tb); 

        $dumpfile ("UART_TX_tb.vcd");
        $dumpvars;


    // Read Files
        $readmemb ("parallel_data_in.txt", PARALLEL_IN);
        $readmemb ("serial_data_out.txt", Excpec_OUT);


        Reset();
        intialize();
        

// Test cases
        for (operation = 0 ; operation < Test_Cases ; operation = operation+1) 
            begin
// Test cases for with parity transmission                
                if(operation < 3)
                    begin
                        Read (PARALLEL_IN[operation]);
                        Serialization_with_par (frame_width , Excpec_OUT[operation] , operation);
                    end

// Test cases for without parity transmission
                else    
                    begin
                        Read_without_par (PARALLEL_IN[operation]);
                        Serialization_without_par (frame_width_no_par , Excpec_OUT[operation] , operation);
                    end
            end


        #50
        $finish;
    end




// Tasks

// intialization
task intialize;
    begin  
        CLK_tb = 0; 
        Data_valid_tb = 1'b0;
        Par_EN_tb = 1'b0;
        Par_type_tb = 1'b0;     // Even All over the testbench
    end
endtask




// Reset
task Reset;
    begin
        RST_tb = 1'b0;
        #(CLK_Period);
        RST_tb = 1'b1;
        #(CLK_Period);
    end
endtask




// Data valid - Parity activation (with parity case)
task Data_Activation;
    begin
        Data_valid_tb = 1'b1;
        Par_EN_tb = 1'b1;
        #(CLK_Period)
        Data_valid_tb = 1'b0;
    end
endtask




// Data valid - Parity activation (without parity case)
task Data_Activation_no_par;
    begin
        Data_valid_tb = 1'b1;
        Par_EN_tb = 1'b0;
        #(CLK_Period)
        Data_valid_tb = 1'b0;
    end
endtask




// Reading parallel data
task Read;
    input   reg [7:0]   parallel_data ;
    begin
        P_Data_tb = parallel_data;
        #(CLK_Period);
        Data_Activation ();
    end
endtask




// Reading parallel data for without parity serialization
task Read_without_par;
    input   reg [7:0]   parallel_data ;
    begin
        P_Data_tb = parallel_data;
        #(CLK_Period);
        Data_Activation_no_par ();
    end
endtask




// Serialization Output
task Serialization_with_par;

    input   integer               frame_width_s;
    input   reg         [10:0]    expec_out_tb;     
    input   integer               oper_num;


    reg    [10:0]  serial_data;
    integer i;


    begin
        serial_data = 11'b0;

        @(posedge CLK_tb)
        for (i = 0 ; i < frame_width_s ; i = i+1)
            begin
                #(CLK_Period);
                 serial_data[i] <= TX_OUT_tb;
            end
        #(CLK_Period);

        
        if (serial_data == expec_out_tb)
            begin
                 $display ("** Test Case (%0d) with Parity **Passed** at time: (%0t) with P_Data = %b  and Transmitted_Data = %b **", oper_num, $time, P_Data_tb, serial_data);
            end
        else 
            begin
                $display ("** Test Case (%0d) with Parity **Failed** at time: (%0t) **", oper_num, $time);   
            end
           
    end 
endtask




// Serialization Output without parity
task Serialization_without_par;

    input   integer               frame_width_s;
    input   reg         [9:0]    expec_out_tb;  // frame size = 10 bits withour parity  
    input   integer               oper_num;


    reg    [9:0]  serial_data;  // frame size = 10 bits without parity
    integer i;


    begin
        serial_data = 10'b0;

        @(posedge CLK_tb)
        for (i = 0 ; i < frame_width_s ; i = i+1)
            begin
                #(CLK_Period);
                 serial_data[i] <= TX_OUT_tb;
            end
        #(CLK_Period);

        
        if (serial_data == expec_out_tb)
            begin
                 $display ("** Test Case (%0d) without Parity **Passed** at time: (%0t) with P_Data = %b  and Transmitted_Data = %b **", oper_num, $time, P_Data_tb, serial_data);
            end
        else 
            begin
                $display ("** Test Case (%0d) without Parity **Failed** at time: (%0t) **", oper_num, $time);   
            end
           
    end 
endtask



endmodule
