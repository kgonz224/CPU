
module cpu_control (inst31_21,Reg2Loc, Branch, BranchZero, BranchNonZero,
		    MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input[10:0] inst31_21;
	output reg [1:0] ALUOp, ALUSrc;
	output reg Reg2Loc, Branch, BranchZero, BranchNonZero, MemRead, MemtoReg;
    	output reg MemWrite, RegWrite;
	
	/*wire [1:0] ALUOp, ALUSrc;
	wire Reg2Loc, Branch, BranchZero, BranchNonZero, MemRead, MemtoReg;
	wire MemWrite, RegWrite;*/
	
	
	always @ (inst31_21) begin 
		if 		(inst31_21 == 11'b11111000010) begin //LDUR 
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
		else if (inst31_21 == 11'b11111000000) begin //STUR 
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
		else if (inst31_21 == 11'b10001011000) begin //ADD 
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
		else if (inst31_21 == 11'b1001000100X) begin //ADDI 
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
		else if (inst31_21 == 11'b11001011000) begin //SUB
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
		else if (inst31_21 == 11'b10001010000) begin //AND
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
		else if (inst31_21 == 11'b10101010000 ) begin //ORR
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
		else if (inst31_21 == 11'b10110100XXX ) begin //CBZ
				Reg2Loc <= 1;
				Branch <= 0;
				BranchZero <= 1;
				BranchNonZero <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
		end 
		else if (inst31_21 == 11'b10110101XXX ) begin //CBNZ
				Reg2Loc <= 1;
				Branch <= 0;
				BranchZero <= 0;
				BranchNonZero <= 1;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 2'b00;
				RegWrite <= 1;
		end 
		else if (inst31_21 == 11'b000101XXXXX ) begin //B
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
		else if (inst31_21 == 11'b11111111111 ) begin //HALT
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
		else begin
			$display("You messed up. Invalid opcode sent.\n");		
        	end	
	end 
endmodule




 
