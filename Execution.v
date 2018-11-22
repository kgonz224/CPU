`include "ALU_control.v"
`include "MemoryAccess.v"

module Execution(inBuf, Data2Write, Reg2Write, oldRegWrite, oldBranchAddress,
	PCSrc, clk);

  input [298:0] inBuf;
  input clk;
  reg [1:0] ALUSrc, ALUOp;
  reg B, BZ, BNZ, MemWrite, MemRead, MemtoReg, RegWrite;
  reg [31:0] Instruction;
  reg [63:0] Address, signExtInstr, Data1, Data2;
  output wire [4:0] Reg2Write;
  output wire PCSrc, oldRegWrite;
  output wire [63:0] oldBranchAddress, Data2Write;
  reg [63:0] branchAddress, Results, ALUInput2;
  reg zero;
  reg [231:0] outBuf;

  MemoryAccess mem(outBuf, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write, clk);

  alu_control aluControl(Instruction[31:21], ALUOp, ALUInst, clk);
 
  always@(posedge clk)
  begin
        Address <= inBuf[63:0];
        signExtInstr <= inBuf[159:96];
        Data1 <= inBuf[223:160];
        Data2 <= inBuf[287:224];
        ALUSrc <= inBuf[289:288];
        ALUOp <= inBuf[291:290];
        B <= inBuf[192];
        BZ <= inBuf[193];
        BNZ <= inBuf[194];
        MemWrite <= inBuf[195];
        MemRead <= inBuf[196];
        MemtoReg <= inBuf[197];
        RegWrite <= inBuf[198];
	Instruction = inBuf[95:64];
  end

  always@(negedge clk)
  begin
        outBuf[31:0] <= Instruction;
        outBuf[95:32] <= branchAddress;
        outBuf[159:96] <= Results;
        outBuf[223:160] <= Data2;
        outBuf[224] <= zero;
	outBuf[225] <= B;
	outBuf[226] <= BZ;
	outBuf[227] <= BNZ;
	outBuf[228] <= MemRead;
	outBuf[229] <= MemWrite;
	outBuf[230] <= MemtoReg;
	outBuf[231] <= RegWrite;
  end

  always @(Instruction)
  begin
        $display("EXcode value: %32b %d\n", Instruction[31:0], $time);

	#10
	branchAddress <= Address + (signExtInstr << 2);

	case(ALUSrc)
		2'b00: ALUInput2 = Data2;
		2'b01: ALUInput2 = signExtInstr;
		2'b10: ALUInput2 = Instruction[21:10];
		default: $display("You messed up. ALUSrc sent invalid ",
			"Instr.\n");
	endcase
	 //Wait for ALU control
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
