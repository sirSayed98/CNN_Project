module DMA #(
    parameter WORD_SIZE = 16,
    parameter IP_LAYER1_SIZE = 128,
    parameter OP_LAYER1_SIZE = 84,
    parameter IP_LAYER2_SIZE = 84,
    parameter OP_LAYER2_SIZE = 10
    
) (
    input  fetch_from_ram,
    output [WORD_SIZE-1 : 0] X [IP_LAYER1_SIZE-1 : 0],
    output [WORD_SIZE-1 : 0] W_Layer1 [OP_LAYER1_SIZE-1 : 0][IP_LAYER1_SIZE-1 : 0],
    output [WORD_SIZE-1 : 0] B_Layer1 [OP_LAYER1_SIZE-1 : 0],
    output [WORD_SIZE-1 : 0] W_Layer2 [OP_LAYER2_SIZE-1 : 0][IP_LAYER2_SIZE-1 : 0],
    output [WORD_SIZE-1 : 0] B_Layer2 [OP_LAYER2_SIZE-1 : 0],
    output enFC
);
//---------------regs of X and W and B----------------
/*
reg [WORD_SIZE-1 : 0] X_reg [IP_LAYER1_SIZE-1 : 0];
reg [WORD_SIZE-1 : 0] W_Layer1_reg [OP_LAYER1_SIZE-1 : 0][IP_LAYER1_SIZE-1 : 0];
reg [WORD_SIZE-1 : 0] B_Layer1_reg [OP_LAYER1_SIZE-1 : 0];
reg [WORD_SIZE-1 : 0] W_Layer2_reg [OP_LAYER2_SIZE-1 : 0][IP_LAYER2_SIZE-1 : 0];
reg [WORD_SIZE-1 : 0] B_Layer2_reg [OP_LAYER2_SIZE-1 : 0];
//---------------------ram-------------------------------
reg clk;
reg reset;
parameter ADDRESS_SIZE = 16;
reg [WORD_SIZE-1 : 0] address; //start address of result from cnn

//always @(posedge clk) begin
//     if(fetch_from_ram )
//     {
        
//     }
    
// end
assign X =  X_reg;
assign W_Layer1 =  W_Layer1_reg; 
assign B_Layer1 =  B_Layer1_reg;
assign W_Layer2 =  W_Layer2_reg;  
assign B_Layer2 =  B_Layer2_reg;  
assign enFC = 1;
*/
endmodule