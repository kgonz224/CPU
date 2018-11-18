`include "Execution.v"
`include "CPU_control.v"

module InstructionDecode(InstructionI, AddressI, PCSrc, BranchAddress);

  reg [63:0] Regs [31:0]; // 32 double words
  input [31:0] InstructionI;
  input [63:0] AddressI;
  output PCSrc;
  output [63:0] BranchAddress;
  reg [63:0] Address, Data1, Data2, signExtInstr;
  reg [31:0] Instruction;
  wire Reg2Loc, RegWrite, B, BZ, BNZ, MemRead, MemWrite, MemtoReg, PCSrc;
  wire [1:0] ALUOp, ALUSrc;

  initial
  begin
	Regs[31] = {64{1'b0}};
  end

	cpu_control controlUnit(Instruction[31:21], Reg2Loc, B, BZ, BNZ,
	  MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

  
  Execution ex(Address, Instruction, signExtInstr, Data1, Data2, ALUSrc,
	  ALUOp, B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite,
	  Data2Write, Reg2Write, OldRegWrite, BranchAddress, PCSrc);

always@(*)
  begin
	  #1
	  Address = AddressI;
	  Instruction = InstructionI;
	  #1
  end
always@(Instruction)
  begin

	  Data1 = Regs[Instruction[9:5]];
	  #1	//Wait for Control unit
	  
	  if (Reg2Loc == 0)
	          Data2 = Regs[Instruction[20:16]];
	  else
                  Data2[7:0] = Regs[Instruction[4:0]];

	  if(B)
	  begin
		  signExtInstr[25:0] = Instruction[25:0];
		  signExtInstr[63:45] = {38{Instruction[25]}};  
	  end
	  else if(BZ | BNZ)
	  begin		  
		  signExtInstr[18:0] = Instruction[23:5];
		  signExtInstr[63:45] = {45{Instruction[23]}};
	  end
	  else
	  begin
		  signExtInstr[9:0] = Instruction[20:11];
		  signExtInstr[63:10] = {54{Instruction[20]}};
	  end

  end
  always @(OldRegWrite)
  begin
	Regs[Reg2Write] = Data2Write;
  end
endmodule


