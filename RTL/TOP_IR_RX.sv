/******************************************************************************************
 * Module Name: TOP_IR_RX
 * Author: Mohamed Niazy Hassaneen Ali Mohamed
 * LinkedIn: https://www.linkedin.com/in/mohamed-niazy-2897aa22a/
 * Date: September 24, 2024
 * Description:
 * - This module implements the top-level design for receiving and processing the NEC IR transmission protocol.
 * - It receives an IR signal, decodes it, and displays the address and command data on seven-segment displays.
 * - The module includes clock division, IR reception, and seven-segment display modules for visualization.
 * Notes:
 * - Input data is inverted for compatibility with the IR receiver's expected signal format.
 * - The module outputs the address, command, and their inverses, along with a valid signal indicating data readiness.
 ******************************************************************************************/

module TOP_IR_RX #(
    WIDTH      = 16,  // Width of internal data buses
    FREQ_MHz   = 1,   // Frequency in MHz for tick calculation
    DATA_WIDTH = 8    // Width of data for address and command
) (
    input logic i_data,  // Input data for IR receiver
    clk,  // System clock
    rst_n,  // Asynchronous active-low reset
    output logic [6:0] HEX0,  // Seven-segment display output for address lower nibble
    output logic [6:0] HEX1,  // Seven-segment display output for address upper nibble
    output logic [6:0] HEX2,  // Seven-segment display output for command lower nibble
    output logic [6:0] HEX3,  // Seven-segment display output for command upper nibble
    output logic [6:0] HEX4,  // Seven-segment display output for command bar lower nibble
    output logic [6:0] HEX5,  // Seven-segment display output for command bar upper nibble
    output logic [DATA_WIDTH-1:0] o_address,  // Output address data
    output logic [DATA_WIDTH-1:0] o_address_bar,  // Output address bar data (inverted address)
    output logic [DATA_WIDTH-1:0] o_command,  // Output command data
    output logic [DATA_WIDTH-1:0] o_command_bar,  // Output command bar data (inverted command)
    output logic o_valid  // Output valid signal indicating data is ready
);

  // Internal signal to invert the input IR data
  bit dataIn;
  assign dataIn = ~i_data;  // Invert input data for compatibility with IR receiver

  // Instantiate clock divider to generate a clock for the IR receiver
  clock_dividor inst_clock_dividor (
      .clk    (clk),     // Input system clock
      .rst_n  (rst_n),   // Active-low reset
      .clk_out(clk_out)  // Output divided clock
  );

  // Instantiate IR receiver module
  ir_rx #(
      .DATA_WIDTH(DATA_WIDTH),  // Width of address and command data
      .FREQ_MHz  (FREQ_MHz)     // Frequency of the clock (in MHz) used for IR reception
  ) inst_ir_rx (
      .i_rx_dataIn(dataIn),  // Input data from IR receiver
      .i_clkDiv_rx_clk(clk_out),  // Clock for the IR receiver
      .i_rx_rst_n(rst_n),  // Active-low reset for the IR receiver
      .o_rx_valid(o_valid),  // Output valid signal indicating received data is valid
      .o_rx_frame({o_command_bar, o_command, o_address_bar, o_address})  // Output received frame
  );

  // Instantiate seven-segment display modules for showing address and command data
  seven_seg inst_hex0 (
      .i_num(o_address[3:0]),  // Lower nibble of the address
      .o_seg(HEX0)             // Seven-segment display output for address lower nibble
  );
  seven_seg inst_hex1 (
      .i_num(o_address[7:4]),  // Upper nibble of the address
      .o_seg(HEX1)             // Seven-segment display output for address upper nibble
  );

  seven_seg inst_hex2 (
      .i_num(o_command[3:0]),  // Lower nibble of the command
      .o_seg(HEX2)             // Seven-segment display output for command lower nibble
  );
  seven_seg inst_hex3 (
      .i_num(o_command[7:4]),  // Upper nibble of the command
      .o_seg(HEX3)             // Seven-segment display output for command upper nibble
  );

  seven_seg inst_hex4 (
      .i_num(o_command_bar[3:0]),  // Lower nibble of the inverted command
      .o_seg(HEX4)                 // Seven-segment display output for command bar lower nibble
  );
  seven_seg inst_hex5 (
      .i_num(o_command_bar[7:4]),  // Upper nibble of the inverted command
      .o_seg(HEX5)                 // Seven-segment display output for command bar upper nibble
  );

endmodule
