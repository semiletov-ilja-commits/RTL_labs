module ifsr (
	input  logic         clk,
	input  logic 			clk_div,
	input  logic 			rst_n,
	input  logic 		   en,
	output logic [7:0] out,
	output logic       data_ready
);
	
	logic clk_div_prev;
	logic [7:0] q;
	logic XNOR3, XNOR2, XNOR1;
	
	always_ff @(posedge clk_div or negedge rst_n) begin    
      if (!rst_n) 
			q <= 0;
      else begin
         if (!en)
				q <= {XNOR1, q[7:1]};
      end
    end
	
	always_comb begin
		XNOR3 = ~(q[5] ^ q[7]);
		XNOR2 = ~(q[4] ^ XNOR3);
		XNOR1 = ~(q[3] ^ XNOR2);
	end
	
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			clk_div_prev <= 0;
		else
			clk_div_prev <= clk_div;
	end
	
	assign out = q;
	assign data_ready = ~clk_div_prev & clk_div;
	
endmodule