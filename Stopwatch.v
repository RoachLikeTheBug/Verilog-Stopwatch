module Stopwatch (
	input wire [9:0] SW,
	input wire [1:0] KEY,
	input wire CLOCK_50,
	output wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output wire [9:0] LEDR
);

reg q;
wire rising, reset, en0, en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11, en12, en13;
wire [3:0] count0, count1, count2, count3, count4, count5, swIn0, swIn1, w0, w1;
reg [3:0] count6, count7, count8, count9, count10, count11;

assign LEDR[9:0] = 10'b0000000000;
assign en12 = 1'b0;
assign en13 = 1'b1;
assign swIn0 = SW[3:0];
assign swIn1 = SW[7:4];
assign w0 = 4'h9;
assign w1 = 4'h5;

always @ (posedge CLOCK_50) begin
	case (SW[9:8])
		2'b00: begin
			count6 <= count0;
			count7 <= count1;
			count8 <= count2;
			count9 <= count3;
			count10 <= count4;
			count11 <= count5;
		end
		2'b01: begin
			count6 <= swIn0;
			count7 <= swIn1;
			count8 <= count2;
			count9 <= count3;
			count10 <= count4;
			count11 <= count5;
		end
		2'b10: begin
			count6 <= count0;
			count7 <= count1;
			count8 <= swIn0;
			count9 <= swIn1;
			count10 <= count4;
			count11 <= count5;
		end
		2'b11: begin
			count6 <= count0;
			count7 <= count1;
			count8 <= count2;
			count9 <= count3;
			count10 <= swIn0;
			count11 <= swIn1;
		end
	endcase
end

Redge RST (.clk(CLOCK_50), .asynchIn(KEY[0]), .roll(reset));

Redge U0 (.clk(CLOCK_50), .asynchIn(KEY[1]), .roll(rising));
// T flip flop
always @ (posedge CLOCK_50) begin 
	q <= rising ? ~q : q;
end

Timer_10ms U1 (.clk(CLOCK_50), .reset(reset), .rollover(en0));
Counter4bit U2 (.clk(CLOCK_50), .reset(reset), .enable(q & en0), .rollover(en1), .maxCount(w0), .countOut(count0), .countIn(count6));
SevenSegDisp U3 (.deci(en12), .hexVal(count0), .hexDisp(HEX0[7:0]));

FedgeNoDelay U4 (.clk(CLOCK_50), .in(en1), .roll(en2));
Counter4bit U5 (.clk(CLOCK_50), .reset(reset), .enable(en2), .rollover(en3), .maxCount(w0), .countOut(count1), .countIn(count7));
SevenSegDisp U6 (.deci(en12), .hexVal(count1), .hexDisp(HEX1[7:0]));

FedgeNoDelay U7 (.clk(CLOCK_50), .in(en3), .roll(en4));
Counter4bit U8 (.clk(CLOCK_50), .reset(reset), .enable(en4), .rollover(en5), .maxCount(w0), .countOut(count2), .countIn(count8));
SevenSegDisp U9 (.deci(en13), .hexVal(count2), .hexDisp(HEX2[7:0]));

FedgeNoDelay U10 (.clk(CLOCK_50), .in(en5), .roll(en6));
Counter4bit U11 (.clk(CLOCK_50), .reset(reset), .enable(en6), .rollover(en7), .maxCount(w1), .countOut(count3), .countIn(count9));
SevenSegDisp U12 (.deci(en12), .hexVal(count3), .hexDisp(HEX3[7:0]));

FedgeNoDelay U13 (.clk(CLOCK_50), .in(en7), .roll(en8));
Counter4bit U14 (.clk(CLOCK_50), .reset(reset), .enable(en8), .rollover(en9), .maxCount(w0), .countOut(count4), .countIn(count10));
SevenSegDisp U15 (.deci(en13), .hexVal(count4), .hexDisp(HEX4[7:0]));

FedgeNoDelay U16 (.clk(CLOCK_50), .in(en9), .roll(en10));
Counter4bit U17 (.clk(CLOCK_50), .reset(reset), .enable(en10), .rollover(en11), .maxCount(w1), .countOut(count5), .countIn(count11));
SevenSegDisp U18 (.deci(en12), .hexVal(count5), .hexDisp(HEX5[7:0]));

endmodule
