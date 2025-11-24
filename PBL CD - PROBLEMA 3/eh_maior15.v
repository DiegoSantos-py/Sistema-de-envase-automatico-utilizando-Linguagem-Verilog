module ehmaior_15(in, out);
	input [7:0]in;
	output out;
	
	wire w1;
	
	and(w1, in[0], in[1], in[2], in[3]);
	or(out, w1, in[4], in[5], in[6],in[7]);
	
endmodule