
/*ID/EX HAZARDS
ForwardA = 00 	ID/EX	The first ALU operand comes from the register file.
ForwardB = 00	ID/EX 	The second ALU operand comes from the register file. 
	 */

/*Purpose:  Deal with data hazards
pass the ALU output from one instruction to the other
without going through the register file or waiting on WRITE BACK */

/*Intention:
Use this code in the EXECUTION stage where the ALU is
Take ALU result from pipline register and forward that value to subsequent instructions

IF NO HAZARD DETECTED: ALU operand will come from register file like normal
IF THERE IS A HAZARD: Operands will come from EX/MEM or MEM/WB pipeline registers instead
*/

/*    RD : destination register
	  RS : first source register
      RT : second source register */
module DataForwarding(EX_MEMregwrite, EX_MEMregRD,ID_EXregRS, ID_EXregRT,
					  MEM_WBregwrite, MEM_WBregRD ); //come from ALU result
	/*data forwarding unit has several control signals as inputs:
		ID/EX registerRS	EX/MEM registerRD	MEM/WB registerRD
		ID/EX registerRT						
	*/
	/*Also has 2 regWrite signals that come from control unit:
		EX/MEM regWrite 	MEM/WB regWrite
	*/
	input EX_MEMregwrite; //double check sizes for ach one
	input MEM_WBregwrite;
	input[31:0] EX_MEMregRD; 
	input[31:0] ID_EXregRS;
	input[31:0] ID_EXregRT;

	input[31:0] MEM_WBregRD;
	
	//2 bit MUX each Control signals
	output[1:0] ForwardA; //first ALU operand
	output[1:0] ForwardB; //second ALU operand
	
//for EX/MEM data hazard
	if(EX_MEMregwrite == 1)
	begin
		//if true, the first ALU operand comes from the prior ALU result.
		if(EX_MEMregRD == ID_EXregRS) 
			assign ForwardA = 2'b10;
		//if true, the second ALU operand comes from the prior ALU result. 
		if(EX_MEMregRD == ID_EXregRT) 
			assign ForwardB = 2'b10;
	end
	
//for MEM/WB hazards
	if( MEM_WBregwrite == 1 )
	begin
		//The first ALU operand comes from data memory or an early ALU result. 
		if( (MEM_WBregRD == ID_EXregRS) 
		&& ( EX_MEMregRD != ID_EXregRS || EX_MEMregwrite == 0) )
			assign ForwardA = 2'b1;
		//The second ALU operand comes from data memory or an early ALU result.
		if( (MEM_WBregRD == ID_EXregRT) 
		&& (EX_MEMregRD != ID_EXregRT || EX_MEMregwrite == 0) )
			assign ForwardB = 2'b1;
	end 

endmodule
