module contador(clk,reset,up_down,load,data,count);
  input clk,reset,load,up_down;
  input [7:0] data;
  output reg [7:0] count;

  always@(posedge clk, posedge reset) 
    if(reset) 
      count <= 8'd0;
    else if(load)
		count <= data;    
    else if(up_down) 
      count <= count + 1;
    else            
      count <= count - 1;
endmodule 

module contador_disp(clk,reset,up_down,load,data,count);
  input clk,reset,load,up_down;
  input [7:0] data;
  output reg [7:0] count;

  always@(posedge clk) 
    if(reset) 
      count <= 8'd0;
    else if(load)
		count <= count + data;   
    else if(up_down)        
      count <= count + 1;
    else            
      if (count > 0)
        count <= count - 1;
      else
        count <= 0;
endmodule 

module contador2 (
    input clk,
    input reset_trigger,   // Reset assíncrono
    input signal,          // Direção

    input [7:0] value,
    output reg [7:0] count
);

always @(posedge clk or posedge reset_trigger) begin
    if (reset_trigger) begin
        count <= 8'd0;
    end else begin
        if (signal)

            count <= count + value;
        else

            count <= count - value;
    end
end

endmodule