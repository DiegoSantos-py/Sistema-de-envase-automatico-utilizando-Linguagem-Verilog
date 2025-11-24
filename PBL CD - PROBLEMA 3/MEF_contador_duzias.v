module MEF_contador_duzias(
    input  cq,
    input  cont12,
    input  reset,
    input  clk,
    output cont1,
    output add_cont12,
	 output cont_done
);

    reg [1:0] state, nextstate;

    parameter C1     = 2'b00;
    parameter CONT1  = 2'b01;
	 parameter WAIT   = 2'b10;
    parameter CONT12 = 2'b11;

	 always @ ( posedge clk , posedge
	 reset )
		if ( reset ) state <= C1 ;
		else state <= nextstate ;

    always @(*) 
        case (state)
            C1:
                if (cont12 == 0 && cq == 1)
                    nextstate = CONT1;
					 else if (cont12 == 1 && cq == 1)
						  nextstate = CONT1;
                else
                    nextstate = C1;

            CONT1:
						nextstate = WAIT;
				WAIT:	
					   if (cont12 == 1 && cq == 0)
							nextstate = CONT12;
						else if (cont12 == 1 && cq == 1)
							nextstate = CONT12;
						else if (cont12 == 0 && cq == 1)
							nextstate = WAIT;
						else
							nextstate = C1;
            CONT12:
						if (cont12)
							nextstate = CONT12;
						 else
							nextstate = C1;
            default:
                nextstate = C1;
        endcase


    //saida_contador_duzias(
	 //.state(state),
	 //.cont1(cont1),
	 //.add_cont12(add_cont12)
	 //);
	 
	 assign cont1 = (state == CONT1);
	 assign add_cont12 = (state == CONT12);
	 assign cont_done = (state == WAIT);

endmodule

module saida_contador_duzias(    
	 input  [1:0]state,      // bits do estado
    output cont1,
    output add_cont12,
	 output done
	 );
	 
	 wire ne0;
    wire ne1;
		
	 not (ne0,state[0]);
	 not (ne1,state[1]);
    and (cont1, ne1, state[0]);
	 and (done, state[1], ne0);
    and (add_cont12, state[1], state[0]);

endmodule
	 

	 