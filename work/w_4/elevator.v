module elevator(
    input wire clk,
    input wire reset,
    input wire [15:0] floor_buttons, //onehot
    input wire door_open_button,
    input wire door_close_button,
    output reg [3:0] current_floor,
    output reg [3:0] floor_indicator,
    output      door_open,
    output     moving_up,
    output     moving_down
);

     
    localparam [3:0] IDLE = 4'd0;
    localparam [3:0] MOVING_UP = 4'd1;
    localparam [3:0] MOVING_DOWN = 4'd2;
    localparam [3:0] DOOR_OPENING = 4'd3;
    localparam [3:0] DOOR_OPEN = 4'd4;
    localparam [3:0] DOOR_CLOSING = 4'd5;

    reg [3:0] state, next_state;
    reg [5:0] timer;  
    reg [3:0] destination_floor;

    function [3:0] get_destination;
      input [15:0] buttons;
      integer i;
      begin
        get_destination = 0;
        for (i = 0; i < 15; i = i + 1)
          if (buttons[i]) get_destination = i;
      end
    endfunction


    always @(posedge clk or posedge reset) begin
      if (reset) begin
        state <= IDLE;
        timer <= 0;
      end else begin
        state <= next_state;
        if (state == DOOR_OPEN) 
          timer <= (timer < 60) ? timer + 1 : timer;
        else 
          timer <= 0;
      end
    end

    always @(posedge clk or posedge reset) begin
      if (reset) begin
          current_floor <= 4'd0;
      end else begin
        if(next_state == MOVING_UP) begin
          current_floor = current_floor + 4'b1;
        end else if(next_state == MOVING_DOWN) begin
          current_floor = current_floor - 4'b1;
        end
      end
    end

    wire [3:0] destination_floor_next = 
        (((state == IDLE) || (state == DOOR_OPEN) || (state == DOOR_OPENING) || (state == DOOR_CLOSING))
          && 
         (|floor_buttons && floor_buttons != (1 << current_floor))
        ) ? get_destination(floor_buttons)
          : destination_floor;

    always @(posedge clk or posedge reset) begin
      if (reset) begin
          destination_floor <= 4'd0;
      end else begin
           destination_floor <= destination_floor_next;
      end
    end

    assign moving_up   = (state == MOVING_UP);
    assign moving_down = (state == MOVING_DOWN);
    assign door_open   = (state == DOOR_OPEN);

    always @(*) begin
        next_state = state;
        floor_indicator = (1 << current_floor);
        
        case(state)
            IDLE: begin
                if (door_open_button) begin
                    next_state = DOOR_OPENING;
                end else  if (destination_floor_next > current_floor) begin
                    next_state = MOVING_UP;
                end else  if (destination_floor_next < current_floor) begin
                    next_state = MOVING_DOWN;
                end
            end
            
            MOVING_UP: begin
              if (current_floor == destination_floor) begin
                  next_state = DOOR_OPENING;
              end
            end
            
            MOVING_DOWN: begin
                if (current_floor == destination_floor) begin
                    next_state = DOOR_OPENING;
                end
            end
            
            DOOR_OPENING: begin
                next_state = DOOR_OPEN;
            end
            
            DOOR_OPEN: begin
                if (door_close_button || timer >= 60 || |floor_buttons) begin
                    next_state = DOOR_CLOSING;
                end
            end
            
            DOOR_CLOSING: begin
                if (door_open_button) begin
                    next_state = DOOR_OPENING;
                end else  if (destination_floor_next > current_floor) begin
                    next_state = MOVING_UP;
                end else  if (destination_floor_next < current_floor) begin
                    next_state = MOVING_DOWN;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end


endmodule
