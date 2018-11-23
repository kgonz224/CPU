`include "WriteBack.v"

module MemoryAccess(inBuf, oldBranchAddress, PCSrc,
	oldRegWrite, Data2Write, Reg2Write, clk);

  input [231:0] inBuf;
  input clk;
  reg zero, B, BZ, BNZ, MemRead, MemWrite, MemToReg, RegWrite;
  reg [63:0] branchAddress, Results, Data2;
  reg [31:0] Instruction;
  output reg PCSrc;
  output reg [63:0] oldBranchAddress;
  output wire oldRegWrite;
  output wire [4:0] Reg2Write;
  output wire [63:0] Data2Write;
  reg [63:0] loadedData;
  reg [134:0] outBuf;

  reg [7:0] DMem[8191:0]; // 8192 bytes (1024 double words)

  
  initial // load  data memory
  begin 
	$readmemh("DM_Bytes.txt", DMem);
	PCSrc = 1'b0;
  end

  WriteBack wb(outBuf, Data2Write, Reg2Write, oldRegWrite, clk);

  always@(posedge clk)
  begin
        branchAddress <= inBuf[95:32];
        Results <= inBuf[159:96];
        Data2 <= inBuf[223:160];
        zero <= inBuf[224];
        B <= inBuf[225];
        BZ <= inBuf[226];
        BNZ <= inBuf[227];
        MemWrite <= inBuf[229];
        MemRead <= inBuf[228];
        MemToReg <= inBuf[230];
        RegWrite <= inBuf[231];
        Instruction = inBuf[31:0];
  end

  always@(negedge clk)
  begin
        outBuf[4:0] <= Instruction[4:0];
        outBuf[68:5] <= loadedData;
        outBuf[132:69] <= Results;
        outBuf[133] <= MemToReg;
        outBuf[134] <= RegWrite;
  end

  always @(Instruction)
  begin
	PCSrc <= B | (BZ & zero) | (BNZ & ~zero);
	  
	if (MemWrite == 1)
		DMem[Results] = Data2;
	if (MemRead == 1)
		loadedData = DMem[Results];

	oldBranchAddress = branchAddress;
	$display("MEM Branch:          %b\n", oldBranchAddress);
  end
endmodule
