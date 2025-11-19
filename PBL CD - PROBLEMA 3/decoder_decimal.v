module decoder_decimal(
    input A, B, C, D,
    output a, b, c, d, e, f, g
);

    wire notA, notB, notC, notD;
    wire xor_CD;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;
    
    // NOTs
    not nA(notA, A);
    not nB(notB, B);
    not nC(notC, C);
    not nD(notD, D);
    
    // XOR
    xor x1(xor_CD, C, D);
    
    // Saída a: ~A ~B ~C D + ~A B ~C ~D
    and a1(w1, notA, notB, notC, D);
    and a2(w2, notA, B, notC, notD);
    or o1(a, w1, w2);
    
    // Saída b: B ~C D + B C ~D
    and a3(w3, B, notC, D);
    and a4(w4, B, C, notD);
    or o2(b, w3, w4);
    
    // Saída c: ~B C ~D
    and a5(c, notB, C, notD);
    
    // Saída d: ~A ~B ~C D + ~A B ~C ~D + ~A B C D
    and a6(w5, notA, notB, notC, D);
    and a7(w6, notA, B, notC, notD);
    and a8(w7, notA, B, C, D);
    or o3(d, w5, w6, w7);
    
    // Saída e: D + B ~C
    and a9(w8, B, notC);
    or o4(e, D, w8);
    
    // Saída f: ~A ~B D + ~A ~B C + ~A C D
    and a10(w9, notA, notB, D);
    and a11(w10, notA, notB, C);
    and a12(w11, notA, C, D);
    or o5(f, w9, w10, w11);
    
    // Saída g: ~A ~B ~C + ~A B C D
    and a13(w12, notA, notB, notC);
    and a14(w13, notA, B, C, D);
    or o6(g, w12, w13);

endmodule