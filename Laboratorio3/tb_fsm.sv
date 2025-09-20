`timescale 1ns/1ps
module tb_fsm;
  logic clk, rst_n;
  logic start_btn, t_done;
  logic show_cards, t_start, t_clear, in_timeup;

  // Reloj 100 MHz sim
  initial clk=0; always #5 clk=~clk;

  game_fsm dut(
    .clk(clk), .rst_n(rst_n),
    .start_btn(start_btn), .t_done(t_done),
    .show_cards(show_cards), .t_start(t_start),
    .t_clear(t_clear), .in_timeup(in_timeup)
  );

  task tick(int n); begin repeat(n) @(posedge clk); end endtask;
  task pulse_start; begin start_btn=1; @(posedge clk); start_btn=0; end endtask;

  initial begin
    // Reset
    rst_n=0; start_btn=0; t_done=0; tick(3); rst_n=1; tick(1);
    assert(in_timeup==0 && show_cards==0);

    // IDLE -> PLAY con start
    pulse_start; tick(1);
    assert(t_clear==1) else $fatal("No limpia timer al iniciar");
    tick(1);
    assert(t_start==1 && show_cards==1) else $fatal("No arrancó juego en PLAY");

    // PLAY -> TIMEUP con t_done
    t_done=1; tick(1); t_done=0; tick(1);
    assert(in_timeup==1) else $fatal("No entró a TIMEUP");

    // TIMEUP -> PLAY con otro start
    pulse_start; tick(1);
    assert(t_clear==1); tick(1);
    assert(show_cards==1 && t_start==1);

    $display("✅ TB FSM OK");
    $finish;
  end
endmodule
