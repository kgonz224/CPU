
module cpu_control (inst31_21,Reg2Loc, Branch, BranchZero, BranchNonZero,
		    MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input[10:0] inst31_21;
	output reg [1:0] ALUOp, ALUSrc;
	output reg Reg2Loc, Branch, BranchZero, BranchNonZero, MemRead, MemtoReg;
    	output reg MemWrite, RegWrite;
	
	always @ (inst31_21) begin 
		$display("\tOh____%b\n", inst31_21);
		case(inst31_21)
			11'b11111000010: //LDUR
			begin
				Reg2Loc <= 0; // ??
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 1;
				MemtoReg <= 1;
				ALUOp <= 2'b00;
				MemWrite <= 0;
				ALUSrc <= 2'b01;
				RegWrite <= 1;
			end
			11'b11111000000: //STUR 
			begin
				Reg2Loc <= 1;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; // ??
				ALUOp <= 2'b00;
				MemWrite <= 1;
				ALUSrc <= 2'b01;
				RegWrite <= 0;
			end
			11'b10001011000: //ADD
			begin
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
			end
			11'b1001000100: //ADDI
			begin
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;			
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b10;
				RegWrite <= 1;
			end
			11'b11001011000: //SUB
			begin
				$display("Hi\n");
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
			end
			11'b10001010000: //AND
			begin
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
			end
			11'b10101010000: //ORR
			begin
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp = 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
			end
			11'b10110100xxx: //CBZ
			begin
				Reg2Loc <= 1;
				Branch <= 0;
				BranchZero <= 1;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 0;
			end 
			11'b10110101xxx: //CBNZ
			begin
				Reg2Loc <= 1;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 1;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 0;
			end
			11'b000101xxxxx: //B 
			begin
				Reg2Loc <= 0;
				Branch <= 1;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 0;
			end 
			11'b11111111111: //HALT
			begin
				Reg2Loc <= 0;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b00;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 0;
			end 
			default: $display("You messed up. Invalid opcode sent.\n");		
		endcase
	end 
endmodule
