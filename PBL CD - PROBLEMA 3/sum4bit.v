module sum4bit(Cout, S, A, B, C); 
	input [3:0]A; 
	input [3:0]B; 
	input C;
	output Cout; 
	output [3:0]S; 
	wire [2:0]Co; 
	sum somador1(Co[0], S[0], A[0], B[0], C); 
	sum somador2(Co[1], S[1], A[1], B[1], Co[0]); 
	sum somador3(Co[2], S[2], A[2], B[2], Co[1]); 
	sum somador4(Cout, S[3], A[3], B[3], Co[2]); 
endmodule


module sum(Cout, S, A, B, C);
	input A, B, C;
	output Cout, S;
	wire f1, f2, f3;
	
	xor (f1, A, B);
	xor (S, C, f1);
	and (f2, A, B);
	and (f3, f1, C);
	or (Cout, f3, f2);
	
endmodule