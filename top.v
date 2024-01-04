module top(
   input clk,
   input rst,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output [6:0] LED,
   output [3:0] Anode,
   output hsync,
   output vsync,
   inout PS2_CLK,
   inout PS2_DATA
    );
   // TODO: Wire to Test
   wire new_ball, on_ball;
   wire [9:0] ballX, ballY;
   wire enable_ball, game_clk, game_state;
   wire start;
   wire jump_start;
   wire [4:0] elasped_time;
   wire [6:0] game_score;
   wire mouse_mid_1Pulse;
   wire mouse_left_1Pulse;
   wire mouse_right_1Pulse;
   //

   wire clk_25mHz;
   wire valid;
   wire [9:0] h_cnt; //640
   wire [9:0] v_cnt;  //480

   wire enable_mouse_display;
   wire [9:0] MOUSE_X_POS , MOUSE_Y_POS;
   wire MOUSE_LEFT , MOUSE_MIDDLE , MOUSE_RIGHT , MOUSE_NEW_EVENT;
   wire [3:0] mouse_cursor_red , mouse_cursor_green , mouse_cursor_blue;
    
   wire [11:0] mouse_pixel = {mouse_cursor_red, mouse_cursor_green, mouse_cursor_blue};

     clock_divisor_25mHz clk_wiz_0_inst(
      .clk(clk),
      .dclk(clk_25mHz)
    );

    //TODO: Timer test
   /*
   clock_divisor_game clk_game_inst(
      .clk(clk),
      .start(start),
      .dclk(game_clk),
      .elasped_time(elasped_time)
   );*/
   //////////////////////////////////////
   // Make stable 1 pulse mouse signals
   // Used for clickable items like targets
   Debounce_onePulse DB1(
      .clk(clk),
      .pushButton(MOUSE_MIDDLE),
      .signal(mouse_mid_1Pulse)
   );

   Debounce_onePulse DB2(
      .clk(clk),
      .pushButton(MOUSE_LEFT),
      .signal(mouse_left_1Pulse)
   );
   
   Debounce_onePulse DB3(
      .clk(clk),
      .pushButton(MOUSE_RIGHT),
      .signal(mouse_right_1Pulse)
   );
   //////////////////////////////////////
   seven_segment seven_inst(
      .clk(clk),
      .rst(rst),
      .elasped_time(elasped_time),
      .score(game_score),
      .Anode(Anode),
      .LED(LED)
   );

   game_start game_start_inst(
      .clk(clk),
      .trigger(mouse_right_1Pulse),
      .rst(rst),
      .elasped_time(elasped_time),
      .start(start),
      .jump_start(jump_start),
      .state(game_state)
   );

   game_score game_score_inst(
      .clk(clk),
      .rst(rst),
      .trigger(new_ball),
      .game_state(game_state),
      .start(start),
      .score(game_score)
   );

   // END TODO
   ball_gen ball_gen_inst(
      .clk(clk),
      .rst(rst),
      .new_ball(new_ball),
      .jump_start(jump_start),
      .ballX(ballX),
      .ballY(ballY)
   );

   ball_display ball_dis_inst(
      .clk(clk_25mHz),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .ballX(ballX),
      .ballY(ballY),
      .start(start),
      .enable_ball(enable_ball)
   );

   mouse_on_ball mouse_on_ball_inst(
      .BALL_X(ballX),
      .BALL_Y(ballY),
      .MOUSE_X_POS(MOUSE_X_POS),
      .MOUSE_Y_POS(MOUSE_Y_POS),
      .MOUSE_LEFT(mouse_left_1Pulse),
      .MOUSE_MIDDLE(mouse_mid_1Pulse),
      .start(start),
      .new_ball(new_ball)
   );

    //New pixel Gen with mouse inputs
    pixel_gen pixel_gen_inst(
       .h_cnt(h_cnt),
       .MOUSE_X_POS(MOUSE_X_POS),
       .MOUSE_Y_POS(MOUSE_Y_POS),
       .on_ball(on_ball),
       .valid(valid),
       .enable_mouse_display(enable_mouse_display),
       .enable_ball(enable_ball),
       .mouse_pixel(mouse_pixel),
       .MOUSE_LEFT(MOUSE_LEFT),
       .MOUSE_RIGHT(MOUSE_RIGHT),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue)
    );

    vga_controller   vga_inst(
      .pclk(clk_25mHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
   
   mouse mouse_ctrl_inst( //control mouse.
        .clk(clk),
        .h_cntr_reg(h_cnt),
        .v_cntr_reg(v_cnt),
        .enable_mouse_display(enable_mouse_display),
        .MOUSE_X_POS(MOUSE_X_POS),
        .MOUSE_Y_POS(MOUSE_Y_POS),
        .MOUSE_LEFT(MOUSE_LEFT),
        .MOUSE_MIDDLE(MOUSE_MIDDLE),
        .MOUSE_RIGHT(MOUSE_RIGHT),
        .MOUSE_NEW_EVENT(MOUSE_NEW_EVENT),
        .mouse_cursor_red(mouse_cursor_red),
        .mouse_cursor_green(mouse_cursor_green),
        .mouse_cursor_blue(mouse_cursor_blue),
        .PS2_CLK(PS2_CLK),
        .PS2_DATA(PS2_DATA)
    );
endmodule
