`timescale 1ns/1ns

module pwm_tb();

  reg        clk;
  reg        rst_n;
  wire [3:0] pwm_out;


  pwm dut(
          .clk(clk),
          .rst_n(rst_n),
          .pwm_out(pwm_out)
         );


  initial begin
    clk = 0;
    rst_n = 0;
    #5 rst_n =1;

    forever #5 clk= ~clk;
  end

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0,pwm_tb);

    #5000 $finish;
  end


endmodule
