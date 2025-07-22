module FedgeNoDelay (
	input wire clk, in,
	output wire roll
);

reg a, falling;

assign roll = falling;

// synch chain
always @ (posedge clk) begin
	a <= in;
end

// rising edge detector
always @ (*) begin
	falling = a & ~in;
end

endmodule 
