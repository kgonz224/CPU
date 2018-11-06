module alu_control (inst31_21, ALUOp, control_line);
	input[10:0] inst31_21;
	input[1:0] ALUOp;
	output reg[3:0]control_line;
	
	always @(*) begin 
		#1
		if ( ALUOp == 00) begin // LDUR & STUR
			control_line <= 4'b0010;
		end
		else if ( ALUOp == 01) begin
			control_line <= 4'b0111;
		end 
		else if (inst31_21 == 11001011000 && ALUOp == 10)begin //sub
			control_line <= 4'b0110;
		end 
		else if (inst31_21 == 10001010000 && ALUOp == 10)begin //and
			control_line <= 4'b0000;
		end 
		else if (inst31_21 == 10101010000 && ALUOp == 10)begin //orr
			control_line <= 4'b0001;
		end 
		else if (ALUOp == 10)begin //add, addi, branch, etc
			control_line <= 4'b0010;
		end
    end
	
endmodule 
			
