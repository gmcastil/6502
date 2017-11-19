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
      32'h00: state_ascii       <= "   EMPTY";
      32'h01: state_ascii       <= "   RESET";
      32'h02: state_ascii       <= "VECTOR_1";
      32'h04: state_ascii       <= "VECTOR_2";
      32'h08: state_ascii       <= "   FETCH";
      32'h10: state_ascii       <= "  DECODE";
      32'h20: state_ascii       <= "   ABS_1";
      32'h40: state_ascii       <= "   ABS_2";
      32'h80: state_ascii       <= "   ABS_3";
      32'h100: state_ascii      <= "   ABS_4";
      32'h80000000: state_ascii <= "   ERROR";
    endcase
  end

  reg [(8*3)-1:0] IR_ascii;
  always @(*) begin
    case ( IR )
      8'h6D,
      8'h7D,
      8'h79: IR_ascii <= "ADC";

      8'h2D,
      8'h39: IR_ascii <= "AND";

      8'h0E,
      8'h1E: IR_ascii <= "ASL";

      8'h2C: IR_ascii <= "BIT";
      8'h18: IR_ascii <= "CLC";
      8'hB8: IR_ascii <= "CLV";

      8'hCD,
      8'hDD,
      8'hD9: IR_ascii <= "CMP";

      8'hEC: IR_ascii <= "CPX";
      8'hCC: IR_ascii <= "CPY";

      8'hCE,
      8'hDE: IR_ascii <= "DEC";

      8'hCA: IR_ascii <= "DEX";
      8'h88: IR_ascii <= "DEY";

      8'h4D,
      8'h5D,
      8'h59: IR_ascii <= "EOR";

      8'hEE,
      8'hFE: IR_ascii <= "INC";

      8'h4C: IR_ascii <= "JMP";
      8'h20: IR_ascii <= "JSR";

      8'hA9,
      8'hAD,
      8'hBD,
      8'hB9: IR_ascii <= "LDA";

      8'hA2,
      8'hAE,
      8'hBE: IR_ascii <= "LDX";

      8'hA0,
      8'hAC,
      8'hBC: IR_ascii <= "LDY";

      8'h4E: IR_ascii <= "LSR";
      8'hEA: IR_ascii <= "NOP";

      8'h0D,
      8'h1D,
      8'h19: IR_ascii <= "ORA";

      8'h2E,
      8'h3E: IR_ascii <= "ROL";

      8'h6E,
      8'h7E: IR_ascii <= "ROR";

      8'hED,
      8'hFD,
      8'hF9: IR_ascii <= "SBC";

      8'h38: IR_ascii <= "SEC";

      8'h8D,
      8'h9D,
      8'h99: IR_ascii <= "STA";

      8'h8E: IR_ascii <= "STX";
      8'h8C: IR_ascii <= "STY";
    endcase
  end
  // synthesis translate_on
