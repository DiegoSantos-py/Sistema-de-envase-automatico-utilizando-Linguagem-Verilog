module mux2x1(out, in0, in1, sel);
    input in0, in1, sel;
    output out;
    
    wire w1, w2, w3;
    
    not (w3, sel);
    and (w1, in0, w3);
    and (w2, in1, sel);
    or  (out, w1, w2);
endmodule


module muxdisp(A, B, en, out);
	input [7:0] A, B;
	input en;
	output [7:0]out;
	
	wire [7:0]outw1, outw2;
	wire nen;
	not(nen, en);
	
	and (outw1[0], A[0], nen);
	and (outw1[1], A[1], nen);
	and (outw1[2], A[2], nen);
	and (outw1[3], A[3], nen);
	and (outw1[4], A[4], nen);
	and (outw1[5], A[5], nen);
	and (outw1[6], A[6], nen);
	and (outw1[7], A[7], nen);
	
	and (outw2[0], B[0], en);
	and (outw2[1], B[1], en);
	and (outw2[2], B[2], en);
	and (outw2[3], B[3], en);
	and (outw2[4], B[4], en);
	and (outw2[5], B[5], en);
	and (outw2[6], B[6], en);
	and (outw2[7], B[7], en);	
	
	or (out[0], outw1[0], outw2[0]);
	or (out[1], outw1[1], outw2[1]);
	or (out[2], outw1[2], outw2[2]);
	or (out[3], outw1[3], outw2[3]);
	or (out[4], outw1[4], outw2[4]);
	or (out[5], outw1[5], outw2[5]);
	or (out[6], outw1[6], outw2[6]);
	or (out[7], outw1[7], outw2[7]);
	
endmodule

module mux_8(A, B, out);
	input [7:0] A, B;
	output [7:0]out;
	
	wire [7:0]outw1, outw2;
	wire nen;
	not(nen, en);
	
	and (outw1[0], A[0]);
	and (outw1[1], A[1]);
	and (outw1[2], A[2]);
	and (outw1[3], A[3]);
	and (outw1[4], A[4]);
	and (outw1[5], A[5]);
	and (outw1[6], A[6]);
	and (outw1[7], A[7]);
	
	and (outw2[0], B[0]);
	and (outw2[1], B[1]);
	and (outw2[2], B[2]);
	and (outw2[3], B[3]);
	and (outw2[4], B[4]);
	and (outw2[5], B[5]);
	and (outw2[6], B[6]);
	and (outw2[7], B[7]);	
	
	or (out[0], outw1[0], outw2[0]);
	or (out[1], outw1[1], outw2[1]);
	or (out[2], outw1[2], outw2[2]);
	or (out[3], outw1[3], outw2[3]);
	or (out[4], outw1[4], outw2[4]);
	or (out[5], outw1[5], outw2[5]);
	or (out[6], outw1[6], outw2[6]);
	or (out[7], outw1[7], outw2[7]);
	
endmodule