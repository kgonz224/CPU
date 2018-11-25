
 
 module mux( select, a, b, out);
	input [4:0] a, b;
	input select;
	output [4:0] out;
	wire [4:0] out;
	
	assign out[0] = (~select & a[0]) | (select & b[0]);
	assign out[1] = (~select & a[1]) | (select & b[1]);
	assign out[2] = (~select & a[2]) | (select & b[2]);
	assign out[3] = (~select & a[3]) | (select & b[3]);
	assign out[4] = (~select & a[4]) | (select & b[4]);
endmodule
