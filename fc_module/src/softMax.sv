module softMax#(
    parameter WORD_SIZE = 16,
    parameter LAYER_SIZE = 10
    )
    (
    output [$clog2(LAYER_SIZE)-1 : 0] Z,
	input  [WORD_SIZE-1 : 0] X [LAYER_SIZE-1 : 0]
    );

    parameter N = $clog2(LAYER_SIZE);
    reg [N-1 : 0] Dom[LAYER_SIZE-1 : 0];
    reg [WORD_SIZE-1 : 0] resVal [LAYER_SIZE-1 : 0];
    reg [N-1 : 0] resIdx [LAYER_SIZE-1 : 0];
    integer k;
    genvar i;

    always begin
        for(k = 0; k < LAYER_SIZE; k = k + 1) begin
            Dom[k] = k[N-1 : 0];
        end
        resVal[0] = X[0];
        resIdx[0] = Dom[0];
    end
    
    generate 

        for(i = 1 ; i < LAYER_SIZE; i = i + 1) begin : getMax
            Comparator#(WORD_SIZE, N) comp(X[i], Dom[i], resVal[i-1], resIdx[i-1], resVal[i], resIdx[i]);
        end
    endgenerate

    assign Z = resIdx[LAYER_SIZE-1];
endmodule