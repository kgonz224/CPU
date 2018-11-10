`include "ALU_control.v"
`include "MemoryAccess.v"

module Execution(Address, Instruction, signExtInstr, Data1, Data2, ALUSrc,
	ALUOp, B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite, Data2Write,
	Reg2Write, oldRegWrite, oldBranchAddress, PCSrc);

  input /*reg*/ [1:0] ALUSrc, ALUOp;
  input /*reg*/ B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite;
  input /*reg*/ [31:0] Instruction;
  input /*reg*/ [63:0] Address, signExtInstr, Data1, Data2;
  reg [63:0] ALUInput2, branchAddress, Results;
  reg [3:0] ALUInstr;
  reg zero;
  output wire [4:0] Reg2Write;
  output wire PCSrc, oldRegWrite;
  output wire [63:0] oldBranchAddress, Data2Write;

  MemoryAccess mem(Instruction, branchAddress, Results, Data2, zero, B, BZ,
	BNZ, MemRead, MemWrite, MemToReg, RegWrite, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  alu_control aluControl(Instruction[31:21], ALUOp, ALUInst);
  always @(ALUInst)
  begin
	#1
	branchAddress = Address + (signExtInstr << 2);
	  $display("\t%4 \n", ALUSrc);
	case(ALUSrc)
		2'b00: ALUInput2 = Data2;
		2'b01: ALUInput2 = signExtInstr;
		2'b10: ALUInput2 = Instruction[21:10];
		default: $display("You messed up. ALUSrc sent invalid ",
			"Instr.\n");
	endcase

	case(ALUInst)
		4'b0000: Results = Data1 & ALUInput2;
		4'b0001: Results = Data1 | ALUInput2;
                4'b0010: Results = Data1 + ALUInput2;
                4'b0110: Results = Data1 - ALUInput2;
                4'b0111: Results = ALUInput2;
                4'b1100: Results = ~(Data1 | ALUInput2);
		default: $display("You messed up. ALUControl sent invalid ",
		       	"Instr.\n");
	endcase

	if (Results == 0)
		zero = 1;
	else
		zero = 0;
  end
endmodule
