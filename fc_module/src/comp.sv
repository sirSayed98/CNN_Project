module Comparator#(
    parameter WORD_SIZE = 16,
    parameter IDX_SIZE = 4
    )
    (
    input [WORD_SIZE-1 : 0] X1,
    input [IDX_SIZE-1 : 0] indexX1,
    input [WORD_SIZE-1 : 0] X2,
    input [IDX_SIZE-1 : 0] indexX2,
    output [WORD_SIZE-1 : 0] Y,
    output [IDX_SIZE-1 : 0] indexY
    );

reg [WORD_SIZE-1 : 0] maxVal;
reg [IDX_SIZE-1 : 0] maxIdx;
always begin
    if (X1 > X2) begin
        maxVal = X1;
        maxIdx = indexX1;
    end
    else begin
        maxVal = X2;
        maxIdx = indexX2;
    end
end

assign Y = maxVal;
assign indexY = maxIdx;
endmodule