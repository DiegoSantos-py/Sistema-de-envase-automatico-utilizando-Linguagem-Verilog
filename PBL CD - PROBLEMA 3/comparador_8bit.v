module comparador_8bit (
    output equal,
    input [7:0] A,
    input [7:0] B
);
    wire [7:0] xnor_bits;

    xnor (xnor_bits[0], A[0], B[0]);
    xnor (xnor_bits[1], A[1], B[1]);
    xnor (xnor_bits[2], A[2], B[2]);
    xnor (xnor_bits[3], A[3], B[3]);
    xnor (xnor_bits[4], A[4], B[4]);
    xnor (xnor_bits[5], A[5], B[5]);
    xnor (xnor_bits[6], A[6], B[6]);
    xnor (xnor_bits[7], A[7], B[7]);

    and (equal,
         xnor_bits[0], xnor_bits[1], xnor_bits[2], xnor_bits[3],
         xnor_bits[4], xnor_bits[5], xnor_bits[6], xnor_bits[7]);
endmodule

