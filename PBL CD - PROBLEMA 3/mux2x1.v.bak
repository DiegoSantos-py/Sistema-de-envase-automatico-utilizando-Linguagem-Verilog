module mux2x1(out, in0, in1, sel);
    input in0, in1, sel;
    output out;
    
    wire w1, w2, w3;
    
    not (w3, sel);
    and (w1, in0, w3);
    and (w2, in1, sel);
    or  (out, w1, w2);
endmodule
