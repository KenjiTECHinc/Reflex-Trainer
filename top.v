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
   // TODO: Wire to Test --> All Pass
   wire new_ball;
   wire [9:0] ballX, ballY;
   wire enable_ball, game_clk;
   wire game_state;
   wire start;
   wire jump_start; //signal a start of a new game
   wire [4:0] elasped_time; //game-time played so far
   wire [6:0] game_score; //game score
   wire [6:0] home_score; //for displaying previous game's score in the start scene
   wire mouse_mid_1Pulse;
   wire mouse_left_1Pulse;
   wire mouse_right_1Pulse;
   
   wire [13:0] pixel_addr_start; //for displaying the start button in start scene
   wire [11:0] data;
   wire [11:0] pixel_start;
   wire enable_start;
   
   wire [13:0] pixel_addr_ten; //for displaying time
   wire [11:0] pixel_ten;
   wire enable_ten;
   wire enable_one;
   wire [13:0] pixel_addr_one;
   wire [11:0] pixel_one;

   wire [16:0] pixel_addr_score1; //for displaying score
   wire [16:0] pixel_addr_score10;
   wire enable_score_one, enable_score_ten;
   wire [11:0] pixel_score_one, pixel_score_ten;

   wire [13:0] pixel_addr_star; //for displaying the star image
   wire enable_star;
   wire [11:0] pixel_star;
   //

   wire clk_25MHz;
   wire valid;
   wire [9:0] h_cnt; //640
   wire [9:0] v_cnt;  //480

   wire enable_mouse_display;
   wire [9:0] MOUSE_X_POS , MOUSE_Y_POS;
   wire MOUSE_LEFT , MOUSE_MIDDLE , MOUSE_RIGHT , MOUSE_NEW_EVENT;
   wire [3:0] mouse_cursor_red , mouse_cursor_green , mouse_cursor_blue;
    
   wire [11:0] mouse_pixel = {mouse_cursor_red, mouse_cursor_green, mouse_cursor_blue};

   //////////////////////////////////////
   // 25MHz clock for the VGA display
   // Also used on other modules that works with VGA.
   clock_divisor_25mHz clk_wiz_0_inst(
      .clk(clk),
      .dclk(clk_25MHz)
    );
   //////////////////////////////////////
   // Make stable 1 pulse mouse signals
   // Used for one-click items like the targets
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
   // IP modules for fetching pixel color codes from COE file.
   // external IP modules from XILINX
   blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_start),
      .dina(data[11:0]),
      .douta(pixel_start)
    );

   blk_mem_gen_ten blk_mem_gen_ten_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_ten),
      .dina(data[11:0]),
      .douta(pixel_ten)
    );

   blk_mem_gen_one blk_mem_gen_one_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_one),
      .dina(data[11:0]),
      .douta(pixel_one)
    );

    blk_mem_gen_score1 blk_mem_gen_score1_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_score1),
      .dina(data[11:0]),
      .douta(pixel_score_one)
    );

    blk_mem_gen_score10 blk_mem_gen_score10_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_score10),
      .dina(data[11:0]),
      .douta(pixel_score_ten)
    );

    blk_mem_gen_star blk_mem_gen_star_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr_star),
      .dina(data[11:0]),
      .douta(pixel_star)
    );
   //////////////////////////////////////
   // Seven segment
   seven_segment seven_inst(
      .clk(clk),
      .rst(rst),
      .elasped_time(elasped_time),
      .score(game_score),
      .Anode(Anode),
      .LED(LED)
   );
   //////////////////////////////////////
   // GAME LOGIC
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
      .score(game_score),
      .home_score(home_score),
      .BALL_X(ballX),
      .BALL_Y(ballY)
   );

   ball_gen ball_gen_inst(
      .clk(clk),
      .rst(rst),
      .new_ball(new_ball),
      .jump_start(jump_start),
      .ballX(ballX),
      .ballY(ballY)
   );
   //////////////////////////////////////
   //DISPLAYS
   ball_display ball_dis_inst(
      .clk(clk_25MHz),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .ballX(ballX),
      .ballY(ballY),
      .start(start),
      .enable_ball(enable_ball)
   );
   
   start_display start_dis_inst(
      .clk(clk_25MHz),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt),
      .start(start),
      .enable_start(enable_start),
      .pixel_addr_start(pixel_addr_start)
   );

   time_display time_dis_inst(
      .clk(clk_25MHz), 
      .h_cnt(h_cnt), 
      .v_cnt(v_cnt), 
      .elasped_time(elasped_time), 
      .pixel_addr_ten(pixel_addr_ten), 
      .enable_ten(enable_ten),
      .enable_one(enable_one),
      .pixel_addr_one(pixel_addr_one)
   );

   score_display score_dis_inst(
      .clk(clk_25MHz), 
      .h_cnt(h_cnt), 
      .v_cnt(v_cnt), 
      .score(home_score), 
      .enable_score_ten(enable_score_ten), 
      .enable_score_one(enable_score_one), 
      .pixel_addr_score1(pixel_addr_score1), 
      .pixel_addr_score10(pixel_addr_score10)
   );

   star_display star_dis_inst(
      .clk(clk_25MHz), 
      .h_cnt(h_cnt), 
      .v_cnt(v_cnt), 
      .enable_star(enable_star), 
      .pixel_addr_star(pixel_addr_star)
   );
   //////////////////////////////////////
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
       .clk_25MHz(clk_25MHz),
       .h_cnt(h_cnt),
       .v_cnt(v_cnt),
       .MOUSE_X_POS(MOUSE_X_POS),
       .MOUSE_Y_POS(MOUSE_Y_POS),
       .valid(valid),
       .enable_mouse_display(enable_mouse_display),
       .enable_ball(enable_ball),
       .mouse_pixel(mouse_pixel),
       .MOUSE_LEFT(MOUSE_LEFT),
       .MOUSE_RIGHT(MOUSE_RIGHT),
       .game_state(game_state),
       .enable_start(enable_start),
       .pixel_start(pixel_start),
       .enable_ten(enable_ten),
       .pixel_ten(pixel_ten),
       .enable_one(enable_one),
       .pixel_one(pixel_one),
       .pixel_score_one(pixel_score_one),
       .enable_score_one(enable_score_one),
       .pixel_score_ten(pixel_score_ten),
       .enable_score_ten(enable_score_ten),
       .enable_star(enable_star),
       .pixel_star(pixel_star),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue)
    );

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
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

    //TODO: Timer test
   /*
   clock_divisor_game clk_game_inst(
      .clk(clk),
      .start(start),
      .dclk(game_clk),
      .elasped_time(elasped_time)
   );*/
endmodule
