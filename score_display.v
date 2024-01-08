////////////////////////////////////
// module: score display
// note: display score on-screen during home
///////////////////////////////////
module score_display (clk, h_cnt, v_cnt, score, enable_score_ten, enable_score_one, pixel_addr_score1, pixel_addr_score10);
input clk;
input [9:0] h_cnt, v_cnt;
input [6:0] score;
output enable_score_one, enable_score_ten;
output reg [16:0] pixel_addr_score1, pixel_addr_score10;

reg in_tenX, in_tenY, in_oneX, in_oneY;
wire [6:0] tens, ones;

assign tens =  score/10;
assign ones = score%10;

always @(posedge clk) begin
    in_tenX <= (h_cnt > 10'd280 && h_cnt < 10'd320);
    in_tenY <= (v_cnt > 10'd180 && v_cnt < 10'd240);
    in_oneX <= (h_cnt > 10'd320 && h_cnt < 10'd360);
    in_oneY <= (v_cnt > 10'd180 && v_cnt < 10'd240);
end

assign enable_score_ten = (in_tenX && in_tenY);
assign enable_score_one = (in_oneX && in_oneY);

always @(*) begin
    case (tens)
        7'd0: begin
            pixel_addr_score10 = (v_cnt - 180)*400 + (h_cnt - 280); //special formula
        end
        7'd1: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 40 + (v_cnt - 180)%60 * 400; //special formula, don't know how it works
        end
        7'd2: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 80 + (v_cnt - 180)%60 * 400;
        end
        7'd3: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 120 + (v_cnt - 180)%60 * 400;
        end
        7'd4: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 160 + (v_cnt - 180)%60 * 400;
        end
        7'd5: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 200 + (v_cnt - 180)%60 * 400;
        end
        7'd6: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 240 + (v_cnt - 180)%60 * 400;
        end
        7'd7: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 280 + (v_cnt - 180)%60 * 400;
        end
        7'd8: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 320 + (v_cnt - 180)%60 * 400;
        end
        7'd9: begin
            pixel_addr_score10 = (h_cnt - 280)%40 + 360 + (v_cnt - 180)%60 * 400;
        end
        default: begin
            pixel_addr_score10 = (v_cnt - 180)*400 + (h_cnt - 280); 
        end
    endcase
end

always @(*) begin
    case (ones)
        7'd0: begin
            pixel_addr_score1 = (v_cnt - 180)*400 + (h_cnt - 320); 
        end
        7'd1: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 40 + (v_cnt - 180)%60 * 400;
        end
        7'd2: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 80 + (v_cnt - 180)%60 * 400;
        end
        7'd3: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 120 + (v_cnt - 180)%60 * 400;
        end
        7'd4: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 160 + (v_cnt - 180)%60 * 400;
        end
        7'd5: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 200 + (v_cnt - 180)%60 * 400;
        end
        7'd6: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 240 + (v_cnt - 180)%60 * 400;
        end
        7'd7: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 280 + (v_cnt - 180)%60 * 400;
        end
        7'd8: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 320 + (v_cnt - 180)%60 * 400;
        end
        7'd9: begin
            pixel_addr_score1 = (h_cnt - 320)%40 + 360 + (v_cnt - 180)%60 * 400;
        end
        default: begin
            pixel_addr_score1 = (v_cnt - 180)*400 + (h_cnt - 320); 
        end
    endcase
end
endmodule

////////////////////////////////////
// module: star display
// note: display star on-screen during home
///////////////////////////////////
module star_display (clk, h_cnt, v_cnt, enable_star, pixel_addr_star);
input clk;
input [9:0] h_cnt, v_cnt;
output enable_star;
output [13:0] pixel_addr_star;

reg in_starX, in_starY;

always @(posedge clk) begin
    in_starX <= (h_cnt > 10'd295 && h_cnt < 10'd345);
    in_starY <= (v_cnt > 10'd120 && v_cnt < 10'd170);
end

assign pixel_addr_star = (v_cnt-120)*50 + (h_cnt-295);

assign enable_star = (in_starX && in_starY);
endmodule