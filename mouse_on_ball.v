////////////////////////////////////////////
// Module: Mouse on Ball?
// Note: Check if mouse position is on target.
////////////////////////////////////////////
module mouse_on_ball (BALL_X, BALL_Y, MOUSE_X_POS, MOUSE_Y_POS, MOUSE_LEFT, MOUSE_MIDDLE, start, new_ball);
input [9:0] BALL_X, BALL_Y, MOUSE_X_POS, MOUSE_Y_POS;
input MOUSE_LEFT, MOUSE_MIDDLE, start;
output new_ball;

wire inX, inY, on_ball;

assign inX = (MOUSE_X_POS >= BALL_X) && (MOUSE_X_POS < (BALL_X + 10'd40));
assign inY = (MOUSE_Y_POS >= BALL_Y) && (MOUSE_Y_POS < (BALL_Y + 10'd40));
assign on_ball = inX && inY && MOUSE_LEFT;  //signal that mouse is clicked on the ball

assign new_ball = (MOUSE_MIDDLE || (on_ball))? 1'b1: 1'b0; //MOUSE_MIDDLE is for debugging but too lazy to remove.
endmodule