module top (
  input  logic        clk,      
  input  logic        rst,      
  input  logic        en,       
  input  logic        inv,  
  output logic [1:0]  dig,
  output logic [6:0]  seg
);
	
  logic [6:0]  seg_ones, seg_tens;
  logic [17:0] dig_counter; 
  logic        clk_div;
  logic [3:0]  ones, tens;        

  clk_diverse m_clk_div (
    .clk     (clk),
    .rst     (rst),
    .clk_div (clk_div)
  );
	
  cnt_bcd m_cnt (
    .clk     (clk_div),       
    .rst     (rst),
    .en      (en),
    .inv     (inv),
    .ones    (ones),
    .tens    (tens)
  );
	
  conv m_conv1 (
    .bcd     (ones),
    .seg     (seg_ones)
  );

  conv m_conv2 (
    .bcd     (tens),
    .seg     (seg_tens)
  );
	
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      dig_counter <= '0;
    end else begin
      dig_counter <= dig_counter + 1; 
    end
  end
  
  always_comb begin
		case (dig_counter[17])
			1'b0:    begin
				dig = 2'b01;
				seg = seg_ones;
			end
			1'b1:    begin
				dig = 2'b10;
				seg = seg_tens;
			end
			default: begin
				dig = 2'b00;
				seg = 7'b1111111;
			end
		endcase
	end
   
endmodule