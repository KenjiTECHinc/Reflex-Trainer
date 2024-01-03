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
//      - elasped_time: total played time.
// Note: clock signaled every 1 game second.
////////////////////////////////////////////
/*
module clock_divisor_game(clk, start, dclk, elasped_time);
input clk, start;
output reg dclk;
output reg [4:0] elasped_time;
reg [28-1:0] game_counter;

//timer counts on start signal.
always @(posedge clk) begin
  if(start) begin
    game_counter <= game_counter + 28'd1;
    if(game_counter >= 28'd99999999) begin
      game_counter <= 28'd0;
    end
    dclk <= (game_counter === 28'd99999999)? 1'b1: 1'b0;
    elasped_time <= (game_counter >= 28'd99999999)? elasped_time + 5'b1: elasped_time;
  end
  else begin //start is '0'
    game_counter <= 28'd0;
    elasped_time <= 5'b0;
  end
end
endmodule*/