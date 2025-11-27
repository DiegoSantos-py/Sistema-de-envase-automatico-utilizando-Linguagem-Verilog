module teste1(clk, reset, switch_add_rolha, qntsrolhas, gar, pos, disp, add_rolha, ve, done, alarme, rolha5, rolha_disponivel, estoque,
 pode_repor, whatever_is_available, tem_15, dispenser);
 
	input clk, reset;
	input switch_add_rolha; // entrada da mef do dispenser
	input [7:0]qntsrolhas; // indica quantas rolhas vao estar no estoque
	input gar, pos; // entradas da mef de vedação
	output disp, add_rolha; // saidas da mef do dispenser
	output ve, done, alarme; // saidas da mef da vedacao
	output rolha5, pode_repor, tem_15, dispenser;
	output [7:0] estoque, rolha_disponivel, whatever_is_available;
	
	wire [7:0] saida, saida_estoque;
	wire not_done;
	
	not (not_done, done);
	//register_8bit estoq(qntsrolhas, clk, estoque, reset);
	
	wire cout;
	//wire [7:0]whatever_is_available, rolha_disponivel;
	wire sel_repor;
	ehmaior_15(qntsrolhas, tem_15); // eh 0 quando é menor que 15
	muxdisp(qntsrolhas, 8'b00001111, tem_15, whatever_is_available); // A, B, en, out
	
	wire clk_repo;
	mux2x1(sel_repor, done, disp, disp);
	sum8bit(cout, saida, rolha_disponivel, whatever_is_available);
	//level_to_pulse(sel_repor, clk, pode_repor);
	and (pode_repor, clk, sel_repor);
	
	wire dispenser;
	and (dispenser, not_done, disp);
	contador_disp reposicao(.clk(pode_repor),.reset(reset),.up_down(not_done),.load(dispenser),.data(whatever_is_available),.count(rolha_disponivel));
	
	//estoque
	wire[7:0]atualizar_estoque;
	wire not_disp, bout;
	not (not_disp, disp);
	//contador estq(.clk(add_rolha),.reset(reset),.up_down(not_disp),.load(disp),.data(saida_estoque),.count(estoque));
	//sub8bit(bout, atualizar_estoque, estq, 1'b0, 1'b0); //bout, s, a, b, bin
	
	//wire rolha5;
	eh_igual5(rolha_disponivel, rolha5);
	
	wire r;
	or (r, rolha_disponivel[0], rolha_disponivel[1], 
	rolha_disponivel[2], rolha_disponivel[3], 
	rolha_disponivel[4], rolha_disponivel[5], 
	rolha_disponivel[6], rolha_disponivel[7]);
	
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
	
	// MEF_dispenser
	MEF_dispenser(
	.switch_add_rolha(switch_add_rolha),
	.rolha5(rolha5),
	.disp(disp),
	.add_rolha(add_rolha),
	.clk(clk),
	.reset(reset)
	);

endmodule


	
	
module teste2(start, garrafa, sensor_de_nivel, sensor_cq, ve_done,  resetar, clk, cont_done, wire_cont1, wire_cont12, tem_12, Motor, start_cont, Ev, garrafa_ve, alarme, r, ve, done);
	input resetar, clk, r;
	input start, garrafa, sensor_de_nivel, sensor_cq, ve_done;
	output cont_done, tem_12, start_cont, Motor;
	output [7:0] wire_cont1, wire_cont12;
	output Ev, garrafa_ve, alarme, ve, done;

	wire tem_12;
	eh_igual12(wire_cont1, tem_12); // wire_cont1 é a saída do contador normal e tem_12 indica se ja formou uma duzia
	
	wire add_cont1, add_cont12; // add_cont1 = adicionar ao contador normal, add_cont12 = adicionar ao contador de duzias
	
	MEF_contador_duzias(
   .cq(start_cont),
   .cont12(tem_12),
   .reset(resetar),
   .clk(clk),
   .cont1(add_cont1),
   .add_cont12(add_cont12),
	.cont_done(cont_done)
	);
	
	contador2 (add_cont1, add_cont12, 1'b1, 1'b1, wire_cont1);
	contador2 (add_cont12, reset_atrasado, 1'b1, 1'b1, wire_cont12);
	
	wire ncont0, ncont2, reset_cont12;
	not (ncont0, wire_cont12[0]);
	not (ncont2, wire_cont12[2]);
	
	
	wire reset_atrasado;
	d_flipflop dff0 (.q(reset_atrasado), .d(reset_cont12), .reset(resetar), .clk(clk));
	and (reset_cont12,wire_cont12[3], ncont2, wire_cont12[1], ncont0);
	
	MEF_main(
		.start(start), 
		.garrafa(garrafa), 
		.sensor_de_nivel(sensor_de_nivel),
		.sensor_cq(sensor_cq),
		.descarte(descarte),
		.ve_done(ve_done),
		.cont_done(cont_done),
		.clk(clk),
		.reset(1'b0), // tlvz so negar o start ja solucione o reset
		.motor(Motor), 
		.EV(Ev),
		.pos_ve(garrafa_ve), 
		.count(start_cont), 
		.resetar(reset),
		.Desc_signal(descarte)
		);
		
		
	MEF_vedacao(
		.garrafa(garrafa), 
		.rolha(r), 
		.pos(garrafa_ve), 
		.clk(clk), 
		.reset(1'b0), 
		.ve(ve), 
		.done(done), 
		.alarme(alarme));
endmodule
	
	
	
module teste(Alarme, motor_signal, clk, cq_signal, Motor);
	input motor_signal, clk, cq_signal, Alarme;
	output Motor;
		
	wire not_alarme, w_and1, w_and2, only_and2;
	not (not_alarme, Alarme);
	and (w_and1, not_alarme, motor_signal);
	and (w_and2, not_alarme, cq_signal);
	level_to_pulse (w_and2, clk, only_and2);
	or  (Motor, w_and1, only_and2);
endmodule
	
	
	
	
	
	
	
	