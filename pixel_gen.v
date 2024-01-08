///////////////////////////////////////////////////////
// Generate pixel color code according to what is being displayed.
///////////////////////////////////////////////////////
module pixel_gen(
   input clk_25MHz,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   input [9:0] MOUSE_X_POS,
   input [9:0] MOUSE_Y_POS,
   input valid,
   input enable_mouse_display,
   input enable_ball,
   input [11:0] mouse_pixel,
   input MOUSE_LEFT,
   input MOUSE_RIGHT,
   input game_state,
   input enable_start,
   input [11:0] pixel_start,
   input enable_ten,
   input [11:0] pixel_ten,
   input enable_one,
   input [11:0] pixel_one,
   input [11:0] pixel_score_one,
   input enable_score_one,
   input enable_score_ten,
   input [11:0] pixel_score_ten,
   input enable_star,
   input [11:0]  pixel_star,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue
);
parameter IDLE = 1'b0,  //game state
        GAME = 1'b1;

always@(*) begin
    if(!valid) begin
        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
    end
    else begin
        case (game_state)
            IDLE: begin
                if(enable_mouse_display) begin
                    {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
                end
                else if(enable_star) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_star;
                end
                else if(enable_score_ten) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_score_ten;    
                end 
                else if(enable_score_one) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_score_one;
                end
                else if(enable_start) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_start;
                end 
                else begin
                    if(h_cnt < 640) begin
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                end
            end
            GAME: begin
                if(enable_mouse_display) begin
                    {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
                end 
                else if(enable_ten) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_ten;
                end
                else if(enable_one) begin
                    {vgaRed, vgaGreen, vgaBlue} = pixel_one;
                end
                else if(enable_ball) begin
                    {vgaRed, vgaGreen, vgaBlue} = 12'hf50;  //generate ball (orange color)
                end else begin
                    if(h_cnt < 640) begin
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    end
                end
            end
            default: begin
                //pass
            end
        endcase
    end
end
endmodule
