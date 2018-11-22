`include "Execution.v"
`include "CPU_control.v"

module InstructionDecode(inBuf, PCSrc, BranchAddress, clk);

  input [95:0] inBuf;
  input clk;
  reg [31:0] Instruction;
  reg [63:0] Address;
  reg [63:0] Regs [31:0]; // 32 double words
  output PCSrc;
  output [63:0] BranchAddress;
  reg [63:0] Data1, Data2, signExtInstr;
  wire Reg2Loc, RegWrite, B, BZ, BNZ, MemRead, MemWrite, MemtoReg, PCSrc;
  wire [1:0] ALUOp, ALUSrc;
  reg [298:0] outBuf;

  initial
  begin
	Regs[31] = {64{1'b0}};

  end

  cpu_control controlUnit(Instruction[31:21], Reg2Loc, B, BZ, BNZ,
	  MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, clk);
 
  Execution ex(outBuf, Data2Write, Reg2Write, OldRegWrite, BranchAddress,
	  PCSrc, clk);

  always@(posedge clk)
  begin
	Address <= inBuf[95:32];
        Instruction = inBuf[31:0];
  end

  always@(negedge clk)
  begin
	outBuf[63:0] <= Address;
	outBuf[95:64] <= Instruction;
	outBuf[159:96] <= signExtInstr;
	outBuf[223:160] <= Data1;
        outBuf[287:224] <= Data2;
        outBuf[289:288] <= ALUSrc;
        outBuf[291:290] <= ALUOp;
        outBuf[192] <= B;
        outBuf[193] <= BZ;
        outBuf[194] <= BNZ;
        outBuf[195] <= MemWrite;
        outBuf[196] <= MemRead;
        outBuf[197] <= MemtoReg;
	outBuf[198] <= RegWrite;
  end

  always@(Instruction)
  begin
	  $display("IDcode value: %32b %d\n", Instruction[31:0], $time);
	  Data1 <= Regs[Instruction[9:5]];

	  #10
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

