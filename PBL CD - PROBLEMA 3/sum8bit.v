module sum8bit(Cout, S, A, B);
	input [7:0]A;
	input [7:0]B;
	output Cout;
	output [7:0]S;
	
	wire [6:0]Co;
	wire [7:0]s;

	sum somador1(Co[0], S[0], A[0], B[0], 1'b0);
	sum somador2(Co[1], S[1], A[1], B[1], Co[0]);
	sum somador3(Co[2], S[2], A[2], B[2], Co[1]);
	sum somador4(Co[3], S[3], A[3], B[3], Co[2]);
	sum somador5(Co[4], S[4], A[4], B[4], Co[3]);
	sum somador6(Co[5], S[5], A[5], B[5], Co[4]);
	sum somador7(Co[6], S[6], A[6], B[6], Co[5]);
	sum somador8(Cout, S[7], A[7], B[7], Co[6]);

endmodule