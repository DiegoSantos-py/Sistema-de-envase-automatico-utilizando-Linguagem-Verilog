module MEF_vedacao(
	input garrafa, 
	input rolha, 
	input pos, 
	input clk, 
	input reset, 
	output ve, 
	output done, 
	output alarme);
	
	reg [1:0]state, nextstate;
	
	parameter V0 = 2'b00;
	parameter V1 = 2'b01; //vedou
	parameter AL = 2'b10; //alarme
	
	always @(posedge clk, posedge reset)
		if (reset) state <= V0;
		else state <= nextstate;
			
	always @(*)
		case(state)
			V0: 
				if (rolha == 0)
					nextstate = AL;
				else if (garrafa == 1 && pos == 1 && rolha == 1)
					nextstate = V1;
				else 
					nextstate = V0;
			V1:
				if (rolha == 0)
					nextstate = AL;
				else
					nextstate = V0;
			AL:
				if (rolha == 1 && garrafa == 0 && pos == 0)
					nextstate = V0;
				else if (rolha == 1 && garrafa == 0 && pos == 1)
					nextstate = V0;
				else if (rolha == 1 && garrafa == 1 && pos == 1)
					nextstate = V1;
				else
					nextstate = AL;
		endcase
	
	//saida_vedacao(
	//.state(state), 
	//.alarme(alarme), 
	//.ve(ve), 
	//.done(done));
	
	assign ve = (state == V1);
	assign done = (state == V1);
	assign alarme = (state == AL);
	
endmodule

module saida_vedacao(state, alarme, ve, done);
	input [1:0]state;
	output alarme, ve, done;
	
	 wire ne0;
    wire ne1;
		
	 not (ne0,state[0]);
	 not (ne1,state[1]);
	 
	 and (ve, ne1, state[0]); //01
	 and (done, ne1, state[0]);
	 and (alarme, state[1], ne0);
	 
endmodule