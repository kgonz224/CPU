module alu_control (inst31_21, ALUOp, control_line);
	input[10:0] inst31_21;
	input[1:0] ALUOp;
	output[3:0]control_line;
  
	wire [1:0] ;
	
	always @ (*) begin 
		if ( ALUOp == 00) begin // LDUR & STUR
			control_line <= 0010;
		end
		else if ( ALUOp == 01) begin
			control_line <= 0111;
		end 
		else if (inst31_21 == 10001011000 && ALUOp == 10)begin //add
			control_line <= 0010;
		end
		else if (inst31_21 == 11001011000 && ALUOp == 10)begin //sub
			control_line <= 0110;
		end 
		else if (inst31_21 == 10001010000 && ALUOp == 10)begin //and
			control_line <= 0000;
		end 
		else if (inst31_21 == 10101010000 && ALUOp == 10)begin //and
			control_line <= 0001;
		end 
    end
	
end module 
			