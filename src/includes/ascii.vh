// ----------------------------------------------------------------------------
// Module:  ascii.vh
// Project:
// Author:  George Castillo <gmcastil@gmail.com>
// Date:    13 August 2017
//
// Description:
//
// ----------------------------------------------------------------------------

// synthesis translate_off
  reg [(8*8)-1:0] state_ascii;
  always @(*) begin

    case ( state )
      256'd00: state_ascii  <= "   EMPTY";
      256'd01: state_ascii  <= "   RESET";
      256'd02: state_ascii  <= "VECTOR_1";
      256'd04: state_ascii  <= "VECTOR_2";
      256'd08: state_ascii  <= "   FETCH";
      256'd16: state_ascii  <= "  DECODE";
      256'd32: state_ascii  <= "   ABS_1";
      256'd64: state_ascii  <= "   ABS_2";
      256'd128: state_ascii <= "   ABS_3";
      256'd256: state_ascii <= "   ABS_4";
    endcase

  end

  reg [(8*3)-1:0] IR_ascii;
  always @(*) begin

    case ( IR )
      8'h6D: IR_ascii <= "ADC";
      8'h2D: IR_ascii <= "AND";
      8'hEA: IR_ascii <= "NOP";
      8'h4C: IR_ascii <= "JMP";
      8'hAD: IR_ascii <= "LDA";
      8'h0E: IR_ascii <= "ASL";
    endcase

  end
  // synthesis translate_on
