`include "Execution.v"
`include "CPU_control.v"

module InstructionDecode(Instruction, Address, PCSrc, BranchAddress);

  reg [63:0] Regs [31:0]; // 32 double words
  input /*reg*/ [31:0] Instruction;
  input /*reg*/ [63:0] Address;
  output PCSrc;
  output [63:0] BranchAddress;
  reg [63:0] Data1, Data2, signExtInstr;
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
	  Data1 = Regs[Instruction[9:5]];

	  if (Reg2Loc == 0)
	          Data2 = Regs[Instruction[20:16]];
	  else
                  Data2[7:0] = Regs[Instruction[4:0]];


	  signExtInstr[31:0] = Instruction;
	  signExtInstr[63:32] = {32{Instruction[31]}};
	  $display("\tsignExtInstr: %64b ", signExtInstr);

  end
  always @(OldRegWrite)
  begin
	Regs[Reg2Write] = Data2Write;
  end
endmodule


