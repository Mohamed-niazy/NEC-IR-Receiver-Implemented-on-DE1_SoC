## Generated SDC file "IR_Reciever_Quartus_Proj.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.0 Build 915 10/25/2022 SC Standard Edition"

## DATE    "Tue Sep 24 04:09:34 2024"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clk_out} -source [get_ports {clk}] -duty_cycle 1/1 -multiply_by 1 -divide_by 50 -master_clock {clk} [get_nets {inst_clock_dividor|clk_out}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk_out}] -rise_to [get_clocks {clk_out}] -setup 0.410  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -rise_to [get_clocks {clk_out}] -hold 0.380  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -fall_to [get_clocks {clk_out}] -setup 0.410  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -fall_to [get_clocks {clk_out}] -hold 0.380  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -rise_to [get_clocks {clk}] -setup 0.360  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -rise_to [get_clocks {clk}] -hold 0.320  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -fall_to [get_clocks {clk}] -setup 0.360  
set_clock_uncertainty -rise_from [get_clocks {clk_out}] -fall_to [get_clocks {clk}] -hold 0.320  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -rise_to [get_clocks {clk_out}] -setup 0.410  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -rise_to [get_clocks {clk_out}] -hold 0.380  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -fall_to [get_clocks {clk_out}] -setup 0.410  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -fall_to [get_clocks {clk_out}] -hold 0.380  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -rise_to [get_clocks {clk}] -setup 0.360  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -rise_to [get_clocks {clk}] -hold 0.320  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -fall_to [get_clocks {clk}] -setup 0.360  
set_clock_uncertainty -fall_from [get_clocks {clk_out}] -fall_to [get_clocks {clk}] -hold 0.320  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk_out}] -setup 0.360  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk_out}] -hold 0.320  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk_out}] -setup 0.360  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk_out}] -hold 0.320  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk_out}] -setup 0.360  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk_out}] -hold 0.320  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk_out}] -setup 0.360  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk_out}] -hold 0.320  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {i_data}]
set_input_delay -add_delay -min -clock [get_clocks {clk}]  2.000 [get_ports {i_data}]
set_input_delay -add_delay -max -clock [get_clocks {clk}]  3.000 [get_ports {rst_n}]
set_input_delay -add_delay -min -clock [get_clocks {clk}]  2.000 [get_ports {rst_n}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX0[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX1[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX2[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX3[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX4[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {HEX5[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_address_bar[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_command_bar[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  2.000 [get_ports {o_valid}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

