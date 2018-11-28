module ForwardingUnit(Reg1, Reg2, Reg3Mem, Reg3WB, RegWriteMem, RegWriteWB,
       	ForwardA, ForwardB, clk);

	input [4:0] Reg1, Reg2, Reg3Mem, Reg3WB;
	input RegWriteMem, RegWriteWB, clk;
	output reg [1:0] ForwardA, ForwardB;

	always@(posedge clk)
	begin
		#2
		//ForwardA
		if ((RegWriteMem == 1) && ~(Reg3Mem == {5{1'b1}})
			&& (Reg3Mem == Reg1))
		begin
			ForwardA = 2'b10;
		end
		else if((RegWriteWB == 1) && (~(Reg3WB == {5{1'b1}}))
		        && ~(RegWriteMem && ~(Reg3Mem == {5{1'b1}})
	       		&& (Reg3Mem == Reg1)) && (Reg3WB == Reg1))
		begin
			ForwardA = 2'b01;
		end
		else
			ForwardA = 2'b00;

		//ForwardB
		if ((RegWriteMem == 1) && ~(Reg3Mem == {5{1'b1}})
                        && (Reg3Mem == Reg2))
                begin
                        ForwardB = 2'b10;
                end
		else if((RegWriteWB == 1) && (~(Reg3WB == {5{1'b1}}))
                        && ~(RegWriteMem && ~(Reg3Mem == {5{1'b1}})
                        && (Reg3Mem == Reg2)) && (Reg3WB == Reg2))
		begin
			ForwardB = 2'b01;
		end
		else
			ForwardB = 2'b00;

	end
endmodule


