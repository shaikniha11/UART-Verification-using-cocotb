// UART TOP MODULE
module uart_top(
  input  logic       clk,
  input  logic       rst,
  input  logic       wr_enable,
  input  logic       rd_enable,
  input  logic [7:0] data_in,
  output logic [7:0] data_out,
  output logic       tx_out,
  input  logic       rx,
  output logic       tx_full,
  output logic       rx_empty
);
  logic tx_enable;
  logic rx_enable;
  logic [7:0] tx_data;
  logic tx_fifo_empty;
  logic tx_fifo_full;
  logic tx_busy;
  logic [7:0] rx_data;
  logic rx_ready;
  logic rx_fifo_full;
  logic rx_fifo_empty;

  baud_rate_gen baud_inst(
    .clk       (clk),
    .rst       (rst),
    .tx_enable (tx_enable),
    .rx_enable (rx_enable)
  );

  sync_fifo tx_fifo(
    .clk        (clk),
    .rst        (rst),
    .wr_enable  (wr_enable),
    .rd_enable  (!tx_busy),
    .data_in    (data_in),
    .data_out   (tx_data),
    .fifo_full  (tx_fifo_full),
    .fifo_empty (tx_fifo_empty)
  );

  transmitter trans_inst(
    .clk       (clk),
    .rst       (rst),
    .wr_enable (!tx_fifo_empty),
    .enable    (tx_enable),
    .data_in   (tx_data),
    .tx_out    (tx_out),
    .busy      (tx_busy)
  );

  receiver rece_inst(
    .clk        (clk),
    .rst        (rst),
    .rdy_clr    (1'b0),
    .clk_enable (rx_enable),
    .rx         (rx),
    .rdy        (rx_ready),
    .data_out   (rx_data)
  );

  sync_fifo rx_fifo(
    .clk        (clk),
    .rst        (rst),
    .wr_enable  (rx_ready),
    .rd_enable  (rd_enable),
    .data_in    (rx_data),
    .data_out   (data_out),
    .fifo_full  (rx_fifo_full),
    .fifo_empty (rx_fifo_empty)
  );

  assign tx_full  = tx_fifo_full;
  assign rx_empty = rx_fifo_empty;
endmodule
