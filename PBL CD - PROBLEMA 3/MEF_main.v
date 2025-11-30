module MEF_principal(
		input start, 
		input garrafa, 
		input sensor_de_nivel,
		input sensor_cq,
		input descarte,
		input ve_done,
		input cont_done,
		input clk,
		input reset,
		output motor, 
		output EV,
		output pos_ve, // garrafa em posição de vedação
		output count, // sinal para ativar mef do contador
		output resetar,
		output Desc_signal,
		output controle_qualidade,
		output pos_cq
		);
		
		reg[2:0]state, nextstate;
		
		parameter SR = 3'b000; // Start/reset
		parameter Mo = 3'b001; // Motor
		parameter En = 3'b010; // Enchimento
		parameter Vd = 3'b011; // Vedação
		parameter Cq = 3'b100; // Controle de qualidade
		parameter Co = 3'b101; // Contador
		parameter De = 3'b110; // Descarte
		
		always @ ( posedge clk , posedge
		reset )
			if ( reset ) state <= SR ;
			else state <= nextstate ;
			
		always @(*)
			case(state)
				SR:
					nextstate = Mo;
				Mo:
					if (start == 0)
						nextstate = SR;
					else if (garrafa == 1)
						nextstate = En;
					else
						nextstate = Mo;
				En:
					if (start == 0)
						nextstate = SR;
					else if (sensor_de_nivel == 1) 
						nextstate = Vd;
					else
						nextstate = En;
				Vd:
					if (start == 0)
						nextstate = SR;
					else if (ve_done == 1)
						nextstate = Cq;
					else
						nextstate = Vd;
				Cq:
					if (start == 0)
						nextstate = SR;
					else if (sensor_cq == 1)
						nextstate = Co;
					else if (descarte == 1)
						nextstate = De;
					else
						nextstate = Cq;
				Co:
					if (start == 0)
						nextstate = SR;
					else if (cont_done == 1)
						nextstate = Mo;
					else
						nextstate = Co;
				De:
					nextstate = Mo;
				default:
                nextstate = SR;
			endcase
		
		saida_mef_principal(
		.state(state),
		.motor(motor), 
		.EV(EV),
		.pos_ve(pos_ve), 
		.count(count),
		.resetar(resetar),
		.Desc_signal(Desc_signal),
		.controle_qualidade(controle_qualidade),
		.pos_cq(pos_cq));
		

endmodule


module saida_mef_principal(
		input [2:0]state,
		output motor, 
		output EV,
		output pos_ve, 
		output count,
		output resetar,
		output Desc_signal,
		output controle_qualidade,
		output pos_cq);

	
	 wire [2:0]nstate;
		
	 not (nstate[0],state[0]);
	 not (nstate[1],state[1]);
	 not (nstate[2],state[2]);

	 
	 and (resetar, nstate[2], nstate[1], nstate[0]);                  //000
	 and (motor, nstate[2], nstate[1], state[0]);                     //001
	 and (EV, nstate[2], state[1], nstate[0]);                        //010
	 and (pos_ve, nstate[2], state[1], state[0]);                     //011
	 and (pos_cq, state[2], nstate[1], nstate[0]);                    //100
	 and (controle_qualidade, state[2], nstate[1], nstate[0]);        //100
	 and (count, state[2], nstate[1], state[0]);                      //101
	 and (Desc_signal, state[2], state[1], nstate[0]);                //110  

	 
endmodule