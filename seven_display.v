///////////////////////////////////////////
// for displaying score and time on seven segment
// used during debugging
// not really used anymore... but is still useful to have
///////////////////////////////////////////
module seven_segment (clk, rst, elasped_time, score, Anode, LED);
input clk, rst;
input [4:0] elasped_time;
input [6:0] score;
output reg [3:0] Anode;
output reg [6:0] LED;
reg [2-1:0] active_Anode;
reg [8-1:0] LED1, LED2, LED3, LED4;
reg [28-1:0] refresh;

wire [4:0] remained_time;
assign remained_time = 5'd30 - elasped_time;

always @(posedge clk) begin
    if(rst) begin
        refresh <= 28'b0;
        active_Anode <= 2'b0;
    end
    else begin
        if(refresh === 28'd99999) begin
            refresh <= 28'b0;
            active_Anode <= active_Anode + 2'b1;
        end
        else begin
            refresh <= refresh + 28'b1;
        end
    end
end

always @(*) begin
    case (active_Anode)
        2'd0: begin
            Anode = 4'b1110;
            LED = LED1;
        end
        2'd1: begin
            Anode = 4'b1101;
            LED = LED2;
        end
        2'd2: begin
            Anode = 4'b1011;
            LED = LED3;
        end
        2'd3: begin
            Anode = 4'b0111;
            LED = LED4;
        end
        default: begin
            Anode = 4'b0000;    //display all ports as '-'
            LED = 8'b11111101;
        end
    endcase
end

always @(*) begin
    if(remained_time == 5'b00000) begin //00
        LED2 = 7'b0000001; 
        LED1 = 7'b0000001;
    end 
    if(remained_time == 5'b00001) begin
        LED2 = 7'b0000001; //01
        LED1 = 7'b1001111;
    end
    if(remained_time == 5'b00010) begin
        LED2 = 7'b0000001; //02
        LED1 = 7'b0010010;
    end
    if(remained_time == 5'b00011) begin //03
        LED2 = 7'b0000001; 
        LED1 = 7'b0000110;
        end
    if(remained_time == 5'b00100) begin //04
        LED2 = 7'b0000001; 
        LED1 = 7'b1001100;
    end
    if(remained_time == 5'b00101) begin //05
        LED2 = 7'b0000001; 
        LED1 = 7'b0100100;
    end
    if(remained_time == 5'b00110) begin //06
        LED2 = 7'b0000001; 
        LED1 = 7'b0100000;
    end
    if(remained_time == 5'b00111) begin //07
        LED2 = 7'b0000001; 
        LED1 = 7'b0001111;
    end
    if(remained_time == 5'b01000) begin //08
        LED2 = 7'b0000001; 
        LED1 = 7'b0000000;
    end
    if(remained_time == 5'b01001) begin //09
        LED2 = 7'b0000001;  
        LED1 = 7'b0000100;
    end
    if(remained_time == 5'b01010) begin //10
        LED2 = 7'b1001111; 
        LED1 = 7'b0000001;
    end
    if(remained_time == 5'b01011) begin //11
        LED2 = 7'b1001111; 
        LED1 = 7'b1001111;
    end
    if(remained_time == 5'b01100) begin //12
        LED2 = 7'b1001111; 
        LED1 = 7'b0010010;
    end
    if(remained_time == 5'b01101) begin //13
        LED2 = 7'b1001111; 
        LED1 = 7'b0000110;
    end
    if(remained_time == 5'b01110) begin //14
        LED2 = 7'b1001111; 
        LED1 = 7'b1001100;
    end
    if(remained_time == 5'b01111) begin //15
        LED2 = 7'b1001111; 
        LED1 = 7'b0100100;
    end
    if(remained_time == 5'b10000) begin //16
        LED2 = 7'b1001111;
        LED1 = 7'b0100000;
    end
    if(remained_time == 5'b10001) begin //17
        LED2 = 7'b1001111;
        LED1 = 7'b0001111;
    end
    if(remained_time == 5'b10010) begin //18
        LED2 = 7'b1001111;
        LED1 = 7'b0000000;
    end
    if(remained_time == 5'b10011) begin //19
        LED2 = 7'b1001111;
        LED1 = 7'b0000100;
    end
    if(remained_time == 5'b10100) begin //20
        LED2 = 7'b0010010;
        LED1 = 7'b0000001;
    end
    if(remained_time == 5'b10101) begin //21
        LED2 = 7'b0010010;
        LED1 = 7'b1001111;
    end
    if(remained_time == 5'b10110) begin //22
        LED2 = 7'b0010010;
        LED1 = 7'b0010010;
    end
    if(remained_time == 5'b10111) begin //23
        LED2 = 7'b0010010;
        LED1 = 7'b0000110;
    end
    if(remained_time == 5'b11000) begin //24
        LED2 = 7'b0010010;
        LED1 = 7'b1001100;
    end
    if(remained_time == 5'b11001) begin //25
        LED2 = 7'b0010010;
        LED1 = 7'b0100100;
    end
    if(remained_time == 5'b11010) begin //26
        LED2 = 7'b0010010;
        LED1 = 7'b0100000;
    end
    if(remained_time == 5'b11011) begin //27
        LED2 = 7'b0010010;
        LED1 = 7'b0001111;
    end
    if(remained_time == 5'b11100) begin //28
        LED2 = 7'b0010010;
        LED1 = 7'b0000000;
    end
    if(remained_time == 5'b11101) begin //29
        LED2 = 7'b0010010;
        LED1 = 7'b0000100;
    end
    if(remained_time == 5'b11110) begin //30
        LED2 = 7'b0000110;
        LED1 = 7'b0000001;
    end
end
//score
always @(*) begin
    if(score == 7'd0) begin //00
        LED4 = 7'b0000001; 
        LED3 = 7'b0000001;
    end 
    if(score == 7'd1) begin
        LED4 = 7'b0000001; //01
        LED3 = 7'b1001111;
    end
    if(score == 7'd2) begin
        LED4 = 7'b0000001; //02
        LED3 = 7'b0010010;
    end
    if(score == 7'd3) begin //03
        LED4 = 7'b0000001; 
        LED3 = 7'b0000110;
        end
    if(score == 7'd4) begin //04
        LED4 = 7'b0000001; 
        LED3 = 7'b1001100;
    end
    if(score == 7'd5) begin //05
        LED4 = 7'b0000001; 
        LED3 = 7'b0100100;
    end
    if(score == 7'd6) begin //06
        LED4 = 7'b0000001; 
        LED3 = 7'b0100000;
    end
    if(score == 7'd7) begin //07
        LED4 = 7'b0000001; 
        LED3 = 7'b0001111;
    end
    if(score == 7'd8) begin //08
        LED4 = 7'b0000001; 
        LED3 = 7'b0000000;
    end
    if(score == 7'd9) begin //09
        LED4 = 7'b0000001;  
        LED3 = 7'b0000100;
    end
    if(score == 7'd10) begin //10
        LED4 = 7'b1001111; 
        LED3 = 7'b0000001;
    end
    if(score == 7'd11) begin //11
        LED4 = 7'b1001111; 
        LED3 = 7'b1001111;
    end
    if(score == 7'd12) begin //12
        LED4 = 7'b1001111; 
        LED3 = 7'b0010010;
    end
    if(score == 7'd13) begin //13
        LED4 = 7'b1001111; 
        LED3 = 7'b0000110;
    end
    if(score == 7'd14) begin //14
        LED4 = 7'b1001111; 
        LED3 = 7'b1001100;
    end
    if(score == 7'd15) begin //15
        LED4 = 7'b1001111; 
        LED3 = 7'b0100100;
    end
    if(score == 7'd16) begin //16
        LED4 = 7'b1001111;
        LED3 = 7'b0100000;
    end
    if(score == 7'd17) begin //17
        LED4 = 7'b1001111;
        LED3 = 7'b0001111;
    end
    if(score == 7'd18) begin //18
        LED4 = 7'b1001111;
        LED3 = 7'b0000000;
    end
    if(score == 7'd19) begin //19
        LED4 = 7'b1001111;
        LED3 = 7'b0000100;
    end
    if(score == 7'd20) begin //20
        LED4 = 7'b0010010;
        LED3 = 7'b0000001;
    end
    if(score == 7'd21) begin //21
        LED4 = 7'b0010010;
        LED3 = 7'b1001111;
    end
    if(score == 7'd22) begin //22
        LED4 = 7'b0010010;
        LED3 = 7'b0010010;
    end
    if(score == 7'd23) begin //23
        LED4 = 7'b0010010;
        LED3 = 7'b0000110;
    end
    if(score == 7'd24) begin //24
        LED4 = 7'b0010010;
        LED3 = 7'b1001100;
    end
    if(score == 7'd25) begin //25
        LED4 = 7'b0010010;
        LED3 = 7'b0100100;
    end
    if(score == 7'd26) begin //26
        LED4 = 7'b0010010;
        LED3 = 7'b0100000;
    end
    if(score == 7'd27) begin //27
        LED4 = 7'b0010010;
        LED3 = 7'b0001111;
    end
    if(score == 7'd28) begin //28
        LED4 = 7'b0010010;
        LED3 = 7'b0000000;
    end
    if(score == 7'd29) begin //29
        LED4 = 7'b0010010;
        LED3 = 7'b0000100;
    end
    if(score == 7'd30) begin //30
        LED4 = 7'b0000110;
        LED3 = 7'b0000001;
    end
end
endmodule