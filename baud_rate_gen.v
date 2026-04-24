//BAUD RATE GENERATOR 
module baud_rate_gen #(
  parameter freq      = 50000000,
  parameter baud_rate = 115200
)(
  input  logic clk,
  input  logic rst,
  output logic tx_enable,
  output logic rx_enable
);
  localparam tx_cycles = freq / baud_rate;
  localparam rx_cycles = tx_cycles / 16;

  logic [$clog2(tx_cycles)-1:0] tx_counter;
  logic [$clog2(rx_cycles)-1:0] rx_counter;

  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      tx_counter <= 0;
      rx_counter <= 0;
      tx_enable  <= 0;
      rx_enable  <= 0;
    end
    else begin
      if(tx_counter == tx_cycles-1) begin
        tx_counter <= 0;
        tx_enable  <= 1;
      end
      else begin
        tx_counter <= tx_counter + 1;
        tx_enable  <= 0;
      end
      if(rx_counter == rx_cycles-1) begin
        rx_counter <= 0;
        rx_enable  <= 1;
      end
      else begin
        rx_counter <= rx_counter + 1;
        rx_enable  <= 0;
      end
    end
  end
endmodule
