module Timer_10ms (
	input wire clk, reset,
	output wire rollover
);

reg [19:0] i;
reg roll;

assign rollover = roll;

initial begin
	roll = 1'b0;
	i = 20'h00000;
end

always @ (*) begin
	if (i == 20'h7a11f) begin //20'h7a11f in hex is equivalent to 500,000 in decimal
		roll = 1'b1;
	end 
	else begin
		roll = 1'b0;
	end
end

always @ (posedge clk) begin
	case (reset) 
		1'b0: i <= (i < 20'h7a11f) ? (i + 20'h00001) : 20'h00000;
		1'b1: i <= 20'h00000;
	endcase
end

endmodule
