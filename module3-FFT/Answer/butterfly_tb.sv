`timescale 1ns/1ns
module butterfly_tb( 
    output [31:0] plus,
    output [31:0] minus
);
    logic [31:0] A_in;
    logic [31:0] B_in;
    logic [31:0] W_in;

    initial begin
        clk = 0;
        A_in = 32'b01001110001000000111010100110000;
        B_in = 32'b00100111000100001001110001000000;
        W_in = 32'b01000000000000000000000000000000;
    end

    butterfly #(32) UUT(A_in, B_in, W_in, plus, minus);
endmodule
