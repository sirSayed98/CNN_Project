module FC #(
    parameter WORD_SIZE = 16,
    parameter IP_LAYER_SIZE = 128,
    parameter OP_LAYER_SIZE = 84,
    parameter INT_SLICE = 8
) (
    output [3 : 0] result, //result of  
    input  cnnDone // signal coming from CNN 
    //input  [WORD_SIZE-1 : 0] address 
);
reg  en_fc; 
//------------------layer1 of FC----------------
// fetching from ram
reg  [WORD_SIZE-1 : 0] X_Layer1_temp [IP_LAYER_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] W_Layer1_temp [OP_LAYER_SIZE-1 : 0][IP_LAYER_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] B_Layer1_temp [OP_LAYER_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] out_layer1 [OP_LAYER_SIZE-1 : 0];

reg  [WORD_SIZE-1 : 0] X_Layer1 [IP_LAYER_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] W_Layer1 [OP_LAYER_SIZE-1 : 0][IP_LAYER_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] B_Layer1 [OP_LAYER_SIZE-1 : 0];


//------------------layer2 of FC----------------
// coming from layer1
parameter  IP_LAYER2_SIZE = 84;
parameter  OP_LAYER2_SIZE = 10;

reg  [WORD_SIZE-1 : 0] X_Layer2_temp [IP_LAYER2_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] W_Layer2_temp [OP_LAYER2_SIZE-1 : 0][IP_LAYER2_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] B_Layer2_temp [OP_LAYER2_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] out_layer2 [OP_LAYER_SIZE-1 : 0];

reg  [WORD_SIZE-1 : 0] X_Layer2 [IP_LAYER2_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] W_Layer2 [OP_LAYER2_SIZE-1 : 0][IP_LAYER2_SIZE-1 : 0];
reg  [WORD_SIZE-1 : 0] B_Layer2 [OP_LAYER2_SIZE-1 : 0];

//--------------------RAM----------------
reg [WORD_SIZE-1 : 0] address; //= start address of output from cnn
reg fetching_is_finished; // used this signal to allow write at layer1
//--------------------DMA----------------------

DMA #(WORD_SIZE, IP_LAYER_SIZE, OP_LAYER_SIZE) myDMA
(
    .fetch_from_ram(cnnDone), 
    .X(X_Layer1_temp),
    .W_Layer1(W_Layer1_temp), 
    .B_Layer1(B_Layer1_temp), 
    .W_Layer2(W_Layer2_temp), 
    .B_Layer2(B_Layer2_temp),
    .enFC(en_fc)
);

fullyConnected #(WORD_SIZE, IP_LAYER_SIZE, OP_LAYER_SIZE) myFullyConnected_layer1
(
    .Z(out_layer1),
    .X(X_Layer1),
    .W(W_Layer1), 
    .B(B_Layer1)
);
fullyConnected #(WORD_SIZE, IP_LAYER2_SIZE, OP_LAYER2_SIZE) myFullyConnected_layer2
(
    .Z(out_layer2), 
    .X(X_Layer2), 
    .W(W_Layer2), 
    .B(B_Layer2)
);
softMax #(WORD_SIZE, OP_LAYER2_SIZE) mySoftMax
(
    
    .X(out_layer2),
    .Z(result) 
    
);

always @(en_fc) begin
    
    if(en_fc) begin
        X_Layer1 = X_Layer1_temp; 
        W_Layer1 = W_Layer1_temp;
        B_Layer1 = B_Layer1_temp;

        X_Layer2 = out_layer1; 
        W_Layer2 = W_Layer2_temp;
        B_Layer2 = B_Layer2_temp;
    end
    // else ??

end 


    
endmodule