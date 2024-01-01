module pixel_gen(
   input [9:0] h_cnt,
   input [9:0] MOUSE_X_POS,
   input valid,
   input enable_mouse_display,
   input enable_ball,
   input [11:0] mouse_pixel,
   input MOUSE_LEFT,
   input MOUSE_RIGHT,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue
);
   
assign flip_left = MOUSE_RIGHT || ( MOUSE_LEFT && (MOUSE_X_POS < 640) );

always@(*) begin
    if(!valid) begin
        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
    end else if(enable_mouse_display) begin
        {vgaRed, vgaGreen, vgaBlue} = mouse_pixel;
    end else if(enable_ball) begin
        {vgaRed, vgaGreen, vgaBlue} = 12'hf50;  //generate ball (orange color)
    end else begin
        if(h_cnt < 640) begin
            if(flip_left)begin
                {vgaRed, vgaGreen, vgaBlue} = 12'hf5f;
            end else begin
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
            end
        end
    end
end

endmodule
