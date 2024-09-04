module elevator_tb;
    reg clk;
    reg reset;
    reg [15:0] floor_buttons;
    reg door_open_button;
    reg door_close_button;
    wire [3:0] current_floor;
    wire [3:0] floor_indicator;
    wire door_open;
    wire moving_up;
    wire moving_down;

    elevator dut(
        .clk(clk),
        .reset(reset),
        .floor_buttons(floor_buttons),
        .door_open_button(door_open_button),
        .door_close_button(door_close_button),
        .current_floor(current_floor),
        .floor_indicator(floor_indicator),
        .door_open(door_open),
        .moving_up(moving_up),
        .moving_down(moving_down)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, elevator_tb);

        reset = 1;
        floor_buttons = 0;
        door_open_button = 0;
        door_close_button = 0;

        #10 reset = 0;

        #10 floor_buttons = 16'b1000;
        #10 floor_buttons = 16'b0000;
        
        #200;

        #10 floor_buttons = 16'b0001;
        #10 floor_buttons = 16'b0000;

        #200;

        #10 door_open_button = 1;
        #10 door_open_button = 0;
        #100 door_close_button = 1;
        #10 door_close_button = 0;
        #10 door_open_button = 1;
        #10 door_open_button = 0;
        #700; 
        $finish;
    end

    initial begin
        $monitor("Time=%0t, Floor=%d, Indicator=%b, Door=%b, Up=%b, Down=%b", 
                 $time, current_floor, floor_indicator, door_open, moving_up, moving_down);
    end

endmodule
