////////////////////////////////////
// module: time display
// note: display time on-screen during game
///////////////////////////////////
module time_display(clk, h_cnt, v_cnt, elasped_time, pixel_addr_ten, enable_ten, enable_one, pixel_addr_one);
input clk;
input [4:0] elasped_time;
input [9:0] h_cnt, v_cnt;
output enable_ten;
output enable_one;
output reg [13:0] pixel_addr_ten;
output reg [13:0] pixel_addr_one;

reg in_tenX, in_tenY, in_oneX, in_oneY;
wire [4:0] tens, ones;

assign tens = (5'd30 - elasped_time) /10;
assign ones = (5'd30 - elasped_time) %10;

always @(posedge clk) begin
    in_tenX <= (h_cnt > 10'd295 && h_cnt < 10'd320);
    in_tenY <= (v_cnt > 10'd5 && v_cnt < 10'd37);
    in_oneX <= (h_cnt > 10'd320 && h_cnt < 10'd345);
    in_oneY <= (v_cnt > 10'd5 && v_cnt < 10'd37);
end

assign enable_ten = (in_tenX && in_tenY);
assign enable_one = (in_oneX && in_oneY);

always @(*) begin
    case (tens)
        5'd0: begin
            pixel_addr_ten = (v_cnt - 5)*250 + (h_cnt - 295); 
        end
        5'd1: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 25 + (v_cnt - 5)%32 * 250;
        end
        5'd2: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 50 + (v_cnt - 5)%32 * 250;
        end
        5'd3: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 75 + (v_cnt - 5)%32 * 250;
        end
        5'd4: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 100 + (v_cnt - 5)%32 * 250;
        end
        5'd5: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 125 + (v_cnt - 5)%32 * 250;
        end
        5'd6: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 150 + (v_cnt - 5)%32 * 250;
        end
        5'd7: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 175 + (v_cnt - 5)%32 * 250;
        end
        5'd8: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 200 + (v_cnt - 5)%32 * 250;
        end
        5'd9: begin
            pixel_addr_ten = (h_cnt - 295)%25 + 225 + (v_cnt - 5)%32 * 250;
        end
        default: begin
            pixel_addr_ten = (v_cnt - 5)*250 + (h_cnt - 295); 
        end
    endcase
end

always @(*) begin
    case (ones)
        5'd0: begin
            pixel_addr_one = (v_cnt - 5)*250 + (h_cnt - 320); 
        end
        5'd1: begin
            pixel_addr_one = (h_cnt - 320)%25 + 25 + (v_cnt - 5)%32 * 250;
        end
        5'd2: begin
            pixel_addr_one = (h_cnt - 320)%25 + 50 + (v_cnt - 5)%32 * 250;
        end
        5'd3: begin
            pixel_addr_one = (h_cnt - 320)%25 + 75 + (v_cnt - 5)%32 * 250;
        end
        5'd4: begin
            pixel_addr_one = (h_cnt - 320)%25 + 100 + (v_cnt - 5)%32 * 250;
        end
        5'd5: begin
            pixel_addr_one = (h_cnt - 320)%25 + 125 + (v_cnt - 5)%32 * 250;
        end
        5'd6: begin
            pixel_addr_one = (h_cnt - 320)%25 + 150 + (v_cnt - 5)%32 * 250;
        end
        5'd7: begin
            pixel_addr_one = (h_cnt - 320)%25 + 175 + (v_cnt - 5)%32 * 250;
        end
        5'd8: begin
            pixel_addr_one = (h_cnt - 320)%25 + 200 + (v_cnt - 5)%32 * 250;
        end
        5'd9: begin
            pixel_addr_one = (h_cnt - 320)%25 + 225 + (v_cnt - 5)%32 * 250;
        end
        default: begin
            pixel_addr_one = (v_cnt - 5)*250 + (h_cnt - 320); 
        end
    endcase
end

endmodule