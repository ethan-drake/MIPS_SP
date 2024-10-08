module mips_sp(
	//Inputs - Platform
	input clk,
	input rst_n,
    input i_rd_en,
    //input [31:0] jmp_branch_address,
    //input jmp_branch_valid
);

wire rd_en, abort, we, dout_valid;
wire [127:0] dout;
wire [31:0] pc_in;
wire [31:0] pc_out;
wire [31:0] instr;
wire [31:0] jmp_branch_address;
wire jmp_branch_valid;
wire empty;
wire rd_en;

i_cache cache(
    .pc_in({pc_in[31:4],4'b0}),
	.rd_en(rd_en),
    .abort(abort),
	.we(1'b0),
    .clk(clk),
    .i_rst_n(rst_n),
	//outputs
	.dout(dout),
	.dout_valid(dout_valid)
);

ifq ifq_module(
    .i_clk(clk),
    .i_rst_n(rst_n),
    .dout(dout),
    .dout_valid(dout_valid),
    .rd_en(i_rd_en),
    .jmp_branch_address(jmp_branch_address),
    .jmp_branch_valid(jmp_branch_valid),
    .pc_in(pc_in),
    .o_rd_en(rd_en),
    .abort(abort),
    .pc_out(pc_out),
    .instr(instr),
    .empty(empty)
);


dispatcher(
    .i_fetch_pc_plus_4(pc_out),
    .i_fetch_instruction(instr),
    .i_fetch_empty_flag(empty),
    .dispatch_jmp_br_addr(jmp_branch_address),
    .dispatch_jmp_valid(jmp_branch_valid),
    .dispatch_rd_en(rd_en)
);

endmodule