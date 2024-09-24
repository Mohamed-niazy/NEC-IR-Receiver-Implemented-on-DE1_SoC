/***************************************************************************************************************
 * Module Name: tb_TOP_IR_RX
 * Author: Mohamed Niazy Hassaneen Ali Mohamed
 * LinkedIn: https://www.linkedin.com/in/mohamed-niazy-2897aa22a/
 * Date: September 24, 2024
 * Description:
 * - This is a testbench for the TOP_IR_RX module which implements the NEC IR transmission protocol.
 * - The testbench simulates the IR receiver by sending different frames containing address and command bytes.
 * - It verifies the correct capture and decoding of the transmitted IR frame by the TOP_IR_RX module.
 * - The testbench includes tasks for initializing the simulation, applying reset, and sending IR signals.
 * Notes:
 * - Parameters for IR pulse durations, system clock frequency, and frame data can be customized.
 * - The testbench simulates typical IR frames with valid address, command, and their respective inverse bits.
 **************************************************************************************************************/
module tb_TOP_IR_RX #(
    WIDTH = 16,        // Parameter: Bus width for the data
    DATA_WIDTH = 8,    // Parameter: Width of the data (address and command bits)
    FREQ_MHz = 1       // Parameter: Operating frequency in MHz
) (
    output logic i_data,  // Input signal for IR data transmission
    clk,                  // System clock
    rst_n,                // Asynchronous active-low reset
    input logic [6:0] HEX0,  // Seven-segment display for the lower nibble of the address
    input logic [6:0] HEX1,  // Seven-segment display for the upper nibble of the address
    input logic [6:0] HEX2,  // Seven-segment display for the lower nibble of the command
    input logic [6:0] HEX3,  // Seven-segment display for the upper nibble of the command
    input logic [6:0] HEX4,  // Seven-segment display for the lower nibble of the inverted command
    input logic [6:0] HEX5,  // Seven-segment display for the upper nibble of the inverted command
    input logic [DATA_WIDTH-1:0] o_address,       // Output address data
    o_address_bar,                                // Output inverted address data
    o_command,                                    // Output command data
    o_command_bar,                                // Output inverted command data
    input logic o_valid                           // Output valid signal indicating the frame is ready
);

  ////////////////////////////////////////////////////////////////////////////////////////
  //////////// Define the duration of each part of the IR frame (pulses and spaces) //////
  ////////////////////////////////////////////////////////////////////////////////////////
  localparam START_PUL_DUR = 9_000;      // Duration of the start pulse (9 ms)
  localparam START_SPACE_DUR = 4_500;    // Duration of the space after the start pulse (4.5 ms)
  localparam BRUST_PUL_DUR = 562;        // Duration of the burst pulse (562.5 us)
  localparam LOW_SPACE_DUR = 562;        // Duration of the space after burst pulse for logic low (562.5 us)
  localparam HIGH_SPACE_DUR = 1_687;     // Duration of the space after burst pulse for logic high (1.6875 ms)
  localparam SAFETY_MARGIN_DUR = 100;    // Safety margin duration for timing tolerance (100 us)

  ////////////////////////////////////////////////////////////////////////////////////////
  //////////// Define the number of ticks for each part of the IR frame /////////////////
  //////////// (Ticks = Duration in microseconds * Frequency in MHz) ////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  localparam START_PUL_TICK = START_PUL_DUR * FREQ_MHz;    // Number of ticks for the start pulse
  localparam START_SPACE_TICK = START_SPACE_DUR * FREQ_MHz;  // Number of ticks for the space after the start pulse
  localparam BRUST_PUL_TICK = BRUST_PUL_DUR * FREQ_MHz;    // Number of ticks for the burst pulse
  localparam LOW_SPACE_TICK = LOW_SPACE_DUR * FREQ_MHz;    // Number of ticks for the space after burst pulse for logic low
  localparam HIGH_SPACE_TICK = HIGH_SPACE_DUR * FREQ_MHz;  // Number of ticks for the space after burst pulse for logic high
  localparam SAFETY_MARGIN_TICK = SAFETY_MARGIN_DUR * FREQ_MHz;  // Number of ticks for the safety margin

  // Instantiate the IR receiver top module
  TOP_IR_RX #(
      .WIDTH(WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .FREQ_MHz(FREQ_MHz)
  ) inst_top (
      .*
  );

  // Clock generation: Toggle clock every 5 time units
  always #5 clk = ~clk;

  // Initial block to set up the simulation
  initial begin
    initialization();  // Call the initialization task
    reset();           // Reset the system

    // Send a series of frames to the receiver
    RECEIVE_FRAME(8'd46, 8'd33, 8'd13, ~(8'd13));
    RECEIVE_FRAME(8'd22, 8'd23, 8'd25, ~(8'd25));
    RECEIVE_FRAME(8'd122, 8'd123, 8'd124, ~(8'd124));

    $stop;  // End the simulation
  end

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Initialization for the testbench signals //////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task initialization();
    i_data = 1;  // Initialize input data to 1 (default idle state)
    clk = 0;     // Initialize clock to 0
    rst_n = 1;   // De-assert reset (active-low)
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Apply reset to the system //////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task reset();
    rst_n = 0;  // Assert reset (active-low)
    repeat (START_PUL_TICK) @(posedge clk);  // Hold reset for a duration of the start pulse
    rst_n = 1;  // De-assert reset
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Simulate sending a start pulse and space //////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task start_bit();
    i_data = 0;  // Drive data low to signal the start pulse
    repeat (START_PUL_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for start pulse duration
    i_data = 1;  // Drive data high for the space after the start pulse
    repeat (START_SPACE_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for the space duration
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Simulate sending a single data bit ////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task enter_bit(input bit data);
    i_data = 0;  // Drive data low for the burst pulse
    repeat (BRUST_PUL_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for burst pulse duration
    i_data = 1;  // Drive data high for the space based on the data bit value
    if (data) 
      repeat (HIGH_SPACE_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for high space duration
    else 
      repeat (LOW_SPACE_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);   // Wait for low space duration
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Simulate sending a full byte of data //////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task enter_byte(input bit [7:0] byte_);
    for (int i = 0; i < 8; i++) 
      enter_bit(byte_[i]);  // Call `enter_bit` for each bit of the byte
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Finalize the start bit and send a data bit ////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task start_bit_final();
    i_data = 0;  // Start pulse
    repeat (START_PUL_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for start pulse duration
    i_data = 1;  // Space after start pulse
    repeat (START_SPACE_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for space duration
    start_bit();  // Re-call start bit task
    enter_bit(0);  // Send a data bit
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Simulate sending a complete frame (address + command) /////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task RECEIVE_FRAME(
    bit [DATA_WIDTH-1:0] address,         // Address to transmit
    address_bar,                          // Inverted address
    command,                              // Command to transmit
    command_bar                           // Inverted command
  );
    start_bit();                          // Send start bit
    enter_byte(address);                  // Transmit the address byte
    enter_byte(address_bar);              // Transmit the inverted address byte
    enter_byte(command);                  // Transmit the command byte
    enter_byte(command_bar);              // Transmit the inverted command byte
    stop_pulse();                         // Send the stop pulse
    wait_before_another_frame();          // Wait before sending the next frame
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Wait a safe margin before sending the next frame //////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task wait_before_another_frame();
    i_data = 1;  // Default idle state
    repeat (SAFETY_MARGIN_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for safety margin duration
  endtask

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////////// Task: Simulate sending the stop pulse ///////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  task stop_pulse();
    i_data = 0;  // Drive data low to signal the stop pulse
    repeat (BRUST_PUL_TICK) @(negedge inst_top.inst_clock_dividor.clk_out);  // Wait for stop pulse duration
  endtask

endmodule