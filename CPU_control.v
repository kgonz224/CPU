
module cpu_control (inst31_21,Reg2Loc, Branch, MemRead, MemtoReg
                    ALUOp, MemWrite, ALUSrc, RegWrite);
	input[10:0] inst31_21;
	output[1:0] ALUOp;
	output Reg2Loc, Branch, MemRead, MemtoReg;
        output MemWrite, ALUSrc, RegWrite;
	
	wire [1:0] ALUOp;
	wire Reg2Loc, Branch, MemRead, MemtoReg;
	wire MemWrite, ALUSrc, RegWrite;
	
	
	always @* begin 
		if (inst31_21 == 11'b11111000010) begin //LDUR 
				Reg2Loc <= x; // ??
				Branch <= 0;
				MemRead <= 1;
				MemtoReg <= 1;
				ALUOp <= 2'b00;
				MemWrite <= 0;
				ALUSrc <= 1;
				RegWrite <= 1;
		end
		else if inst31_21 == 11'b11111000000) begin //STUR 
				Reg2Loc <= 1;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= x; // ??
				ALUOp <= 2'b00;
				MemWrite <= 1;
				ALUSrc <= 1;
				RegWrite <= 0;
		end
		else if inst31_21 == 11'b10001011000) begin //ADD 
				Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 1;
		end
		else if inst31_21 == 11'b11001011000) begin //SUB
				Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 1;
		end
		else if inst31_21 == 11'b10001010000) begin //AND
				Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 1;
		end
		else if inst31_21 == 11'b10101010000 ) begin //ORR
				Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 1;
		end 
		else if inst31_21 == 11'b11111111111 ) begin //HALT
				Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				ALUOp <= 2'b10;
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 1;
		end 
		else begin
                Reg2Loc <= 0;
				Branch <= 0;
				MemRead <= 0;
				MemtoReg <= 0; 
				MemWrite <= 0;
				ALUSrc <= 0;
				RegWrite <= 0;  
      end
	
endmodule




 
