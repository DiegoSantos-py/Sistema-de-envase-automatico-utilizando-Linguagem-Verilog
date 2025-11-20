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
        if (reset)
            state <= E0;
        else
            state <= nextstate;

	 // Lógica de próximo estado
	always @(*) 
		 case(state)

			  // ESTADO E0  (00)
			  E0:
					if (rolha5 == 1 && switch_add_rolha == 0)
						nextstate = DISP;
					else if (switch_add_rolha == 1)
						nextstate = ADD1;
					else
						nextstate = E0;


			  // ESTADO DISP (01)
			  DISP:
					if (rolha5 == 0)
						 nextstate = E0;            // Após dispensar volta p/ base
					else if (rolha5 == 1)
						 nextstate = E0;          // Continua dispensando

			  // ESTADO ADD1 (10)
			  ADD1:
					if (rolha5 == 1 && switch_add_rolha == 0)
						 nextstate = E0;            // Depósito cheio -> volta
					else if (rolha5 == 0 && switch_add_rolha == 0)
						nextstate = E0;
					else
						 nextstate = ADD2;          // Próximo estágio de adição

			  // ESTADO ADD2 (11)
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
		 
	 assign disp = (state == DISP);
	 assign add_rolha = (state == ADD1);
	
//	saidas_dispenser logic_out (
//    .state(state),
//    .disp(disp),
//    .add_rolha(add_rolha)
//);
	
	
endmodule


module saidas_dispenser (
    input  [1:0]state,      // bits do estado
    output disp,
    output add_rolha
);

    wire nb1, nb0;
	 
	 // NOT do bit b0
	 not (nb0, b0);

    // NOT do bit b1
    not (nb1, b1);

    // DISP = (~b1 & b0)
    and (disp, nb1, b0);

    and (add_rolha, b1, nb0);

endmodule