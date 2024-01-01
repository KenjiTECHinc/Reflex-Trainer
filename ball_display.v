module ball_display (clk, h_cnt, v_cnt, ballX, ballY, enable_ball);
///////////////////////////////////////////
// module: check target location
// note: use 25MHz VGA clk
///////////////////////////////////////////
input clk;
input [9:0] h_cnt, v_cnt;
input [9:0] ballX, ballY;
output enable_ball;

reg in_ballX, in_ballY;

always @(posedge clk) begin
    in_ballX <= (h_cnt > ballX && h_cnt < (ballX + 10'd48));
    in_ballY <= (v_cnt > ballY && v_cnt < (ballY + 10'd48));
end
assign enable_ball = (in_ballX && in_ballY);
endmodule