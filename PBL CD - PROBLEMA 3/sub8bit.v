module sub8bit(bout, S, A, B, bin);
	input [7:0]A;
	input [7:0]B;
	input bin;
	output bout;
	output [7:0]S;
	
	wire f1, f2, f3, f4, f5, f6, f7;
	wire [7:0] S_internal;
	
	// Subtrator normal
	sub sub1(S_internal[0], A[0], B[0], bin, f1);
	sub sub2(S_internal[1], A[1], B[1], f1, f2);
	sub sub3(S_internal[2], A[2], B[2], f2, f3);
	sub sub4(S_internal[3], A[3], B[3], f3, f4);
	sub sub5(S_internal[4], A[4], B[4], f4, f5);
	sub sub6(S_internal[5], A[5], B[5], f5, f6);
	sub sub7(S_internal[6], A[6], B[6], f6, f7);
	sub sub8(S_internal[7], A[7], B[7], f7, bout);
	
	wire nbout;
	not(nbout, bout);
	
	and and0(S[0], S_internal[0], nbout);
	and and1(S[1], S_internal[1], nbout);
	and and2(S[2], S_internal[2], nbout);
	and and3(S[3], S_internal[3], nbout);
	and and4(S[4], S_internal[4], nbout);
	and and5(S[5], S_internal[5], nbout);
	and and6(S[6], S_internal[6], nbout);
	and and7(S[7], S_internal[7], nbout);
	
endmodule

module sub(S, A, B, bin, bout);
	input A, B, bin;
	output S, bout;
	wire nota, f1, f2, f3;
	
	not (nota, A);
	and and0(f1, B, bin);
	and and1(f2, nota, f3);
	xor xor0(f3, B, bin);
	xor xor1(S, A, f3);
	or or0(bout, f1,f2);
	
endmodule