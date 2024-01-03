////////////////////////////////////////////
// Module: Game start logic
// I/O:
//      - trigger: trigger button
//      - elasped time: time since start game
//      - start: enable signal for each round
// Note: Logic to start a round. Each round last 30 sec.
////////////////////////////////////////////
module game_start (clk, trigger, rst, elasped_time, start);
input clk, trigger, rst;
output reg [4:0] elasped_time;
output reg start = 0;

reg [27-1:0] game_counter;

always @(*) begin
    if(rst) start = 1'b0;
    else if(~start) begin
        if(trigger) begin
            start = 1'b1;
        end
        else begin
            //pass
        end
    end
    else begin //start is '1'
        if(elasped_time >= 5'd30) begin
            start = 1'b0;   //stop after timer.
        end
        else begin
            //pass
        end
    end
end

always @(posedge clk) begin
    if(start) begin
        if(game_counter >= 27'd99999999) begin
            game_counter <= 27'd0;
            elasped_time <= elasped_time + 5'b1;
        end
        else begin
            game_counter <= game_counter + 27'd1;
        end
    end
    else begin
        game_counter <= 27'd0;
        elasped_time <= 5'b0;
    end
end
endmodule

////////////////////////////////////////////
// Module: Game Score
// I/O:
//      - trigger: trigger signal
//      - start: enable signal
//      - score: output score.
// Note: Logic to count in-game score.
////////////////////////////////////////////
module game_score (clk, rst, trigger, start, score);
input trigger, start, clk, rst;
output reg [6:0] score = 7'b0; // 0-100 [128]

always @(posedge clk or posedge trigger) begin
    if(rst) begin 
        score <= 7'b0;
    end 
    else if(start) begin
        if(trigger) begin
            score <= score + 7'b1;
        end
        else begin
            //pass
        end
    end 
    else begin
        score <= 7'b0;
    end
end
//assign score = (trigger && start)? score + 7'd1 : (~trigger && start)? score : 7'b0; 
endmodule