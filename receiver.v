//RECEIVER
module receiver(
  input  logic       clk,
  input  logic       rst,
  input  logic       rdy_clr,
  input  logic       clk_enable,
  input  logic       rx,
  output logic       rdy,
  output logic [7:0] data_out
);
  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    START = 2'b01,
    DATA  = 2'b10,
    STOP  = 2'b11
  } state_t;

  state_t      state;
  logic [7:0]  data_copy;
  logic [3:0]  counter;
  logic [2:0]  bit_index;

  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      state     <= IDLE;
      data_copy <= 0;
      counter   <= 0;
      bit_index <= 0;
      rdy       <= 0;
    end
    else begin
      if(rdy_clr)
        rdy <= 0;
      case(state)
        IDLE: begin
          if(rx == 0) begin
            counter <= 0;
            state   <= START;
          end
        end
        START: begin
          if(clk_enable) begin
            if(counter == 7) begin
              counter <= 0;
              state   <= DATA;
            end
            else
              counter <= counter + 1;
          end
        end
        DATA: begin
          if(clk_enable) begin
            if(counter == 15) begin
              data_copy[bit_index] <= rx;
              counter <= 0;
              if(bit_index == 7) begin
                bit_index <= 0;
                state     <= STOP;
              end
              else
                bit_index <= bit_index + 1;
            end
            else
              counter <= counter + 1;
          end
        end
        STOP: begin
          if(clk_enable) begin
            if(counter == 15) begin
              rdy     <= 1;
              counter <= 0;
              state   <= IDLE;
            end
            else
              counter <= counter + 1;
          end
        end
      endcase
    end
  end
  assign data_out = data_copy;
endmodule
