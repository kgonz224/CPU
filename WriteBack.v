module WriteBack(Reg, loadedData, Results, MemToReg, RegWrite,
	  Data2Write, Reg2Write, oldRegWrite);

  input /*reg*/ [4:0] Reg;
  input /*reg*/ [63:0] loadedData, Results;
  input /*reg*/ MemToReg, RegWrite;
  output wire [63:0] Data2Write;
  output wire [4:0] Reg2Write;
  output wire oldRegWrite;

  always
  begin
	  oldRegWrite = RegWrite;
	  Reg2Write = Reg;

	  if (MemToReg == 0)
		  Data2Write = Results;
	  else
		  Data2Write = loadedData;
  end
endmodule
