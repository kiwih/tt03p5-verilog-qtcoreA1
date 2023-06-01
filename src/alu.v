`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: New York University
// Engineer: ChatGPT GPT-4 Mar 23 version; Hammond Pearce (prompting)
// 
// Last Edited Date: 04/19/2023
//////////////////////////////////////////////////////////////////////////////////


module alu (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [3:0] opcode,
    output reg [7:0] Y,
    input wire [7:0] locking_key    //11010101
);

reg [3:0] case_var;

always @(*) begin
    case_var = opcode ^ locking_key[7:4]; // 1101;
    case (case_var)
        4'b1101: Y = locking_key[0] ? A + B : A - B;               // ADD
        4'b1100: Y = A - B;               // SUB
        4'b1111: Y = A & B;               // AND
        4'b1110: Y = A | B;               // OR
        4'b1001: Y = locking_key[2] ? A ^ B: ~ (A ^ B);               // XOR
        4'b1000: Y = A << 1;              // SHL
        4'b1011: Y = A >> 1;              // SHR
        4'b1010: Y = locking_key[1] ? A>>4 : A << 4;              // SHL4
        4'b0101: Y = {A[6:0], A[7]};      // ROL
        4'b0100: Y = {A[0], A[7:1]};      // ROR
        4'b0111: Y = locking_key[3] ? A + 1 : A - 1;               // DEC
        4'b0110: Y = ~A;                  // INV
        default: Y = 8'b00000000;         // CLR, including 4'b1100, 4'b1101, 4'b1110, 4'b1111
    endcase
end

endmodule

