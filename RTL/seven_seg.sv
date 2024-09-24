/******************************************************************************************
 * Module Name: seven_seg
 * Author: Mohamed Niazy Hassaneen Ali Mohamed
 * LinkedIn: https://www.linkedin.com/in/mohamed-niazy-2897aa22a/
 * Date: September 24, 2024
 * Description:
 * - This module implements a 7-segment decoder for displaying hexadecimal digits (0-15) on a 7-segment display.
 * - Each 4-bit input value corresponds to a unique 7-segment display pattern.
 * - If the input is outside the defined range (0-15), a default pattern (representing 'X') is shown.
 * Notes:
 * - The 7-segment display is driven by a 7-bit output, where each bit controls a specific segment (a-g).
 ******************************************************************************************/

module seven_seg (
    input  logic [3:0] i_num,  // 4-bit input number (0-15)
    output logic [6:0] o_seg   // 7-segment display output (a-g)
);

  // Local parameters representing input values 0-15
  localparam NUM_0 = 0, NUM_1 = 1, NUM_2 = 2, NUM_3 = 3, NUM_4 = 4, 
             NUM_5 = 5, NUM_6 = 6, NUM_7 = 7, NUM_8 = 8, NUM_9 = 9, 
             NUM_10 = 10, NUM_11 = 11, NUM_12 = 12, NUM_13 = 13, 
             NUM_14 = 14, NUM_15 = 15;

  // 7-segment encoding for each input number
  localparam SEVEN_SEG_NUM_0  = 7'B100_0000,  // Display '0'
             SEVEN_SEG_NUM_1  = 7'B111_1001,  // Display '1'
             SEVEN_SEG_NUM_2  = 7'B010_0100,  // Display '2'
             SEVEN_SEG_NUM_3  = 7'B011_0000,  // Display '3'
             SEVEN_SEG_NUM_4  = 7'B001_1001,  // Display '4'
             SEVEN_SEG_NUM_5  = 7'B001_0010,  // Display '5'
             SEVEN_SEG_NUM_6  = 7'B000_0010,  // Display '6'
             SEVEN_SEG_NUM_7  = 7'B111_1000,  // Display '7'
             SEVEN_SEG_NUM_8  = 7'B000_0000,  // Display '8'
             SEVEN_SEG_NUM_9  = 7'B001_0000,  // Display '9'
             SEVEN_SEG_NUM_10 = 7'B000_1000,  // Display 'A'
             SEVEN_SEG_NUM_11 = 7'B000_0011,  // Display 'b'
             SEVEN_SEG_NUM_12 = 7'B100_0110,  // Display 'C'
             SEVEN_SEG_NUM_13 = 7'B010_0001,  // Display 'd'
             SEVEN_SEG_NUM_14 = 7'B000_0110,  // Display 'E'
             SEVEN_SEG_NUM_15 = 7'B000_1110,  // Display 'F'
             SEVEN_SEG_NUM_X  = 7'B011_1111;  // Display 'X' (for undefined input)

  // Combinational logic for 7-segment display decoding
  always_comb begin
    case (i_num)
      NUM_0:   o_seg = SEVEN_SEG_NUM_0;  // Display '0'
      NUM_1:   o_seg = SEVEN_SEG_NUM_1;  // Display '1'
      NUM_2:   o_seg = SEVEN_SEG_NUM_2;  // Display '2'
      NUM_3:   o_seg = SEVEN_SEG_NUM_3;  // Display '3'
      NUM_4:   o_seg = SEVEN_SEG_NUM_4;  // Display '4'
      NUM_5:   o_seg = SEVEN_SEG_NUM_5;  // Display '5'
      NUM_6:   o_seg = SEVEN_SEG_NUM_6;  // Display '6'
      NUM_7:   o_seg = SEVEN_SEG_NUM_7;  // Display '7'
      NUM_8:   o_seg = SEVEN_SEG_NUM_8;  // Display '8'
      NUM_9:   o_seg = SEVEN_SEG_NUM_9;  // Display '9'
      NUM_10:  o_seg = SEVEN_SEG_NUM_10; // Display 'A'
      NUM_11:  o_seg = SEVEN_SEG_NUM_11; // Display 'b'
      NUM_12:  o_seg = SEVEN_SEG_NUM_12; // Display 'C'
      NUM_13:  o_seg = SEVEN_SEG_NUM_13; // Display 'd'
      NUM_14:  o_seg = SEVEN_SEG_NUM_14; // Display 'E'
      NUM_15:  o_seg = SEVEN_SEG_NUM_15; // Display 'F'
      default: o_seg = SEVEN_SEG_NUM_X;  // Display 'X' for undefined input
    endcase
  end

endmodule
