//TRANSMITTER
module transmitter(
  input  logic       clk,
  input  logic       wr_enable,
  input  logic       enable,
  input  logic       rst,
  input  logic [7:0] data_in,
  output logic       tx_out,
  output logic       busy
);
  typedef enum logic [1:0] {
    IDLE  = 2'b00,
    START = 2'b01,
    DATA  = 2'b10,
    STOP  = 2'b11
  } state_t;

  state_t      state;
  logic [2:0]  counter;
  logic [7:0]  data_copy;

  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      state     <= IDLE;
      busy      <= 0;
      tx_out    <= 1;
      counter   <= 0;
      data_copy <= 0;
    end
    else begin
      case(state)
        IDLE: begin
          tx_out <= 1;
          busy   <= 0;
          if(wr_enable) begin
            data_copy <= data_in;
            state     <= START;
          end
        end
        START: begin
          tx_out <= 0;
          busy   <= 1;
          if(enable)
            state <= DATA;
        end
        DATA: begin
          tx_out <= data_copy[counter];
          busy   <= 1;
          if(enable) begin
            if(counter == 7) begin
              counter <= 0;
              state   <= STOP;
            end
            else
              counter <= counter + 1;
          end
        end
        STOP: begin
          tx_out <= 1;
          busy   <= 1;
          if(enable)
            state <= IDLE;
        end
      endcase
    end
  end
endmodule
