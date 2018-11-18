module WriteBack(RegI, loadedDataI, ResultsI, MemToRegI, RegWriteI,
	  Data2Write, Reg2Write, oldRegWrite);

  input [4:0] RegI;
  input [63:0] loadedDataI, ResultsI;
  input MemToRegI, RegWriteI;
  reg [4:0] Reg;
  reg [63:0] loadedData, Results;
  reg MemToReg, RegWrite;
  output reg [63:0] Data2Write;
  output reg [4:0] Reg2Write;
  output reg oldRegWrite;

  always
  begin
	#6
	Reg = RegI;
	loadedData = loadedDataI;
	Results = ResultsI;
	MemToReg = MemToRegI;
	RegWrite = RegWriteI;  
	#2;
  end
  always @(RegWrite)
  begin
	  oldRegWrite = RegWrite;
	  Reg2Write <= Reg;

	  if (MemToReg == 0)
		  Data2Write = Results;
	  else
		  Data2Write = loadedData;
  end
endmodule
