////////////////////////////////////////////
// Module name: Clock converter
// I/O:
//      - clk: input clock
//      - dclk: output clock signal
//
// Constraints: Max 28-bit counter --> 268,435,456
// Note: Versatile clock converter from given parameter.
////////////////////////////////////////////
module clock_divisor(dclk, clk);
input clk;
output dclk;

reg [1:0] num;
wire [1:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign dclk = num[1];

endmodule