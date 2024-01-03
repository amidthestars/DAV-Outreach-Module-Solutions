`timescale 1ns/1ns
module miniALU_tb(
	output [19:0] result
);

	reg [3:0] operand1;
	reg [3:0] operand2;
	reg select;
	
	miniALU UUT(operand1, operand2, select, result);
	
	reg [9:0] switches;
	initial begin
		for (integer i = 0; i < 16; i = i + 1) begin
			operand1 = i;
			
			for (integer j = 0; j < 16; j = j + 1) begin
				#5;
				operand2 = j;
			end
			
			#5;
			select = ~select;
			
			for (integer j = 0; j < 16; j = j + 1) begin
				#5;
				operand2 = j;
			end
			
			#5;
			select = ~select;
		end
	end
endmodule
