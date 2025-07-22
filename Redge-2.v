module Redge (
	input wire clk, asynchIn,
	output wire roll
);

reg a, b, c, rising;

assign roll = rising;

// synch chain
always @ (posedge clk) begin
	a <= asynchIn;
	b <= a;
	c <= b;
end

// rising edge detector
always @ (*) begin
	rising = b & ~c;
end

endmodule 