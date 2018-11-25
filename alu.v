/*=======================================================
 Name: Hajar Wahman				  Panther-ID: x x x - 8482
	   Neilivet Linares  		  Panther-ID: x x x - 0185
	   Vanessa Velez-Santos		  Panther-ID: x x x - 9302
 
 Course: CDA 4101
 
 Project#: 4
 
 Due: Tue, Nov 6, 2018
 
 I hereby certify that this work is my own and na of
 it is the work of any other person.
 
 Signature: ______________________
			_________________________
			_________________________
 =========================================================*/
module alu(a, b,opcode,out);
input [31:0] a, b;
input [9:0] opcode; //10 bit opcode
output [31:0] out;

//inputs are in the sensitivity list
always @(opcode or a or b)
    begin
        case (opcode) //depending on the opcode passed in
		 10'b0000 : out = a & b;  //AND function
         10'b0010 : out = a + b;  //add function
         10'b0110 : out = a - b; //subtraction             
         10'b0001 : out = a | b;  //OR gate
		 default  : out = 0;
        endcase 
    end
endmodule