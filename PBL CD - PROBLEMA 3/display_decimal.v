module display_decimal(A, out);
	input [12:0]A;
	output [27:0] out;
	
	wire [3:0] db1, db2, db3, db4, db5, db6, db7, db8, db9, db10, db11, db12;
	
	double_dabble db001({3'b000, A[12]}, db1);
	double_dabble db002({db1[2], db1[1], db1[0],A[11]}, db2);
	double_dabble db003({db2[2], db2[1], db2[0],A[10]}, db3);
	double_dabble db004({db3[2], db3[1], db3[0],A[9]}, db4);
	double_dabble db005({db4[2], db4[1], db4[0],A[8]}, db5);
	double_dabble db006({db5[2], db5[1], db5[0],A[7]}, db6);
	double_dabble db007({db6[2], db6[1], db6[0],A[6]}, db7);
	double_dabble db008({db7[2], db7[1], db7[0],A[5]}, db8);
	double_dabble db009({db8[2], db8[1], db8[0],A[4]}, db9);
	double_dabble db0010({db9[2], db9[1], db9[0],A[3]}, db10);
	double_dabble db0011({db10[2], db10[1], db10[0],A[2]}, db11);
	double_dabble db0012({db11[2], db11[1], db11[0],A[1]}, db12);

	wire [3:0] db2_1, db2_2, db2_3, db2_4, db2_5, db2_6, db2_7, db2_8, db2_9, db2_10, db2_11;
	
	double_dabble db002_1({3'b000, db1[3]}, db2_1);
	double_dabble db002_2({db2_1[2], db2_1[1],db2_1[0], db2[3]}, db2_2);
	double_dabble db002_3({db2_2[2], db2_2[1],db2_2[0], db3[3]}, db2_3);
	double_dabble db002_4({db2_3[2], db2_3[1],db2_3[0], db4[3]}, db2_4);
	double_dabble db002_5({db2_4[2], db2_4[1],db2_4[0], db5[3]}, db2_5);
	double_dabble db002_6({db2_5[2], db2_5[1],db2_5[0], db6[3]}, db2_6);
	double_dabble db002_7({db2_6[2], db2_6[1],db2_6[0], db7[3]}, db2_7);
	double_dabble db002_8({db2_7[2], db2_7[1],db2_7[0], db8[3]}, db2_8);
	double_dabble db002_9({db2_8[2], db2_8[1],db2_8[0], db9[3]}, db2_9);
	double_dabble db002_10({db2_9[2], db2_9[1],db2_9[0], db10[3]}, db2_10);
	double_dabble db002_11({db2_10[2], db2_10[1],db2_10[0], db11[3]}, db2_11);
	
	decoder_decimal(db12[2], db12[1], db12[0], A[0], out[0], out[1], out[2], out[3], out[4], out[5], out[6]);
	decoder_decimal(db2_11[2], db2_11[1], db2_11[0], db12[3], out[7], out[8], out[9], out[10], out[11], out[12], out[13]);
	
endmodule


