////////////////////////////////////////////
// Module: Game start logic
// I/O:
//      - trigger: trigger button
//      - elasped time: time since start game
//      - start: enable signal for each round
// Note: Logic to start a round. Each round last 30 sec.
////////////////////////////////////////////
module game_start (trigger, elasped_time, start);
input trigger;
input [4:0] elasped_time;
output reg start = 0;

always @(*) begin
    if(~start) begin
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
endmodule