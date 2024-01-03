////////////////////////////////////////////
// Module name: Clock divisor 25mHz
// I/O:
//      - clk: input clock
//      - dclk: output clock signal
////////////////////////////////////////////
module clock_divisor_25mHz(dclk, clk);
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

////////////////////////////////////////////
// Module name: Clock divisor game
// I/0:
//      - clk: input clock
//      - start: start counter signal
//      - dclk: output clock signal
// Note: clock signaled every 1 game second.
////////////////////////////////////////////
module clock_divisor_game(clk, start, dclk);
input clk, start;
output dclk;
reg [28-1:0] counter;

//timer counts on start signal.
always @(posedge clk) begin
  if(start) begin
    counter <= counter + 28'd1;
    if(counter >= 28'd99999999) begin
      counter <= 28'd0;
    end
    dclk <= (counter === 28'd99999999)? 1'b1: 1'b0;
  end
  else begin
    counter <= 28'd0;
  end
end
endmodule