module WriteBack(Reg, loadedData, Results, MemToReg, RegWrite,
	  Data2Write, Reg2Write, oldRegWrite);

  input /*reg*/ [4:0] Reg;
  input /*reg*/ [63:0] loadedData, Results;
  input /*reg*/ MemToReg, RegWrite;
  output reg [63:0] Data2Write;
  output reg [4:0] Reg2Write;
  output reg oldRegWrite;

  always @(*)
  begin
	  
	  $display("WB %d\n", $time);
	  oldRegWrite <= RegWrite;
	  Reg2Write <= Reg;

	  if (MemToReg == 0)
		  Data2Write = Results;
	  else
		  Data2Write = loadedData;
	
	  $display("WB %d\n", $time);
  end
endmodule
