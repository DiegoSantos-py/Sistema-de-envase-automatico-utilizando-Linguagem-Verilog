module teste(clk, reset, switch_add_rolha, qntsrolhas, gar, pos, disp, add_rolha, ve, done, alarme, rolha5, rolha_disponivel, estoque);
	input clk, reset;
	input switch_add_rolha; // entrada da mef do dispenser
	input [7:0]qntsrolhas; // indica quantas rolhas vao estar no estoque
	input gar, pos; // entradas da mef de vedação
	output disp, add_rolha; // saidas da mef do dispenser
	output ve, done, alarme; // saidas da mef da vedacao
	output rolha5;
	output [7:0] estoque, rolha_disponivel;
	
	wire [7:0] saida, saida_estoque;
	register_8bit estoq(qntsrolhas, clk, estoque, reset);
	
	wire cout;
	muxdisp(8'b00000000, estoque, disp, saida_estoque);
	sum8bit(cout, saida, rolha_disponivel, saida_estoque);
	register_8bit dispo(saida, clk, rolha_disponivel, reset);
	
	//wire rolha5;
	eh_igual5(rolha_disponivel, rolha5);
	
	wire r;
	or (r, rolha_disponivel[0], rolha_disponivel[1], rolha_disponivel[2], rolha_disponivel[3], rolha_disponivel[4], rolha_disponivel[5], rolha_disponivel[6], rolha_disponivel[7]);
	
	// MEF_vedacao
	MEF_vedacao(
	.garrafa(gar), 
	.rolha(r), 
	.pos(pos), 
	.clk(clk), 
	.reset(reset), 
	.ve(ve), 
	.done(done), 
	.alarme(alarme));
	
	MEF_dispenser(
	.switch_add_rolha(switch_add_rolha),
	.rolha5(rolha5),
	.disp(disp),
	.add_rolha(add_rolha),
	.clk(clk),
	.reset(reset)
	);
	
	

endmodule

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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	