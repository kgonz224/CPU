module WriteBack(inBuf, Data2Write, Reg2Write, oldRegWrite, clk);

  input [134:0] inBuf;
  input clk;
  reg [4:0] Reg;
  reg [63:0] loadedData, Results;
  reg MemToReg, RegWrite;
  output reg [63:0] Data2Write;
  output reg [4:0] Reg2Write;
  output reg oldRegWrite;

  always@(posedge clk)
  begin
        Reg <= inBuf[4:0];
        loadedData <= inBuf[68:5];
        Results <= inBuf[132:69];
        MemToReg <= inBuf[133];
        RegWrite = inBuf[134];
  end

  always @(posedge clk)
  begin
	  #2
	  oldRegWrite = RegWrite;
	  Reg2Write = Reg;

	  if (MemToReg == 0)
		  Data2Write = Results;
	  else
		  Data2Write = loadedData;
  end
endmodule
