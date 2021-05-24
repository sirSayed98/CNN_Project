module softmax_tb # ( parameter WORD_SIZE = 16, LAYER_SIZE = 10, TEST_CASES_NUM = 10)();
    reg clk, reset; // clock and reset are internal
    reg  [WORD_SIZE-1:0] input_layer [LAYER_SIZE-1:0]; 
    reg [$clog2(LAYER_SIZE)-1:0] resultExpected; // values from testvectors
    wire [$clog2(LAYER_SIZE)-1:0] circuit_output; // output of circuit
    reg [LAYER_SIZE-1:0] vectornum, errors; // bookkeeping variables
    reg [(WORD_SIZE*LAYER_SIZE + $clog2(LAYER_SIZE))-1:0] testvectors[TEST_CASES_NUM-1:0];// array of testvectors

    // reg  [3:0]a, b; 
    // reg [7:0]resultExpected; // values from testvectors
    // wire [7:0]c; // output of circuit
    // reg [8:0] vectornum, errors; // bookkeeping variables
    // reg [15:0] testvectors[255:0];// array of testvectors
    // instantiate device under test


    wire  [WORD_SIZE-1:0] input_layer_wire [LAYER_SIZE-1:0]; 

//
    assign input_layer_wire = input_layer;
// remove

    
    //resultBuffer = {(N*2){1'b0}};
    softMax #(WORD_SIZE, LAYER_SIZE) mySoftmax(.Z(circuit_output), .X(input_layer));
    /*softMax #(WORD_SIZE, LAYER_SIZE) mySoftmax(.Z(circuit_output),.X({
        {16'b1010101010111111},
        {16'b1010101010110111},
        {16'b1010101010110111},
        {16'b1010101010101111},
        {16'b1010101010111111},
        {16'b1010101010111011},
        {16'b1010101010111111},
        {16'b1010101010011111},
        {16'b1010101010101111},
        {16'b1010101010110111}
    }));*/
    // generate clock
    always // no sensitivity list, so it always executes
    begin
        clk = 1; #5; clk = 0; #5; // 10ns period
    end

    // at start of test, load vectors
    // and pulse reset
    initial // Will execute at the beginning once
        begin
        $readmemb("generated_cases_softmax_rand.tv", testvectors); // Read vectors
        vectornum = 0; errors = 0; // Initialize 
        reset = 1; #1; reset = 0; // Apply reset wait
    end

    integer k;

    // Note: $readmemh reads testvector files written in
    // hexadecimal
    always @(posedge clk)
    begin
        //#1; {input_layer, resultExpected} = testvectors[vectornum];
        #1; 
        
        resultExpected = testvectors[vectornum][$clog2(LAYER_SIZE)-1:0];
        
      

        
        for(k = LAYER_SIZE-1; k >= 0; k = k - 1) begin
            input_layer[k] = testvectors[vectornum][((k+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
            //((k+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 : ((k+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 - WORD_SIZE
        end

        //#1; 

        // input_layer[0] = testvectors[vectornum][((0+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[1] = testvectors[vectornum][((1+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[2] = testvectors[vectornum][((2+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[3] = testvectors[vectornum][((3+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[4] = testvectors[vectornum][((4+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[5] = testvectors[vectornum][((5+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[6] = testvectors[vectornum][((6+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[7] = testvectors[vectornum][((7+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[8] = testvectors[vectornum][((8+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
        // input_layer[9] = testvectors[vectornum][((9+1)*WORD_SIZE + $clog2(LAYER_SIZE))-1 -: WORD_SIZE];
    end
    // check results on falling edge of clk
    always @(negedge clk)
    begin
        if (~reset) // skip during reset
        begin
            if (circuit_output !== resultExpected) 
            begin
                $display("Error: TestCaseNumber = %b, outputs = %b (%b exp)", vectornum, circuit_output, resultExpected);
                errors = errors + 1;
            end

            // Note: to print in hexadecimal, use %h. For example,
            // $display(“Error: inputs = %h”, {a, b, c});
            // increment array index and read next testvector
            vectornum = vectornum + 1;
            if (vectornum === TEST_CASES_NUM)
            //if (vectornum === 9'b100000000)
            begin 
                $display("%d tests completed with %d errors", 
                vectornum, errors);
                $stop; // End simulation 
            end
        end    
    end

endmodule 