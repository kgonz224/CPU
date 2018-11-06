`include "Execution.v"
`include "CPU_control.v"

module InstructionDecode(Instruction, Address, PCSrc, BranchAddress);

  reg [63:0] Regs [31:0]; // 32 double words
  input reg [32:0] Instruction;
  input reg [63:0] Address;
  wire Reg2Loc, RegWrite;
  output PCSrc;
  output [63:0] BranchAddress;
  wire [63:0] Data1, Data2, signExtInstr, BranchAddress;
  wire Reg2Loc, RegWrite, B, BZ, BNZ, MemRead, MemWrite, MemtoReg, PCSrc; 
  wire [1:0] ALUOp, ALUSrc;

  always
  begin
	Regs[31] = {64{1'b0}};
  end

  always
  begin
	  cpu_control controlUnit(Instruction[31:21], Reg2Loc, B, BZ, BNZ,
		  MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

	  Data1 = Regs[Instruction[9:5]];

	  if (Reg2Loc == 0)
	          Data2 = Regs[Instruction[20:16]];
	  else
                  Data2[7:0] = Regs[Instruction[4:0]];


	  signExtInstr[31:0] = Instruction;
	  signExtInstr[63:32] = {32{Instruction[31]}};

	  Excecution ex(Address, Instruction, signExtInstr, Data1, Data2, ALUSrc,
		  ALUOp, B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite,
		  Data2Write, Reg2Write, OldRegWrite, BranchAddress, PCSrc);
  end
  always @(OldRegWrite)
  begin
	Regs[Reg2Write] = Data2Write;
  end
end


