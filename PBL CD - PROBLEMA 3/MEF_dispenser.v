module MEF_dispenser(
	input switch_add_rolha, 
	input rolha5, 
	input clk,
	input reset,
	output disp, 
	output add_rolha
);

	reg[1:0]state, nextstate;
   parameter E0   = 2'b00;
   parameter DISP = 2'b01;
   parameter ADD1 = 2'b10;
   parameter ADD2 = 2'b11;
	
	always @(posedge clk, posedge reset)
		if (reset) state <= E0;
      else state <= nextstate;

	 // Lógica de próximo estado
	always @(*) 
		 case(state)

			  E0:
					if (rolha5 == 1 && switch_add_rolha == 0)
						nextstate = DISP;
					else if (switch_add_rolha == 1)
						nextstate = ADD1;
					else
						nextstate = E0;

			  DISP:
					if (switch_add_rolha == 1)
						nextstate = ADD1;
					else if (rolha5 == 1)
						 nextstate = DISP;            
					else if (rolha5 == 0)
						 nextstate = E0;          // Continua dispensando

			  ADD1:
					if (rolha5 == 1 && switch_add_rolha == 0)
						 nextstate = E0;            // Depósito cheio -> volta
					else if (rolha5 == 0 && switch_add_rolha == 0)
						nextstate = E0;
					else
						 nextstate = ADD2;          // Próximo estágio de adição

			  ADD2:
					if (rolha5 == 0 && switch_add_rolha == 0)
						 nextstate = E0;            // Cheio -> volta
					else if (rolha5 == 1 && switch_add_rolha == 0)
						 nextstate = E0;          // Novo pulso para continuar
					else
						 nextstate = ADD1;          // Mantém

			  default:
					nextstate = E0;

		 endcase
		 

	
 	saidas_dispenser logic_out (
      .state(state),
      .disp(disp),
      .add_rolha(add_rolha)
  );
	
	
endmodule


module saidas_dispenser (
    input  [1:0]state,      // bits do estado
    output disp,
    output add_rolha
);

    wire nb1, nb0;
	 
	 // NOT do bit b0
	 not (nb0, state[0]);

    // NOT do bit b1
    not (nb1, state[1]);

    // DISP = (~b1 & b0)
    and (disp, nb1, state[0]);

    and (add_rolha, state[1], nb0);

endmodule