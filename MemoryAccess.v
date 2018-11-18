`include "WriteBack.v"

module MemoryAccess(InstructionI, branchAddressI, ResultsI, Data2I, zeroI, BI, BZI,
  	BNZI, MemReadI, MemWriteI, MemToRegI, RegWriteI, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  input /*reg*/ zeroI, BI, BZI, BNZI, MemReadI, MemWriteI, MemToRegI, RegWriteI;
  input /*reg*/ [63:0] branchAddressI, ResultsI, Data2I;
  input /*reg*/ [31:0] InstructionI;
  reg zero, B, BZ, BNZ, MemRead, MemWrite, MemToReg, RegWrite;
  reg [63:0] branchAddress, Results, Data2, loadedData;
  reg [31:0] Instruction;
  output reg PCSrc;
  output reg [63:0] oldBranchAddress;
  output wire oldRegWrite;
  output wire [4:0] Reg2Write;
  output wire [63:0] Data2Write;

  reg [7:0] DMem[8191:0]; // 8192 bytes (1024 double words)

  
  initial // load  data memory
  begin 
	$readmemh("DM_Bytes.txt", DMem);
  end

  WriteBack wb(Instruction[4:0], loadedData, Results, MemToReg, RegWrite,
	  Data2Write, Reg2Write, oldRegWrite);

  always
  begin
	#5
	branchAddress = branchAddressI;
	Results = ResultsI;
	Data2 = Data2I;
	zero = zeroI;
	B = BI;
	BZ = BZI;
  	BNZ = BNZI;
	MemRead = MemReadI;
	MemWrite = MemWriteI;
	MemtoReg = MemToRegI;
	RegWrite = RegWriteI;
	#3
  end
  always @(Instruction)
  begin
	PCSrc = B | (BZ & zero) | (BNZ & ~zero);
	  
	if (MemWrite == 1)
		DMem[Results] = Data2;
	if (MemRead == 1)
		loadedData = DMem[Results];

	oldBranchAddress = branchAddress;
  end
endmodule
