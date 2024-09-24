/******************************************************************************************
 * Module Name: ir_received
 * Author: Mohamed Niazy Hassaneen Ali Mohamed
 * LinkedIn: https://www.linkedin.com/in/mohamed-niazy-2897aa22a/
 * Date: September 5, 2024
 * Description:
 * - This module implements the NEC IR transmission protocol receiver.
 * - It captures and verifies the IR signal based on pulse distance encoding.
 * - The module processes the received frame, checks for validity, and outputs the data.
 * Notes:
 * - Buffered data is captured and processed to validate the transmitted frame.
 ******************************************************************************************/
module ir_rx #(
    DATA_WIDTH = 8,  // Width of the data frame
    FREQ_MHz   = 1   // Frequency in MHz for tick calculation
) (
    input  logic                    i_rx_dataIn,      // Input data from IR receiver
    input  logic                    i_clkDiv_rx_clk,  // Clock signal for the receiver
    input  logic                    i_rx_rst_n,       // Asynchronous reset, active low
    output logic                    o_rx_valid,       // Indicates valid received data
    output logic [DATA_WIDTH*4-1:0] o_rx_frame        // Output frame containing received data
);
  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////// Define local parameters for finite state machine (FSM) states ////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  localparam IDLE = 0;  // State: Waiting for the start pulse
  localparam START_PULSE_CHECK = 1;  // State: Checking if the first pulse is a start pulse or noise
  localparam START_SPACE_CHECK = 2;  // State: Checking if the space after the start pulse is correct
  localparam FRAME_CAPTURE = 3;  // State: Capturing the command data and address
  localparam STOP_PULSE_CHECK = 4;  // State: Checking if the stop pulse is correct
  localparam DATA_CHECK = 5;         // State: Verifying if the command is the inverse of the command parameter

  ////////////////////////////////////////////////////////////////////////////////////////
  //////////// Define the duration of each part of the frame (pulses and spaces) //////////
  ////////////////////////////////////////////////////////////////////////////////////////
  localparam START_PUL_DUR = 9_000;  // Duration of the start bit (9 ms)
  localparam START_SPACE_DUR = 4_500;  // Duration of the space after the start bit (4.5 ms)
  localparam BRUST_PUL_DUR = 562;  // Duration of the burst bit (562.5 us)
  localparam LOW_SPACE_DUR = 562;  // Duration of the space after burst bit for logic low (562.5 us)
  localparam HIGH_SPACE_DUR = 1_687;     // Duration of the space after burst bit for logic high (1.6875 ms)
  localparam SAFETY_MARGIN_DUR = 100;  // Safety margin duration (100 us)

  ////////////////////////////////////////////////////////////////////////////////////////
  //////////// Define the number of ticks for each part of the frame (pulses and spaces) //
  //////////// NO. OF TICKS = TIME(US) * FREQ(MHz)                                    // 
  ////////////////////////////////////////////////////////////////////////////////////////
  localparam START_PUL_TICK = START_PUL_DUR * FREQ_MHz;  // Number of ticks for the start bit
  localparam START_SPACE_TICK = START_SPACE_DUR * FREQ_MHz;   // Number of ticks for the space after the start bit
  localparam BRUST_PUL_TICK = BRUST_PUL_DUR * FREQ_MHz;  // Number of ticks for the burst bit
  localparam LOW_SPACE_TICK = LOW_SPACE_DUR * FREQ_MHz;       // Number of ticks for the space after burst bit for logic low
  localparam HIGH_SPACE_TICK = HIGH_SPACE_DUR * FREQ_MHz;     // Number of ticks for the space after burst bit for logic high
  localparam SAFETY_MARGIN_TICK = SAFETY_MARGIN_DUR * FREQ_MHz; // Number of ticks for the safety margin

  ////////////////////////////////////////////////////////////////////////////////////////
  ///////////// Define internal variables for the module /////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  bit [$clog2(
START_PUL_TICK
):0] rx_cnt_tick;  // Counter for ticks, size adjusted to handle the largest pulse duration
  bit [2:0] rx_current_state, rx_next_state;  // FSM state registers
  bit [5:0] rx_cnt_bit;  // Counter for bits captured
  bit
      rx_cnt_tick_flag,  // Flag to enable tick counter
      rx_cnt_bit_flag,  // Flag to enable bit counter
      rx_sample,  // Flag to sample the bit
      done,  // Indicates if the frame capture is complete and valid
      rx_dataIn_lag;  // Buffer for input data to detect edges
  logic [DATA_WIDTH*4-1:0] rx_frame;  // Frame register to store captured data

  /******************************************************************************************
 ******************************* Design Overview *******************************************
 *******************************************************************************************
 * 1. Three procedural blocks (two sequential, one combinational) 
 * - First sequential block: Assigns the current state value to the next state
 * - Second sequential block: Handles outputs, manages counters, and updates state 
 * - First combinational block: Determines the next state of the FSM based on inputs and timing
 * - Second combinational block: Controls the internal signals of the FSM (tick, bit count, sample, done)
 *******************************************************************************************
 * 2. Frame Information:
 * - The NEC IR protocol transmits a message consisting of the following parts:
 *    - 9ms leading pulse burst, followed by a 4.5ms space
 *    - 8-bit address, followed by the 8-bit inverse of the address
 *    - 8-bit command, followed by the 8-bit inverse of the command
 *    - Logical '0': 562.5µs pulse + 562.5µs space (1.125ms total per bit)
 *    - Logical '1': 562.5µs pulse + 1.6875ms space (2.25ms total per bit)
 * - The entire message frame, excluding the final pulse, takes 67.5ms to transmit.
 *******************************************************************************************
 * 3. Design Flow 
 * - The FSM moves through various states to decode and validate the transmitted frame:
 *   - IDLE: Wait for the start pulse
 *   - START_PULSE_CHECK: Verify the leading 9ms pulse
 *   - START_SPACE_CHECK: Check the 4.5ms space after the start pulse
 *   - FRAME_CAPTURE: Capture the 32 bits of data (address, inverse address, command, inverse command)
 *   - STOP_PULSE_CHECK: Verify the final stop pulse to mark the end of the frame
 *   - DATA_CHECK: Ensure the command bits are the inverse of the corresponding inverse command bits
 ******************************************************************************************/
  // Sequential block to update the current state
  always @(posedge i_clkDiv_rx_clk or negedge i_rx_rst_n) begin
    if (!i_rx_rst_n) begin
      rx_current_state <= IDLE;
    end else begin
      rx_current_state <= rx_next_state;
    end
  end

  // Sequential block to handle counters and outputs
  always @(posedge i_clkDiv_rx_clk or negedge i_rx_rst_n) begin
    if (!i_rx_rst_n) begin
      rx_cnt_tick <= 'b0;
      rx_cnt_bit <= 'b0;
      rx_dataIn_lag <= 'b0;
      o_rx_frame <= 'b0;
      rx_frame <= 'b0;
      o_rx_valid <= 'b0;
    end else begin
      // Update tick counter
      if (rx_cnt_tick_flag) rx_cnt_tick <= rx_cnt_tick + 'b1;
      else rx_cnt_tick <= 'b0;

      // Update bit counter
      if (rx_cnt_bit_flag) rx_cnt_bit <= rx_cnt_bit + 'b1;

      // Sample the bit if rx_sample is asserted
      if (rx_sample) begin
        if (rx_cnt_tick <= HIGH_SPACE_TICK + BRUST_PUL_TICK + SAFETY_MARGIN_TICK &&
            rx_cnt_tick >= HIGH_SPACE_TICK + BRUST_PUL_TICK - SAFETY_MARGIN_TICK) begin
          rx_frame[rx_cnt_bit-1] <= 'b1;
        end
      end

      // Output the captured frame and set valid signal
      if (done) begin
        o_rx_frame <= rx_frame;
        o_rx_valid <= 'b1;
      end

      // Reset counters and frame if in IDLE state
      if (rx_current_state == IDLE) begin
        rx_cnt_bit <= 'b0;
        rx_frame   <= 'b0;
      end

      // Buffer input data for edge detection
      rx_dataIn_lag <= i_rx_dataIn;
    end
  end


  // Combinational block to determine the next state
  always @(*) begin
    case (rx_current_state)

      // Initial state, waiting for the input signal to go high indicating the start of transmission
      IDLE: begin
        if (i_rx_dataIn)
          rx_next_state <= START_PULSE_CHECK;  // Start pulse detected, move to check it
        else rx_next_state <= IDLE;  // Stay in IDLE if no input
      end

      // Check if the start pulse matches the expected 9ms duration with safety margin
      START_PULSE_CHECK: begin
        if (!i_rx_dataIn) begin  // Detect falling edge after the start pulse
          if (rx_cnt_tick <= START_PUL_TICK + SAFETY_MARGIN_TICK &&
              rx_cnt_tick >= START_PUL_TICK - SAFETY_MARGIN_TICK) begin
            rx_next_state <= START_SPACE_CHECK;  // Valid start pulse, check the space duration next
          end else begin
            rx_next_state <= IDLE;  // Invalid pulse, reset to IDLE
          end
        end else begin
          rx_next_state <= START_PULSE_CHECK;  // Continue checking the start pulse
        end
      end

      // Check if the space after the start pulse is valid (should be 4.5ms)
      START_SPACE_CHECK: begin
        if (i_rx_dataIn) begin  // Detect rising edge after the space
          if (rx_cnt_tick <= START_SPACE_TICK + SAFETY_MARGIN_TICK &&
              rx_cnt_tick >= START_SPACE_TICK - SAFETY_MARGIN_TICK) begin
            rx_next_state <= FRAME_CAPTURE;  // Valid space, start capturing the frame data
          end else begin
            rx_next_state <= IDLE;  // Invalid space, reset to IDLE
          end
        end else begin
          rx_next_state <= START_SPACE_CHECK;  // Continue checking the space
        end
      end

      // Capture the frame data, reading 32 bits (address, inverse address, command, inverse command)
      FRAME_CAPTURE: begin
        if (rx_cnt_tick <= BRUST_PUL_TICK + HIGH_SPACE_TICK + SAFETY_MARGIN_TICK) begin
          if (rx_cnt_bit == 'd32 && rx_cnt_tick <= BRUST_PUL_TICK + SAFETY_MARGIN_TICK && i_rx_dataIn) begin
            rx_next_state <= STOP_PULSE_CHECK;  // After 32 bits, check for the stop pulse
          end else begin
            rx_next_state <= FRAME_CAPTURE;  // Continue capturing bits
          end
        end else begin
          rx_next_state <= IDLE;  // Timeout, return to IDLE
        end
      end

      // Check if the stop pulse matches the expected 562.5µs
      STOP_PULSE_CHECK: begin
        if (!i_rx_dataIn) begin  // Detect falling edge after the stop pulse
          if (rx_cnt_tick <= BRUST_PUL_TICK + SAFETY_MARGIN_TICK &&
              rx_cnt_tick >= BRUST_PUL_TICK - SAFETY_MARGIN_TICK) begin
            rx_next_state <= DATA_CHECK;  // Valid stop pulse, move to data check
          end else begin
            rx_next_state <= IDLE;  // Invalid stop pulse, reset to IDLE
          end
        end else begin
          rx_next_state <= STOP_PULSE_CHECK;  // Continue checking the stop pulse
        end
      end

      // Final state: Verify that the command and its inverse are correct
      DATA_CHECK: begin
        rx_next_state <= IDLE;  // Check complete, return to IDLE
      end

      // Default state in case of an error
      default: rx_next_state <= IDLE;
    endcase
  end


  // Combinational block to handle internal signals
  always @(*) begin
    // Initialize flags to their default states
    rx_cnt_tick_flag = 'b1;  // Enable the tick counter by default
    rx_cnt_bit_flag  = 'b0;  // Disable the bit counter by default
    rx_sample        = 'b0;  // Do not sample the data by default
    done             = 'b0;  // Indicate that the frame is not complete by default

    case (rx_current_state)

      // In the IDLE state, no ticks are counted, waiting for the start pulse
      IDLE: begin
        rx_cnt_tick_flag = 'b0;  // Disable tick counter in the IDLE state
      end

      // In the START_PULSE_CHECK state, we check for the falling edge after the start pulse
      START_PULSE_CHECK: begin
        if (!i_rx_dataIn) begin  // When the signal goes low (falling edge)
          // Check if the duration of the start pulse is within the valid range
          if (rx_cnt_tick <= START_PUL_TICK + SAFETY_MARGIN_TICK &&
              rx_cnt_tick >= START_PUL_TICK - SAFETY_MARGIN_TICK) begin
            rx_cnt_tick_flag = 'b0;  // Stop counting ticks after a valid start pulse
          end
        end
      end

      // In the START_SPACE_CHECK state, we check the space after the start pulse
      START_SPACE_CHECK: begin
        if (i_rx_dataIn) begin  // When the signal goes high (rising edge)
          // Check if the space duration is within the valid range
          if (rx_cnt_tick <= START_SPACE_TICK + SAFETY_MARGIN_TICK &&
              rx_cnt_tick >= START_SPACE_TICK - SAFETY_MARGIN_TICK) begin
            rx_cnt_tick_flag = 'b0;  // Stop counting ticks after a valid space
          end
        end
      end

      // In the FRAME_CAPTURE state, we capture the data bits
      FRAME_CAPTURE: begin
        // If a falling edge is detected (start of a new bit)
        if (!i_rx_dataIn && rx_dataIn_lag) begin
          rx_cnt_bit_flag = 'b1;  // Enable the bit counter to count the bits
        end
        // If a rising edge is detected (end of the space, ready to sample the bit)
        if (i_rx_dataIn && !rx_dataIn_lag) begin
          rx_sample        = 'b1;  // Enable sampling of the bit
          rx_cnt_tick_flag = 'b0;  // Stop counting ticks while sampling the bit
        end
      end

      // In the DATA_CHECK state, we check the validity of the received frame
      DATA_CHECK: begin
        // Compare the received command (bits [31:24]) with its inverse (bits [23:16])
        if (rx_frame[23:16] == ~rx_frame[31:24]) begin
          done = 'b1;  // If the command and its inverse match, the frame is valid
        end
      end

    endcase
  end
endmodule
