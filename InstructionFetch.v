/*
  Author: Prabakar, FIU-SCIS
   Template for proj5 test bench program
   Edited: Kevin, Dianaliz, Vanessa
*/

`include "InstructionDecode.v"

module InstructionFetch; // processor test bench template
  reg [7:0] IMem[4095:0]; // 4096 bytes (1024 words)
//  reg [7:0] DMem[8191:0]; // 8192 bytes (1024 double words)
  reg [31:0] instruction, instructionO, inst; // all instructions are 32-bit wide
  reg [63:0] PC, PCO; // PC contains 64-bit byte address
  reg clk;
  reg [95:0] outBuf;
  wire [63:0] BranchAddress;

  initial // load instruction memory and data memory
  begin 
  	clk = 1'b0;
	$dumpfile("CPU.vcd");
	$dumpvars;
	$readmemh("IM_Bytes.txt", IMem);
//	$readmemh("DM_Bytes.txt", DMem);
	PC = 64'b0; // initialize PC
  end 
 
  always
  begin
	#80
	clk = ~clk;
  end

  InstructionDecode id(outBuf, PCSrc, BranchAddress, clk);

  always@(posedge clk) //sequential logic of fetch for illustration
  begin

	// this code block can be performed in any other module
	// concatenate four bytes of IMem into PC
	  instruction[7:0] = IMem[PC];
	  instruction[15:8] = IMem[PC + 1];
	  instruction[23:16] = IMem[PC + 2];
	  instruction[31:24] = IMem[PC + 3];
  
	#70
	if (PCSrc == 0)
	begin
		PC = PC + 4; // PC needs to be updated in the processor/datapath module
	end
	if (PCSrc == 1)
	begin
		PC = BranchAddress;
	end
  end

  always@(negedge clk)
  begin
	outBuf[31:0] = instruction;
	outBuf[95:32] = PC;
  end

  // output data memory to a file when HALT instruction is fetched
  always @(instruction) 
  begin
	if (instruction[31:21] == {11{1'b1}})
	begin
		#800 //5 * clk time from posedge to posedge
		$display("final opcode is detected\n");
		$finish;
    	end
  end
endmodule 
