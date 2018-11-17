/*
  Author: Prabakar, FIU-SCIS
   Template for proj4 test bench program
   Edited: Kevin Gonzalez, Dianaliz
*/

`include "InstructionDecode.v"

module InstructionFetch; // processor test bench template
  reg [7:0] IMem[4095:0]; // 4096 bytes (1024 words)
//  reg [7:0] DMem[8191:0]; // 8192 bytes (1024 double words)
  reg [31:0] instruction; // all instructions are 32-bit wide
  reg [63:0] PC; // PC contains 64-bit byte address
	
  initial // load instruction memory and data memory
  begin 
	$dumpfile("CPU.vcd");
	$dumpvars;
	$readmemh("IM_Bytes.txt", IMem);
//	$readmemh("DM_Bytes.txt", DMem);
	PC = 64'b0; // initialize PC
//	First Instruction is NOP until instructions are loaded into PC
	instruction[7:0] <= 8'b11010101;
	instruction[15:8] <= 8'b00000011;
	instruction[23:16] <= 8'b00100000;
	instruction[31:24] <= 8'b00011111;
  end 
 
  InstructionDecode id(instruction, PC, PCSrc, BranchAddress);

  always //sequential logic of fetch for illustration
  begin
	// this code block can be performed in any other module
	// concatenate four bytes of IMem into PC
	  $display("%d\n", $time);
	  instruction[7:0] <= IMem[PC];
	  instruction[15:8] <= IMem[PC + 1];
	  instruction[23:16] <= IMem[PC + 2];
	  instruction[31:24] <= IMem[PC + 3];
	  $display("Opcode value: %32b \n", instruction[31:0]);
	  #10
	if (PCSrc == 0)
	begin
		PC = PC + 4; // PC needs to be updated in the processor/datapath module
	end
	else
	begin
		PC = BranchAddress;
	end
  end

  // output data memory to a file when HALT instruction is fetched
  always @(instruction) 
  begin
	  if (instruction[31:21] == {11{1'b1}})
    begin
	$display("final opcode is detected \n");
//	$writememh("DM_Final_Bytes.txt", DMem);
	$finish;
    end
  end
endmodule 
