////////////////////////////////////////////
// Module: Game start logic
// I/O:
//      - trigger: trigger button
//      - elasped time: time since start game
//      - start: enable signal for each round
//      - jump start: generate a random starting position of target.
// Note: Logic to start a round. Each round last 30 sec.
////////////////////////////////////////////
module game_start (clk, trigger, rst, elasped_time, start, jump_start, state);
input clk, trigger, rst;
output reg [4:0] elasped_time = 5'd0;
output reg start = 0;
output jump_start;
output reg state;
parameter IDLE = 1'b0,
            GAME = 1'b1;
reg next_state;
reg start_time;
reg [27-1:0] game_counter;

assign jump_start = (trigger && ~start)? 1'b1: 1'b0;

always @(*) begin
    if(rst) next_state = IDLE; 
    else begin
        case (state)
            IDLE: begin
                if(trigger) begin
                    start_time = 1'b1;
                    next_state = GAME;
                end
                else begin
                    //pass
                end
            end 
            GAME: begin
                start_time = 1'b0;
                if(elasped_time >= 5'd30) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = GAME;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: start = 1'b0;
        GAME: start = 1'b1; 
        default: begin
            //pass
        end
    endcase
end

always @(posedge clk) begin
    if(rst) begin
        state <= IDLE;
        game_counter <= 27'd0;
    end
    else begin
        state <= next_state;
        if(start_time) begin
            game_counter <= 27'd0;
        end
        else begin
            if(game_counter === 27'd99999999) begin
                game_counter <= 27'd0;
            end
            else begin
                game_counter <= game_counter + 27'd1;
            end
        end
    end
end

always @(posedge clk) begin
    case (state)
        IDLE: begin
            elasped_time <= 5'b0;
        end 
        GAME: begin
            if(game_counter === 27'd99999999) begin
                elasped_time <= elasped_time + 5'b1;
            end
            else begin
                //pass
            end
        end
        default: begin
            //pass
        end
    endcase
end
endmodule

////////////////////////////////////////////
// Module: Game Score
// Note: Score logic for calculating targets hit
// Note2: Increment score based on when target changes its position.
// I/O:
//      - game_state: current state of the game, IDLE = no play, GAME = in-game
//      - BALL_X/Y: target's current position
//      - score: current game score
//      - home_score: hold score of previous game for display.
////////////////////////////////////////////
module game_score (clk, rst, trigger, game_state, score, home_score, BALL_X, BALL_Y);
input clk, rst, trigger;
input game_state;
input [9:0] BALL_X, BALL_Y;
output reg [6:0] score = 7'd0;  //in-game score
output reg [6:0] home_score = 7'd0; // home score

parameter IDLE = 1'b0,
            GAME = 1'b1;

reg  first_start; 
reg [9:0] temp_ballx, temp_bally;

always @(posedge clk) begin
    if(game_state == GAME) begin
        if((temp_ballx != BALL_X) || (temp_bally != BALL_Y)) begin
            if((~first_start) && (score < 7'd99)) begin
                score <= score + 7'b1;
                temp_ballx <= BALL_X;
                temp_bally <= BALL_Y;
            end
            else begin
                score <= score;
                first_start <= 1'b0;
                temp_ballx <= BALL_X;
                temp_bally <= BALL_Y;
            end
        end
        else begin
            score <= score;
        end
    end
    else begin
        temp_ballx <= BALL_X;
        temp_bally <= BALL_Y;
        score <= 7'b0;
        first_start <= 1'b1;
    end
end

always @(*) begin
    if(rst) home_score = 7'd0;
    else begin
        if(game_state == GAME) begin
            home_score = score;
        end
        else begin
            home_score = home_score;
        end
    end
end
endmodule

////////////////////////////////////////////
// Module: Debounce + One Pulse
// Note: Stabilize signals make one pulse
// UTILITY MODULE
////////////////////////////////////////////
module Debounce_onePulse (clk, pushButton, signal);
input clk, pushButton;
output signal;
wire sub_signal;
wire Q1, Q2, Q3, Q4, Q5;    //Use 5 DFFs to ensure a stable signal.

D_FlipFlop DFF1 (.clk(clk), .D(pushButton), .Q(Q1)); //debounce
D_FlipFlop DFF2 (.clk(clk), .D(Q1), .Q(Q2)); //debounce
D_FlipFlop DFF3 (.clk(clk), .D(Q2), .Q(Q3)); //debounce
D_FlipFlop DFF4 (.clk(clk), .D(Q3), .Q(Q4)); //debounce
D_FlipFlop DFF5 (.clk(clk), .D(Q4), .Q(Q5)); //begin one-pulse

assign sub_signal = Q1 & Q2 & Q3 & Q4 & !Q5;
D_FlipFlop DFF6 (.clk(clk), .D(sub_signal), .Q(signal)); //one-pulse.
endmodule

module D_FlipFlop (clk, D, Q);   //for debounce implementation
input clk, D;
output reg Q;
reg Q_not;

always @(posedge clk) begin
    Q <= D;
    Q_not <= !Q;
end
endmodule

/// UNUSED MODULES ///
/*module game_start (clk, trigger, rst, elasped_time, start);
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
            elasped_time <= elasped_time + 5'd1;
        end
        else begin
            game_counter <= game_counter + 27'd1;
        end
    end
    else begin
        game_counter <= 27'd0;
        elasped_time <= 5'd0;
    end
end
endmodule */

/*
module game_score (clk, rst, trigger, start, score/*, BALL_X, BALL_Y);
input clk, rst, trigger;
input start;
output reg [6:0] score = 7'd0;
/*
input [9:0] BALL_X, BALL_Y;

parameter IDLE = 1'd0,
            INCR = 1'd1;
reg state, next_state;
reg start_time;
reg [1:0] timer;


always @(*) begin
    if(rst) begin
        next_state = IDLE;
    end
    else begin
        case (state)
            IDLE: begin
                if(start) begin
                    if(trigger) begin
                        next_state = INCR;
                        start_time = 1'b1;
                    end
                    else begin
                        next_state = IDLE;
                        start_time = 1'b0;
                    end
                end
                else begin
                    //pass
                end
            end 
            INCR: begin //buffer for adding score. (hold time)
                start_time = 1'b0;
                if(timer >= 2'd0) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = INCR;
                end
            end
            default: begin
                
            end
        endcase
    end
end

always @(posedge clk) begin
    if(rst) score <= 7'b0;
    else if(~start) score <= 7'b0;
    else begin 
        if(state == INCR) begin
            score <= score + 7'b1;
        end
        else begin
            score <= score;
        end
    end
end

always @(posedge clk) begin
    if(rst)begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
        if(start_time) begin
            timer <= 2'b0;
        end
        else begin
            timer <= timer + 2'b1;
        end
    end
end
endmodule
*/