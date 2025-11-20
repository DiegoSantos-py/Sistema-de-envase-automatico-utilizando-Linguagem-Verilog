module eh_igual5(in,out);
	input [7:0]in;
	output out;
	
	wire [6:0]not_in;
	
	// Nega todos menos os bits 0 e 2
	not (not_in[1], in[1]);
	not (not_in[2], in[2]);
	not (not_in[3], in[3]);
	not (not_in[4], in[4]);
	not (not_in[5], in[5]);
	not (not_in[6], in[6]);
	
	wire w1;
	
	or (w1, not_in[1], not_in[2]);
	
	and (out, w1, not_in[3], not_in[4], not_in[5], not_in[6]);
	
endmodule

