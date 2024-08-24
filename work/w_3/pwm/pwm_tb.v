module pwm_tb();

  reg        clk;
  wire [3:0] pwm_out;

  pwm dut(
          .clk(clk),
          .pwm_out(pwm_out)
         );


  initial begin
    $dumpfile("test_pwm.vcd");
    $dumpvars(0,pwm_tb);

    clk = 0;
    forever #5 clk= ~clk;

    #5000 $finish;
  end

endmodule
