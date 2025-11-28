module estoque (
	input clk,
	input reset,

	input done,

	input add_rolha,

	output reg [7:0] CONTAGEM_ROLHAS_ESTOQUE,

	output reg [7:0] CONTAGEM_ROLHAS_LINHA,

	output reg ACIONAR_DISPENSER,

	output reg [7:0] VALOR_SAIDA_ESTOQUE,

	output reg ALERTA_ESTOQUE_BAIXO
);

parameter [7:0] NUM_ROLHAS_PADRAO = 8'd15;

always @(*) begin

    ACIONAR_DISPENSER = 1'b0;
    VALOR_SAIDA_ESTOQUE = 8'd0;
    ALERTA_ESTOQUE_BAIXO = 1'b0;

    if (CONTAGEM_ROLHAS_LINHA <= 8'd5 && CONTAGEM_ROLHAS_ESTOQUE > 0) begin

        ACIONAR_DISPENSER = 1'b1;

        if (CONTAGEM_ROLHAS_ESTOQUE < NUM_ROLHAS_PADRAO) begin

            VALOR_SAIDA_ESTOQUE = CONTAGEM_ROLHAS_ESTOQUE;
            ALERTA_ESTOQUE_BAIXO = 1'b1;
        end else
            VALOR_SAIDA_ESTOQUE = NUM_ROLHAS_PADRAO;
    end

    else if (CONTAGEM_ROLHAS_ESTOQUE == 8'd0)
        ALERTA_ESTOQUE_BAIXO = 1'b1;
end


always @(posedge clk or posedge reset) begin

    if (reset) begin
        CONTAGEM_ROLHAS_ESTOQUE <= 8'd40;
        CONTAGEM_ROLHAS_LINHA <= 8'd0;
    end
    else begin

        if (ACIONAR_DISPENSER)
            CONTAGEM_ROLHAS_LINHA <= CONTAGEM_ROLHAS_LINHA + VALOR_SAIDA_ESTOQUE;

        else if (done && CONTAGEM_ROLHAS_LINHA > 8'd0)
            CONTAGEM_ROLHAS_LINHA <= CONTAGEM_ROLHAS_LINHA - 8'd1;

        if (ACIONAR_DISPENSER)
            CONTAGEM_ROLHAS_ESTOQUE <= CONTAGEM_ROLHAS_ESTOQUE - VALOR_SAIDA_ESTOQUE;

        else if (add_rolha && CONTAGEM_ROLHAS_ESTOQUE < 8'd94)
             CONTAGEM_ROLHAS_ESTOQUE <= CONTAGEM_ROLHAS_ESTOQUE + 8'd5;

    end
end
endmodule