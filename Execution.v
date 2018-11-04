`include "ALU_control.v"
`include "MemoryAccess.v"

module Execution(Address, Instruction, signExtInstr, Data1, Data2, ALUSrc,
	ALUOp, Branch, MemWrite, MemRead, MemtoReg, RegWrite, Data2Write,
	Reg2Write, oldRegWrite, oldBranchAddress, PCSrc);

  input reg ALUSrc, ALUOp, Branch, MemWrite, MemtoReg, RegWrite;
  input reg [31:0] Instruction;
  input reg [63:0] Address, signExtInstr;
  output wire oldRegWrite, PCSrc;
  output wire [4:0] Reg2Write;
  output wire [63:0] oldBranchAddress, Data2Write;
  wire [63:0] ALUInput2, branchAddress, Results;
  wire [3:0] ALUInstr;
  wire zero;

  MemoryAccess mem(Instruction, branchAddress, Results, Data2, zero, Branch,
  	MemRead, MemWrite, MemToReg, RegWrite, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  ALUControl aluControl(Instruction[31:21], ALUOp, ALUInst);

  always
  begin

	branchAddress = Address + (signExtInstr << 2);

	if (ALUSrc == 0)
		ALUInput2 = Data2;
	else
		ALUInput2 = signExtInstr;

	case(ALUInst)
		4'b0000: Results = Data1 & ALUInput2;
		4'b0001: Results = Data1 | ALUInput2;
                4'b0010: Results = Data1 + ALUInput2;
                4'b0110: Results = Data1 - ALUInput2;
                4'b0111: Results = ALUInput2;
                4'b1100: Results = ~(Data1 | ALUInput2);
		default: $display("You messed up. ALUControl sent invalid ",
		       	"Instr");
	endcase


	if (Results == 0)
		zero = 1;
	else
		zero = 0;
  end
end
