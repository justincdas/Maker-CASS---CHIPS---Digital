module pwm #( 
             parameter DW = 8
            )
            (
             input               clk,
             input               rst_n,
             input      [DW-1:0] duty_cycle,
             output reg          pwm,
             output reg [DW-1:0] phase_acc
            );

  reg [DW-1:0] phase_acc_nxt;
  reg          pwm_nxt;

  always@ (*) begin
    if(phase_acc >= duty_cycle) begin
      pwm_nxt <= 1'b1;
    end else begin
      pwm_nxt <= 1'b0;
    end

    phase_acc_nxt <= phase_acc + 1'b1;
  end

  always@ (posedge clk, negedge rst_n) begin
    if(rst_n == 1'b0) begin
      phase_acc <= {DW{1'b0}};
      pwm       <= 1'b0;
    end else begin
      phase_acc <= phase_acc_nxt; 
      pwm       <= pwm_nxt; 
    end
  end

endmodule
