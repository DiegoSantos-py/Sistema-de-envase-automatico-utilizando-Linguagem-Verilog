module main(start, garrafa, sensor_de_nivel, sensor_cq, switch_descarte,
	switch_add_rolha, 
	clk_system,
	Ev, Ve, Motor, Alarme, Disp, Descarte,
	Displayr_disp, Displayr_estq, Display_duzias,
	estaemcq
	);
	
	input clk_system;
	input start, garrafa, sensor_de_nivel, sensor_cq, switch_descarte; // Entradas da MEF_main
	input switch_add_rolha; // Entradas da MEF_dispense
	output Ev, Motor, Descarte; //Saídas da MEF_main
	output Ve, Alarme; // Saídas da MEF_vedacao
	output Disp, estaemcq; // Saídas da MEF_dispenser
	output [13:0]Displayr_disp, Displayr_estq, Display_duzias; // saídas do display
	
	//wire clk_system; // Clock com período de 1 segundo
	divisor_frequencia(
   .clk(clk_system),
   .clk_out(clk)
	);
	
	//=================================================================================
	//============================== MEF-Principal ====================================
	//=================================================================================
	
	wire motor_signal, cq_signal, wire_estaemcq;
	wire resetar, garrafa_ve, start_cont; // resetar, acionar vedação e acionar contador
	MEF_main(
		.start(start), 
		.garrafa(garrafa), 
		.sensor_de_nivel(sensor_de_nivel),
		.sensor_cq(sensor_cq),
		.descarte(switch_descarte),
		.ve_done(ve_done),
		.cont_done(cont_done),
		.alarme(Alarme),
		.clk(clk),
		.reset(1'b0), // tlvz so negar o start ja solucione o reset
		.motor(motor_signal), 
		.EV(Ev),
		.pos_ve(garrafa_ve),
		.controle_qualidade(cq_signal),
		.pos_cq(wire_estaemcq),
		.count(start_cont), 
		.resetar(resetar),
		.Desc_signal(Descarte)
		);
		
		
	// Lógica de saída do sinal do motor
	wire not_alarme, w_and1, w_and2, only_and2;
	not (not_alarme, Alarme);
	and (w_and1, not_alarme, motor_signal);
	and (w_and2, not_alarme, cq_signal);
	level_to_pulse (w_and2, clk, only_and2);
	or  (Motor, w_and1, only_and2);
	
	d_flipflop b0(.q(estaemcq), .d(wire_estaemcq), .reset(reset), .clk(clk));
	
	//=================================================================================
	//============================== MEF-Vedacao ======================================
	//=================================================================================
	
	wire rolhas;
	or (rolhas, rolhas_disponiveis[0], rolhas_disponiveis[1], rolhas_disponiveis[2], rolhas_disponiveis[3], rolhas_disponiveis[4], rolhas_disponiveis[5], rolhas_disponiveis[6], 
	rolhas_disponiveis[7]);
	wire ve_done, rolha_disponivel;
	MEF_vedacao(
		.garrafa(garrafa_ve), 
		.rolha(rolhas), 
		.pos(garrafa_ve), 
		.clk(clk), 
		.reset(resetar), 
		.ve(Ve), // Atuador de vedação 
		.done(ve_done), // Finalizou
		.alarme(teste1)
	);
	
	wire [7:0]rolhas_estoque, rolhas_disponiveis, teste;
	wire teste1, teste2;
	
	estoque (
	.clk(clk),
	.reset(resetar),
	.done(ve_done),             
	.add_rolha(add_rolha),        
	.CONTAGEM_ROLHAS_ESTOQUE(rolhas_estoque), 
	.CONTAGEM_ROLHAS_LINHA(rolhas_disponiveis),   
	.ACIONAR_DISPENSER(teste2),          
	.VALOR_SAIDA_ESTOQUE(teste), 
	.ALERTA_ESTOQUE_BAIXO(Alarme)          
);

		
	//=================================================================================
	//============================== MEF-Dispenser ====================================
	//=================================================================================	
	
	wire tem_5, add_rolha;
	eh_igual5(rolhas_disponiveis, tem_5);

	MEF_dispenser(
		.switch_add_rolha(switch_add_rolha),
		.rolha5(tem_5),
		.disp(Disp),
		.add_rolha(add_rolha),
		.clk(clk),
		.reset(resetar)
	);
	
	//=================================================================================
	//========================== MEF-Contador de Duzias ===============================
	//=================================================================================	
	
	wire tem_12, cont_done;
	wire [7:0] wire_cont1, wire_cont12;
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
	
	contador2 contador_unidades(add_cont1, reset_contador_unidades, 1'b1, 8'b00000001, wire_cont1);
	contador2 contador_duzias(add_cont12, reset_atrasado, 1'b1, 8'b00000001, wire_cont12);
	
	wire ncont0, ncont2, reset_cont12;
	not (ncont0, wire_cont12[0]);
	not (ncont2, wire_cont12[2]);
	
	wire reset_atrasado, reset_contador_duzias, reset_contador_unidades;
	and (reset_cont12,wire_cont12[3], ncont2, wire_cont12[1], ncont0); //reseta quando chega em 10 (1010)
	d_flipflop dff0 (.q(reset_contador_duzias), .d(reset_contador_duzias), .reset(resetar), .clk(clk));
	
	// Lógica de reset dos contadores
	
	// Reseta quando chega em 10 dúzias ou quando a mef main envia o sinal para resetar
	or (reset_atrasado, reset_contador_duzias, resetar); 
	// Reseta quando doze garrafas passaram no cq ou quando a mef main envia o sinal para resetar
	or (reset_contador_unidades, add_cont12, resetar);
	
	//=================================================================================
	//================================= DISPLAYS ======================================
	//=================================================================================	
	
	//display estoque
	display_decimal display_estoque(rolhas_estoque, Displayr_estq);

	//display das rolhas disponiveis
	display_decimal display_rolhas_disponiveis(rolhas_disponiveis, Displayr_disp);

	//display das duzias
	display_decimal display_duzias(wire_cont12, Display_duzias);
	
	
	
endmodule
	