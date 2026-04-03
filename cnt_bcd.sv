module cnt_bcd (
  input  logic        clk,      
  input  logic        rst,      
  input  logic        en,       
  input  logic        inv,      
  output logic [3:0]  tens,
  output logic [3:0]  ones
);

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      ones <= 4'b0;
      tens <= 4'b0;
    end else if (!en) begin 
      if (inv) begin 
        if (ones == 4'd9) begin
          ones <= 4'b0;
          if (tens == 4'd9)
            tens <= 4'b0;
          else
            tens <= tens + 4'd1;
        end else begin
          ones <= ones + 4'd1;
        end
      end else begin 
        if (ones == 4'b0) begin
          ones <= 4'd9;
          if (tens == 4'b0)
            tens <= 4'd9;
          else
            tens <= tens - 4'd1;
        end else begin
          ones <= ones - 4'd1;
        end
      end
    end
  end

endmodule