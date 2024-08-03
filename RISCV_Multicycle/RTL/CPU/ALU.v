module alu
(
input [31:0] A, B,
input [3:0] alu_controll,
output zero_flag,
output [31:0] alu_out
);

    wire signed [31:0] sigA = A;
    wire [31:0] B_Binv = alu_controll[0] ? ~B : B;
    wire carry;
    wire [31:0] sum;
    assign {carry, sum} = A + B_Binv + alu_controll[0];
    wire [31:0] AandB = A & B;
    wire [31:0] AorB = A | B;
    wire [31:0] AxorB = A ^ B;
    wire overflow = (sum[31] ^ A[31]) & ~(A[31] ^ B[31] ^ alu_controll[0]);
    wire slt = sum[31] ^ overflow;
    wire sltu = ~carry;
    wire [31:0] shift_right = A >> B[4:0];
    wire [31:0] ashift_right = sigA >>> B[4:0];
    wire [31:0] shift_left = A << B[4:0];

    reg [31:0] result;
    always @(*) begin
        case(alu_controll)
            4'b0000: result = sum;
            4'b0001: result = sum;
            4'b0010: result = AandB;
            4'b0011: result = AorB;
            4'b0100: result = AxorB;
            4'b0101: result = slt;
            4'b0111: result = sltu;
            4'b1000: result = shift_right;
            4'b1001: result = ashift_right;
            4'b1010: result = shift_left;
            default: result = 32'hffff_ffff;
        endcase
    end

    assign zero_flag = alu_out == 32'd0;
    assign alu_out = result;
endmodule