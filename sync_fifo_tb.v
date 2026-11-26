`timescale 1ns / 1ps

module sync_fifo_tb;

    parameter DEPTH = 16;
    parameter WIDTH = 8;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [WIDTH-1:0] din;

    wire [WIDTH-1:0] dout;
    wire full;
    wire empty;

    integer i;
    integer errors = 0;

    sync_fifo #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    initial begin

        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        $display("       FIFO TEST STARTED");
        repeat(3) @(posedge clk);

        @(negedge clk);
        rst = 0;

        @(posedge clk);
        #1;

        if (empty !== 1'b1 || full !== 1'b0) begin
            $display("ERROR: Initial FIFO status incorrect");
            errors = errors + 1;
        end
        else begin
            $display("PASS: FIFO reset successful");
        end

        // TEST 1: WRITE 16 DATA VALUES

        $display("\nTEST 1: FIFO WRITE");

        for (i = 0; i < DEPTH; i = i + 1) begin

            @(negedge clk);
            wr_en = 1;
            din = i + 10;

            @(posedge clk);
            #1;

            $display("WRITE: Data=%0d, FULL=%b, EMPTY=%b",
                     din, full, empty);
        end

        @(negedge clk);
        wr_en = 0;
        din = 0;

        @(posedge clk);
        #1;

        if (full !== 1'b1) begin
            $display("ERROR: FIFO did not become FULL");
            errors = errors + 1;
        end
        else begin
            $display("PASS: FIFO FULL flag correct");
        end

        // TEST 2: READ 16 DATA VALUES

        $display("\nTEST 2: FIFO READ");

        for (i = 0; i < DEPTH; i = i + 1) begin

            @(negedge clk);
            rd_en = 1;

            @(posedge clk);
            #1;

            if (dout !== (i + 10)) begin
                $display("ERROR: Expected=%0d, Got=%0d",
                         i + 10, dout);
                errors = errors + 1;
            end
            else begin
                $display("READ: Data=%0d PASS", dout);
            end
        end

        @(negedge clk);
        rd_en = 0;

        @(posedge clk);
        #1;

        if (empty !== 1'b1) begin
            $display("ERROR: FIFO did not become EMPTY");
            errors = errors + 1;
        end
        else begin
            $display("PASS: FIFO EMPTY flag correct");
        end

        // FINAL RESULT

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;

    end

endmodule