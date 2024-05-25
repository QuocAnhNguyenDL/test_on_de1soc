module test
(
	input [9:0] SW,
	input CLOCK_50,
	input[3:0] KEY, //key[1:0] for brightness control , key[3:2] for contrast control
	//camera pinouts
	input cmos_pclk,cmos_href,cmos_vsync,
	input [7:0] cmos_db,
	inout cmos_sda,cmos_scl, 
	output cmos_rst_n, cmos_pwdn, cmos_xclk,
	//controller to sdram
	output wire DRAM_CLK,
	output wire DRAM_CKE, 
	output wire DRAM_CS_N, DRAM_RAS_N, DRAM_CAS_N, DRAM_WE_N, 
	output wire[12:0] DRAM_ADDR,
	output wire[1:0] DRAM_BA, 
	//output wire[1:0] DRAM_DQM, 
	inout[15:0] DRAM_DQ,
	//VGA output
	output wire[7:0] VGA_R,
	output wire[7:0] VGA_G,
	output wire[7:0] VGA_B,
	output wire VGA_VS, VGA_HS,
	output [9:0] LEDR
);

assign cmos_rst_n = 1'b0;
assign cmos_pwdn = 1'b0;

wire [4:0] vga_r;
wire [5:0] vga_g;
wire [4:0] vga_b;

assign VGA_R = {vga_r,3'b0};
assign VGA_G = {vga_g,2'b0};
assign VGA_B = {vga_b,3'b0};

assign LEDR[7:0] = VGA_R;

top_level top
(
	.clk(CLOCK_50),
	.rst_n(SW[0]),
	.key(KEY), //key[1:0] for brightness control , key[3:2] for contrast control
	//camera pinouts
	.cmos_pclk(cmos_pclk),
	.cmos_href(cmos_href),
	.cmos_vsync(cmos_vsync),
	.cmos_db(cmos_db),
	.cmos_sda(cmos_sda),
	.cmos_scl(cmos_scl), 
	.cmos_rst_n(), 
	.cmos_pwdn(), 
	.cmos_xclk(cmos_xclk),
 
	//controller to sdram
	.sdram_clk(DRAM_CLK),
	.sdram_cke(DRAM_CKE), 
	.sdram_cs_n(DRAM_CS_N), 
	.sdram_ras_n(DRAM_RAS_N), 
	.sdram_cas_n(DRAM_CAS_N), 
	.sdram_we_n(DRAM_WE_N), 
	.sdram_addr(DRAM_ADDR),
	.sdram_ba(DRAM_BA), 
	//.sdram_dqm(DRAM_DQM), 
	.sdram_dq(DRAM_DQ),
	//VGA output
	.vga_out_r(vga_r),
	.vga_out_g(vga_g),
	.vga_out_b(vga_b),
	.vga_out_vs(VGA_VS),
	.vga_out_hs(VGA_HS)
 );
endmodule 