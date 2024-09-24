/******************************************************************************************
 * Module Name: clock_dividor
 * Author: Mohamed Niazy Hassaneen Ali Mohamed
 * LinkedIn: https://www.linkedin.com/in/mohamed-niazy-2897aa22a/
 * Date: September 5, 2024
 * Description:
 * - This module divides the input clock frequency by a factor of 2.
 * - It generates an output clock signal with half the frequency of the input clock.
 * - The division is achieved by counting clock cycles and toggling the output clock.
 * Notes:
 * - The counter resets when it reaches 24, toggling the clock and maintaining stability.
 * Revision History:
 * - September 5, 2024: Initial version
 ******************************************************************************************/

module clock_dividor (
    input  logic clk,     // Input clock signal
    input  logic rst_n,   // Active-low reset signal
    output logic clk_out  // Output divided clock signal
);

  // Internal register to count clock cycles
  reg [7:0] cnt;

  // Always block triggered on the rising edge of the input clock
  always @(posedge clk) begin
    // Active-low reset condition
    if (!rst_n) begin
      cnt     <= 'b0;  // Reset the counter to 0
      clk_out <= 'b0;  // Reset the output clock to 0
    end else begin
      cnt <= cnt + 1;  // Increment the counter on each clock cycle
      // Toggle the output clock when the counter reaches 24
      if (cnt == 'd24) begin
        clk_out <= ~clk_out;  // Invert the output clock signal
        cnt     <= 0;         // Reset the counter after toggling the clock
      end
    end
  end

endmodule
