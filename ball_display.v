module ball_display (clk, h_cnt, v_cnt, ballX, ballY, start, enable_ball);
///////////////////////////////////////////
// module: check target location
// note: use 25MHz VGA clk
///////////////////////////////////////////
input clk;
input start;
input [9:0] h_cnt, v_cnt;
input [9:0] ballX, ballY;
output enable_ball;

reg in_ballX, in_ballY;

always @(posedge clk) begin
    in_ballX <= (h_cnt > ballX && h_cnt < (ballX + 10'd40));
    in_ballY <= (v_cnt > ballY && v_cnt < (ballY + 10'd40));
end
assign enable_ball = (in_ballX && in_ballY && start);
endmodule


module start_display (clk, h_cnt, v_cnt, start, enable_start, pixel_addr_start);
///////////////////////////////////////////
// module: check 'start' button location
// note: provide pixel address map to module Memory Block Generator
///////////////////////////////////////////
input clk;
input start;
input [9:0] h_cnt, v_cnt;
output enable_start;
output [13:0] pixel_addr_start;

reg in_startX, in_startY;

always @(posedge clk) begin
    in_startX <= (h_cnt > 10'd220 && h_cnt < 10'd420);
    in_startY <= (v_cnt > 10'd300 && v_cnt < 10'd370);
end

assign pixel_addr_start = (v_cnt-300)*200 + (h_cnt-220);

assign enable_start = (in_startX && in_startY);
endmodule