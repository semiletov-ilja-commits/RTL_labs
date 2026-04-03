module clk_div #(
	parameter SWITCH = 25_000_000
)(
	input  logic clk,
	input  logic rst_n,
	output logic clk_div
);

	logic [24:0] cnt;
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			clk_div <= '0;
			cnt <= '0;
		end else begin
			if (cnt == SWITCH - 1) begin
				cnt <= '0;
				clk_div <= ~clk_div;
			end else
				cnt <= cnt + 1;
		end
	end
	
endmodule