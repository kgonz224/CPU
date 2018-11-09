`include "WriteBack.v"

module MemoryAccess(Instruction, branchAddress, Results, Data2, zero, B, BZ,
  	BNZ, MemRead, MemWrite, MemToReg, RegWrite, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write);

  input /*reg*/ zero, B, BZ, BNZ, MemRead, MemWrite, MemToReg, RegWrite;
  input /*reg*/ [63:0] branchAddress, Results, Data2;
  input /*reg*/ [31:0] Instruction;
  output reg PCSrc;
	output reg [63:0] oldBranchAddress;
  reg [63:0] loadedData;
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

always @(Instruction)
  begin
	#5
	PCSrc = B | (BZ & zero) | (BNZ & ~zero);
	  
	if (MemWrite == 1)
		DMem[Results] = Data2;
	if (MemRead == 1)
		loadedData = DMem[Results];

	oldBranchAddress = branchAddress;

  end
endmodule
