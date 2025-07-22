module Counter4bit (
	input wire enable, reset, clk,
	input wire [3:0] countIn, maxCount,
	output wire rollover,
	output wire [3:0] countOut
);

wire [3:0] rstCount;
reg roll;
reg [3:0] count;

initial begin 
	count = 4'h0;
end

assign countOut = count;
assign rollover = roll;
assign rstCount = countIn;

always @ (*) begin
	case (reset)
		1'b0: roll = (count == maxCount) ? 1'b1 : 1'b0;
		1'b1: roll = 1'b0;
		default: roll = 1'b0;
	endcase
end

always @ (posedge clk) begin
	case ({reset, enable}) 
		2'b00: count <= count;
		2'b01: count <= (count < maxCount) ? (count + 4'h1) : 4'h0;
		2'b10: count <= rstCount;
		2'b11: count <= rstCount;
		default: count <= 4'h0;
	endcase
end

endmodule
