`include "ALU_control.v"
`include "MemoryAccess.v"

module Execution(AddressI, InstructionI, signExtInstrI, Data1I, Data2I, ALUSrcI,
	ALUOpI, BI, BZI, BNZI, MemWriteI, MemReadI, MemtoRegI, RegWriteI, Data2Write,
	Reg2Write, oldRegWrite, oldBranchAddress, PCSrc);

  input /*reg*/ [1:0] ALUSrcI, ALUOpI;
  input /*reg*/ BI, BZI, BNZI, MemWriteI, MemReadI, MemtoRegI, RegWriteI;
  input /*reg*/ [31:0] InstructionI;
  input /*reg*/ [63:0] AddressI, signExtInstrI, Data1I, Data2I;
  reg [1:0] ALUSrc, ALUOp;
  reg B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite, zero, BO, BZO, BNZO, MemWriteO, 
	  MemReadO, MemtoRegO, RegWriteO, zeroO;
  reg [31:0] Instruction, InstructionO;
  reg [63:0] Address, signExtInstr, Data1, Data2, ALUInput2, branchAddress, Results,
  	 Data2O, branchAddressO, ResultsO;
  reg [3:0] ALUInstr;
  output wire [4:0] Reg2Write;
  output wire PCSrc, oldRegWrite;
  output wire [63:0] oldBranchAddress, Data2Write;

  MemoryAccess mem(InstructionO, branchAddressO, ResultsO, Data2O, zeroO, BO, BZO,
	BNZO, MemReadO, MemWriteO, MemToRegO, RegWriteO, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  alu_control aluControl(Instruction[31:21], ALUOp, ALUInst);
	
  always
  begin
	#1
	Address = AddressI;
	signExtInstr = signExtInstrI;
	Data1 = Data1I;
	Data2 = Data2I;
	ALUSrc = ALUSrcI;
	ALUOp = ALUOpI; 
	B = BI;
	BZ = BZI;
	BNZ = BNZI;
	MemWrite = MemWriteI;
	MemRead = MemReadI;
	MemtoReg = MemtoRegI;
	RegWrite = RegWriteI;
	Instruction = InstructionI;
	#2;
  end

  always @(Instruction)
  begin
        $display("EXcode value: %32b %d\n", Instruction[31:0], $time);


	branchAddress <= Address + (signExtInstr << 2);

	case(ALUSrc)
		2'b00: ALUInput2 = Data2;
		2'b01: ALUInput2 = signExtInstr;
		2'b10: ALUInput2 = Instruction[21:10];
		default: $display("You messed up. ALUSrc sent invalid ",
			"Instr.\n");
	endcase
	#1 //Wait for ALU control
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

  always
  begin
        #3
        BO = B;
       	BZO = BZ;
       	BNZO = BNZ;
	MemWriteO = MemWrite;
        MemReadO = MemRead;
	MemtoRegO = MemtoReg;
	RegWriteO = RegWrite;
       	zeroO = zero;
	Data2O = Data2;
	branchAddressO = branchAddress;
	ResultsO = Results;
        InstructionO = InstructionO;
  end

endmodule
