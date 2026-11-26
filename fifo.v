`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Sakthimurugan V
// 
// Create Date: 11/23/2026 10:31:52 AM
// Module Name: sync_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sync_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [WIDTH-1:0] din,

    output reg [WIDTH-1:0] dout,
    output wire full,
    output wire empty
);

    // Pointer width calculation
    localparam ADDR_BITS = $clog2(DEPTH);
    localparam PTR_BITS  = ADDR_BITS + 1;

    // FIFO memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Read and write pointers
    reg [PTR_BITS-1:0] wptr;
    reg [PTR_BITS-1:0] rptr;

    // FIFO status flags
    assign empty = (wptr == rptr);

    assign full =
        (wptr[PTR_BITS-1] != rptr[PTR_BITS-1]) &&
        (wptr[ADDR_BITS-1:0] == rptr[ADDR_BITS-1:0]);

    // FIFO read and write operations
    always @(posedge clk) begin

        if (rst) begin
            wptr <= 0;
            rptr <= 0;
            dout <= 0;
        end

        else begin

            // Write operation
            if (wr_en && !full) begin
                mem[wptr[ADDR_BITS-1:0]] <= din;
                wptr <= wptr + 1'b1;
            end

            // Read operation
            if (rd_en && !empty) begin
                dout <= mem[rptr[ADDR_BITS-1:0]];
                rptr <= rptr + 1'b1;
            end

        end
    end

endmodule

