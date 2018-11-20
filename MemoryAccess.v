`include "WriteBack.v"

module MemoryAccess(InstructionI, branchAddressI, ResultsI, Data2I, zeroI, BI, BZI,
  	BNZI, MemReadI, MemWriteI, MemToRegI, RegWriteI, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  input /*reg*/ zeroI, BI, BZI, BNZI, MemReadI, MemWriteI, MemToRegI, RegWriteI;
  input /*reg*/ [63:0] branchAddressI, ResultsI, Data2I;
  input /*reg*/ [31:0] InstructionI;
  reg zero, B, BZ, BNZ, MemRead, MemWrite, MemToReg, RegWrite, MemToRegO, RegWriteO;
  reg [63:0] branchAddress, Results, Data2, loadedData, ResultsO, loadedDataO;
  reg [31:0] Instruction;
  reg [4:0] InstructionO;
  output reg PCSrc;
  output reg [63:0] oldBranchAddress;
  output wire oldRegWrite;
  output wire [4:0] Reg2Write;
  output wire [63:0] Data2Write;

  reg [7:0] DMem[8191:0]; // 8192 bytes (1024 double words)

  
  initial // load  data memory
  begin 
	$readmemh("DM_Bytes.txt", DMem);
	PCSrc = 1'b0;
  end

  WriteBack wb(InstructionO, loadedDataO, ResultsO, MemToRegO, RegWriteO,
	  Data2Write, Reg2Write, oldRegWrite);

  always
  begin
	#1
	branchAddress = branchAddressI;
	Results = ResultsI;
	Data2 = Data2I;
	zero = zeroI;
	B = BI;
	BZ = BZI;
  	BNZ = BNZI;
	MemRead = MemReadI;
	MemWrite = MemWriteI;
	MemToReg = MemToRegI;
	RegWrite = RegWriteI;
	#2;
  end
  always @(Instruction)
  begin
        $display("MEMode value: %32b %d\n", Instruction[31:0], $time);

	PCSrc <= B | (BZ & zero) | (BNZ & ~zero);
	  
	if (MemWrite == 1)
		DMem[Results] = Data2;
	if (MemRead == 1)
		loadedData = DMem[Results];

	oldBranchAddress = branchAddress;
  end

  always
  begin
	#3
	InstructionO = Instruction[4:0];
	loadedDataO = loadedData;
	ResultsO = Results;
	MemToRegO = MemToReg;
	RegWriteO = RegWrite;
  end
endmodule
