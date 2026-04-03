module lab3 (
	input  logic       clk,
	input  logic       en,
	input  logic       rst_n,
	output logic [6:0] seg,
	output logic [2:0] dig
);
	
	logic [3:0] hund, ten, one;
	logic [6:0] seg_hundr, seg_tens, seg_ones;
	logic [6:0] seg_hundr_reg, seg_tens_reg, seg_ones_reg;
	logic 			clk_div, data_ready;
	logic [7:0] random_out;
	logic [16:0] dig_counter;
	logic [1:0]  disp_state;
	
	clk_div clk_div_inst (
		.clk     (clk),
		.rst_n   (rst_n),
		.clk_div (clk_div)
	);

	ifsr ifsr_inst (
		.clk_div    (clk_div),
		.rst_n      (rst_n),
		.en         (en),
		.out        (random_out),
		.data_ready (data_ready)
	);
	
	b2bcd b2bcd_inst (
		.clk        (clk),
		.rst_n      (rst_n),
		.data_ready (data_ready),
		.in_8       (random_out),
	  .hundreds   (hund),
    .tens       (ten),
    .ones       (one)
	);
	
	conv conv_inst100 (
		.bcd (hund),
		.seg (seg_hundr)
	);
	
	conv conv_inst10 (
		.bcd (ten),
		.seg (seg_tens)
	);
	
	conv conv_inst1 (
		.bcd (one),
		.seg (seg_ones)
	);
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			dig_counter <= '0;
		else
			dig_counter <= dig_counter + 1;
	end
	
	assign disp_state = dig_counter[11:10];
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			seg_ones_reg  <= 7'b1111111;
			seg_tens_reg  <= 7'b1111111;
			seg_hundr_reg <= 7'b1111111;
		end else begin
			seg_ones_reg  <= seg_ones;  
			seg_tens_reg  <= seg_tens;  
			seg_hundr_reg <= seg_hundr;
		end
	end
	
	always_comb begin
		case (disp_state)
			2'b00:   begin
				dig = 3'b001;
				seg = seg_ones_reg;
			end
			2'b01:   begin
				dig = 3'b010;
				seg = seg_tens_reg;
			end
			2'b10:   begin
				dig = 3'b100;
				seg = seg_hundr_reg;
			end
			default: begin
				dig = 3'b000;
				seg = 7'b1111111;
			end
		endcase
	end	
	
endmodule