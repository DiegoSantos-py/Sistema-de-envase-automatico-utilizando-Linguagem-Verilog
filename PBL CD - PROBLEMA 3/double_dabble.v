module eh_maior5(A, B, C, D, out);
	input A, B, C, D;
	output out;
	
	wire w1, w2;
	and(w1, A, C);
	and(w2, B, C);
	or(out, D, w1, w2);
	
endmodule

module double_dabble(A, out);
	input [3:0] A;
	output [3:0] out;
	
	wire [3:0]sum;
	wire Cout;
	wire m5; // maior que 5
	eh_maior5(A[0], A[1], A[2], A[3], m5);
	
	sum4bit(Cout, sum, A, 4'b0011, 1'b0);
	
	mux2x1(out[0],A[0], sum[0], m5);
	mux2x1(out[1],A[1], sum[1], m5);
	mux2x1(out[2],A[2], sum[2], m5);
	mux2x1(out[3],A[3], sum[3], m5);
	
endmodule


	
	