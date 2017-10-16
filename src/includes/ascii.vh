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
      8'h0E: IR_ascii <= "ASL";
      8'h2C: IR_ascii <= "BIT";
      8'h18: IR_ascii <= "CLC";
      8'hB8: IR_ascii <= "CLV";
      8'hCD: IR_ascii <= "CMP";
      8'hEC: IR_ascii <= "CPX";
      8'hCC: IR_ascii <= "CPY";
      8'hCE: IR_ascii <= "DEC";
      8'h4D: IR_ascii <= "EOR";
      8'hEE: IR_ascii <= "INC";
      8'h4C: IR_ascii <= "JMP";
      8'h20: IR_ascii <= "JSR";
      8'hAD,
      8'hA9: IR_ascii <= "LDA";
      8'hAE: IR_ascii <= "LDX";
      8'hAC: IR_ascii <= "LDY";
      8'h4E: IR_ascii <= "LSR";
      8'hEA: IR_ascii <= "NOP";
      8'h0D: IR_ascii <= "ORA";
      8'h2E: IR_ascii <= "ROL";
      8'h6E: IR_ascii <= "ROR";
      8'hED: IR_ascii <= "SBC";
      8'h8D: IR_ascii <= "STA";
      8'h8E: IR_ascii <= "STX";
      8'h8C: IR_ascii <= "STY";
    endcase
  end
  // synthesis translate_on
