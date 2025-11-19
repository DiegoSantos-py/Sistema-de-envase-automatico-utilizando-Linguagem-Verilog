module eh_igual5(in,out);
	input [7:0]in;
	output out;
	
	wire [7:0]not_in;
	
	// Nega todos menos os bits 0 e 2
	not (not_in[1], in[1]);
	not (not_in[3], in[3]);
	not (not_in[4], in[4]);
	not (not_in[5], in[5]);
	not (not_in[6], in[6]);
	not (not_in[7], in[7]);
	
	and (out, in[0], not_in[1], in[2], not_in[3], not_in[4], not_in[5], not_in[6], not_in[7]);
	
endmodule

