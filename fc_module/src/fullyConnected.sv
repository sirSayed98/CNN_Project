module fullyConnected#(
    parameter WORD_SIZE = 16,
    parameter LAYER_SIZE = 128,
    parameter INT_SLICE = 8
    )
    (
    output [WORD_SIZE-1 : 0] Z [LAYER_SIZE-1 : 0],
	input  [WORD_SIZE-1 : 0] X [LAYER_SIZE-1 : 0],
    input  [WORD_SIZE-1 : 0] W [LAYER_SIZE-1 : 0][LAYER_SIZE-1 : 0],
    input  [WORD_SIZE-1 : 0] B [LAYER_SIZE-1 : 0]
    );
    parameter DEC_SLICE = WORD_SIZE - INT_SLICE;

    reg [WORD_SIZE-1 : 0] res [LAYER_SIZE-1 : 0];
    reg [2*WORD_SIZE-1 : 0] intrmd [LAYER_SIZE-1 : 0][LAYER_SIZE-1 : 0];
    reg [2*WORD_SIZE-1 : 0] intrmdinv [LAYER_SIZE-1 : 0][LAYER_SIZE-1 : 0];
    reg [WORD_SIZE-1 : 0] prod [LAYER_SIZE-1 : 0][LAYER_SIZE-1 : 0];
    reg [WORD_SIZE-1 : 0] prodinv [LAYER_SIZE-1 : 0][LAYER_SIZE-1 : 0];
    
    integer i,j;
	always begin
        for(i = 0 ; i < LAYER_SIZE ; i = i + 1) begin
            res[i] = 0;
            for(j = 0 ; j < LAYER_SIZE ; j = j + 1) begin
                intrmd[i][j] = X[i] * W[i][j];
                if(intrmd[i][j][WORD_SIZE-1]) begin
                    intrmdinv[i][j] = ~intrmd[i][j] + 1; // 2's compliment
                    prodinv[i][j] = intrmdinv[i][j][WORD_SIZE+INT_SLICE-1 : WORD_SIZE-DEC_SLICE];
                    prod[i][j] = ~prodinv[i][j] + 1; // 2's compliment
                end
                else begin
                    prod[i][j] = intrmd[i][j][WORD_SIZE+INT_SLICE-1 : WORD_SIZE-DEC_SLICE];
                end
                res[i] = res[i] + prod[i][j];
            end
            res[i] = res[i] + B[i];
        end
    end
    assign Z = res;
endmodule