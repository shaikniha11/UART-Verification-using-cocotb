module sync_fifo(
  input  logic       clk,
  input  logic       rst,
  input  logic       wr_enable,
  input  logic       rd_enable,
  input  logic [7:0] data_in,
  output logic [7:0] data_out,
  output logic       fifo_full,
  output logic       fifo_empty
);
  logic [7:0] mem [0:7];
  logic [2:0] wr_ptr;
  logic [2:0] rd_ptr;
  logic [3:0] count;

  always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count  <= 0;
    end
    else begin
      case({wr_enable & ~fifo_full, rd_enable & ~fifo_empty})
        2'b10: begin
          mem[wr_ptr] <= data_in;
          wr_ptr      <= wr_ptr + 1;
          count       <= count + 1;
        end
        2'b01: begin
          rd_ptr <= rd_ptr + 1;
          count  <= count - 1;
        end
        2'b11: begin
          mem[wr_ptr] <= data_in;
          wr_ptr      <= wr_ptr + 1;
          rd_ptr      <= rd_ptr + 1;
        end
        default: ;
      endcase
    end
  end

  assign fifo_full  = (count == 8);
  assign fifo_empty = (count == 0);
  assign data_out   = mem[rd_ptr];
endmodule
