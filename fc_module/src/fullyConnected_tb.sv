module fullyConnectedLayer1_tb # ( parameter WORD_SIZE = 16, IP_LAYER_SIZE = 128, OP_LAYER_SIZE = 84, TEST_CASES_NUM = 10)();
    reg clk, reset; // clock and reset are internal
    reg [WORD_SIZE-1 : 0] input_layer [IP_LAYER_SIZE-1 : 0];
    reg [WORD_SIZE-1 : 0] weight [OP_LAYER_SIZE-1 : 0][IP_LAYER_SIZE-1 : 0]; 
    reg [WORD_SIZE-1 : 0] bias [OP_LAYER_SIZE-1 : 0];
    
    reg [WORD_SIZE-1 : 0] resultExpected [OP_LAYER_SIZE-1 : 0]; // values from testvectors
    wire [WORD_SIZE-1 : 0] output_layer [OP_LAYER_SIZE-1 : 0]; // output of circuit

    reg [$clog2(TEST_CASES_NUM):0] vectornum, errors; // bookkeeping variables
    reg [(WORD_SIZE*IP_LAYER_SIZE + OP_LAYER_SIZE)-1:0] testvectors[TEST_CASES_NUM-1:0];// array of testvectors
	
    
    // instantiate device under test
    fullyConnected #(WORD_SIZE, IP_LAYER_SIZE, OP_LAYER_SIZE) myFullyConnected(.Z(output_layer), .X(input_layer), .W(weight), .B(bias));
    // generate clock
    always // no sensitivity list, so it always executes
    begin
        clk = 1; #5; clk = 0; #5; // 10ns period
    end

    // at start of test, load vectors
    // and pulse reset
    initial // Will execute at the beginning once
        begin
        $readmemb("generated_cases_fullyConnected.tv", testvectors); // Read vectors
        vectornum = 0; errors = 0; // Initialize 
        reset = 1; #27; reset = 0; // Apply reset wait
    end

    integer k;

    // Note: $readmemh reads testvector files written in
    // hexadecimal
    always @(posedge clk)
    begin
        //#1; {input_layer, resultExpected} = testvectors[vectornum];
        #1; 
        
        resultExpected = testvectors[vectornum][OP_LAYER_SIZE-1:0];
        
        for(k = LAYER_SIZE-1; k >= 0; k = k - 1) begin
            input_layer[k] = testvectors[vectornum][(IP_LAYER_SIZE*WORD_SIZE + OP_LAYER_SIZE)-1:OP_LAYER_SIZE];
        end
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