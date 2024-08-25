module pwm (
            input            clk,
            input            rst_n,
            output reg [3:0] pwm_out
           );

  reg [6:0] cntr = 0;

  always@ (posedge clk, negedge rst_n) begin
    if(rst_n == 1'b0) begin
      cntr    <= 7'b0;
      pwm_out <= 4'b0;
    end else begin
      cntr <= cntr+1;

      if (cntr < 100) begin
        pwm_out[0] <= (cntr < 25 ) ? 1'b1 : 1'b0;
        pwm_out[1] <= (cntr < 50 ) ? 1'b1 : 1'b0;
        pwm_out[2] <= (cntr < 75 ) ? 1'b1 : 1'b0;
        pwm_out[3] <= (cntr < 90 ) ? 1'b1 : 1'b0;
      end else  begin
        cntr <= 0;
      end
   end
  end
endmodule
