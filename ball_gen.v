module ball_gen(clk, rst, new_ball, jump_start, ballX, ballY);
///////////////////////////////////////////
// module: generate ball target position
// note: screen size 640 x 480, ball size: 40 x 40.
///////////////////////////////////////////
input clk, rst;
input new_ball;
input jump_start;
output reg [9:0] ballX;
output reg [9:0] ballY;

wire [9:0] rand_x, rand_y;

always @(*) begin
    if(new_ball || jump_start) begin
        ballX = rand_x;
        ballY = rand_y;
    end
    else begin
        //pass
    end
end
random_pos RP(.clk(clk), .rst(rst), .rand_x(rand_x), .rand_y(rand_y));
endmodule


module random_pos(clk, rst, rand_x, rand_y);
///////////////////////////////////////////
// module: random position generator
// note: use clock to generate 'random' grid values within screen.
//
///////////////////////////////////////////
input clk, rst;
output reg [9:0] rand_x, rand_y;
reg [18-1:0] seed_x, seed_y;

always @(posedge clk) begin
    if(rst) begin
        seed_x <= 18'd0;
        seed_y <= 18'd0;
    end
    else begin
        seed_x <= (seed_x + 18'd3)%64;
        seed_y <= (seed_y + 18'd1)%48;
    end
end

always @(posedge clk) begin //X-axis positions
    if(seed_x >= 18'd60) begin
        rand_x <= 10'd590;
    end
    else if(seed_x < 18'd1) begin
        rand_x <= 10'd10;
    end
    else begin
        rand_x <= (seed_x * 10);
    end
end

always @(posedge clk) begin //Y-axis positions
    if(seed_y >= 18'd44) begin
        rand_y <= 10'd430;
    end
    else if(seed_y < 18'd4) begin //draw border so that ball doesn't generate at the top 40 pixel area of the screen.
        rand_y <= 10'd40;
    end
    else begin
        rand_y <= (seed_y * 10);
    end
end
endmodule

/*
this is screen
    vv
_________________________________________________________
|                       time display                    | ]-> this area is 40 pixels tall, no target generated inside.
|-------------------------------------------------------|
|                                                       |
|                                                       |
|                                                       |
|                   game area                           |
|                                                       |
|                                                       |
|                                                       |
|                                                       |
|                                                       |
|                                                       |
|                                                       |
_________________________________________________________
  `--> there will also be other borders on the sides of each screen too. 

*/