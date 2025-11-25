module main(start, garrafa, sensor_de_nivel, sensor_cq, descarte,
	switch_add_rolha, 
	clk,
	Ev, Ve, Motor, Alarme, Disp, Descarte,
	Displayr_disp, Displayr_estq, Display_duzias
	);
	
	input clk;
	input start, garrafa, sensor_de_nivel, sensor_cq, descarte; // Entradas da MEF_main
	input switch_add_rolha; // Entradas da MEF_dispense
	output Ev, Motor, Descarte; //Saídas da MEF_main
	output Ve, Alarme; // Saídas da MEF_vedacao
	output Disp; // Saídas da MEF_dispenser
	output [13:0]Displayr_disp, Displayr_estq, Display_duzias; // saídas do display
	
	
	
	
	wire clk_system; // Clock com período de 1 segundo
	divisor_frequencia(
   .clk(clk),
   .clk_out(clk_system)
	);
	
	//=================================================================================
	//============================== MEF-Principal ====================================
	//=================================================================================
	
	wire resetar, garrafa_ve, start_cont; // resetar, acionar vedação e acionar contador
	MEF_main(
		.start(start), 
		.garrafa(garrafa), 
		.sensor_de_nivel(sensor_de_nivel),
		.sensor_cq(sensor_cq),
		.descarte(descarte),
		.ve_done(ve_done),
		.cont_done(cont_done),
		.clk(clk_system),
		.reset(1'b0), // tlvz so negar o start ja solucione o reset
		.motor(Motor), 
		.EV(Ev),
		.pos_ve(garrafa_ve), 
		.count(start_cont), 
		.resetar(resetar),
		.Desc_signal(Descarte)
		);

	//=================================================================================
	//============================== MEF-Vedacao ======================================
	//=================================================================================
	
	wire ve_done, rolha_disponivel;
	MEF_vedacao(
		.garrafa(garrafa), 
		.rolha(rolha_disponivel), 
		.pos(garrafa_ve), 
		.clk(clk_system), 
		.reset(resetar), 
		.ve(Ve), // Atuador de vedação 
		.done(ve_done), // Finalizou
		.alarme(Alarme)
	);
		
	//=================================================================================
	//============================== MEF-Dispenser ====================================
	//=================================================================================	
	
	wire tem_5;
	eh_igual5(rolha_disponivel, tem_5);

	MEF_dispenser(
		.switch_add_rolha(switch_add_rolha),
		.rolha5(tem_5),
		.disp(Disp),
		.add_rolha(add_rolha),
		.clk(clk_system),
		.reset(resetar)
	);
	
	//=================================================================================
	//========================== MEF-Contador de Duzias ===============================
	//=================================================================================	
	
	wire wire_cont1, wire_cont12, tem_12, cont_done;
	eh_igual12(wire_cont1, tem_12); // wire_cont1 é a saída do contador normal e tem_12 indica se ja formou uma duzia
	
	wire add_cont1, add_cont12; // add_cont1 = adicionar ao contador normal, add_cont12 = adicionar ao contador de duzias
	
	MEF_contador_duzias(
   .cq(start_count),
   .cont12(tem_12),
   .reset(resetar),
   .clk(clk_system),
   .cont1(add_cont1),
   .add_cont12(add_cont12),
	.cont_done(cont_done)
	);
	
	
	//=================================================================================
	//================================= DISPLAYS ======================================
	//=================================================================================	
	
	//display estoque
	display_decimal display_estoque(estoque, Displayr_estq);

	//display das rolhas disponiveis
	display_decimal display_rolhas_disponiveis(rolha_disponivel, Displayr_disp);

	//display das duzias
	display_decimal display_duzias(wire_cont12, Display_duzias);
	
	
	
endmodule
	