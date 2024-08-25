`timescale 1ns/1ns

module pwm_tb();

   reg           clk;
   reg           rst_n;
   reg  [DW-1:0] duty_cycle1;
   reg  [DW-1:0] duty_cycle2;
   wire          pwm1;
   wire          pwm2;
   wire [DW-1:0] phase_acc1;
   wire [DW-1:0] phase_acc2;

   localparam DW = 8;
   localparam CK_P = 10;

  pwm #( 
        .DW(DW)
       ) u1
       (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle1),
        .pwm(pwm1),
        .phase_acc(phase_acc1)
       );

  pwm #( 
        .DW(DW)
       ) u2
       (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle2),
        .pwm(pwm2),
        .phase_acc(phase_acc2)
       );



  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0,pwm_tb);
  end


  always begin
    #(CK_P/2) clk = ~clk;
  end

  initial begin
    clk   = 0;
    rst_n = 0;
    duty_cycle1 = 112;
    duty_cycle2 = 64;

    #15; 
    rst_n =1 ;

    #5000;
    $finish;
  end

  initial begin
    $monitor ("Time: %0t, clk: %b, rst_n: %b, pwm1: %b, pwm2: %b",
              $time,      clk,     rst_n,     pwm1,     pwm2     );    
  end
endmodule
