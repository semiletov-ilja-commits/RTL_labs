module b2bcd (
	input  logic       clk,
	input  logic       rst_n,
	input  logic       data_ready,
	input  logic [7:0] in_8,
	output logic [3:0] hundreds,
	output logic [3:0] tens,
	output logic [3:0] ones
);
	
	logic [11:0] bcd_reg, bcd_reg_corrected;
	logic [7:0]  bin_reg;
	logic [3:0]  counter;
	
	always_comb begin
		bcd_reg_corrected = bcd_reg;
		if (bcd_reg[3:0] >= 5)
			bcd_reg_corrected[3:0] = bcd_reg[3:0] + 3;
		if (bcd_reg[7:4] >= 5)
			bcd_reg_corrected[7:4] = bcd_reg[7:4] + 3;
	end
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			bcd_reg <= '0;
			bin_reg <= '0;
			counter <= '0;
		end else begin
			if (data_ready) begin
				bcd_reg <= '0;
				bin_reg <= in_8;
				counter <= '0;
			end else begin	
				if (counter < 8) begin
					bcd_reg[11:0] <= {bcd_reg_corrected[10:0], bin_reg[7]};
					bin_reg[7:0]  <= {bin_reg[6:0], 1'b0};
					counter <= counter + 1;
				end	else
					{hundreds, tens, ones} <= bcd_reg;
			end
		end	
	end
	
endmodule
	
