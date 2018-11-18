module alu_control (inst31_21, ALUOp, control_line);
	input[10:0] inst31_21;
	input[1:0] ALUOp;
	output reg[3:0]control_line;
	
	always @(inst31_21 & ALUOp) begin 
		case(ALUOp)
			2'b00: // LDUR & STUR
				control_line[3:0] <= 4'b0010;
			2'b01: //AND
				control_line[3:0] <= 4'b0111;
			2'b10:
			begin
				case(inst31_21)
					11'b11001011000: //sub
						control_line[3:0] <= 4'b0110;
					11'b10001010000: //and
						control_line[3:0] <= 4'b0000;
					11'b10101010000: //orr
						control_line[3:0] <= 4'b0001;
					default: //add, addi, branch, etc
						control_line[3:0] <= 4'b0010;
				endcase
			end
		endcase
    	end
	
endmodule 
			
