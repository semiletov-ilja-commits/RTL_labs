module clk_diverse (
    input logic clk,
    input logic rst,
    output logic clk_div
);
    parameter max_count = 25_000_000;
    
    logic [24:0] counter;
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin  
            counter <= 0;
				clk_div <= 0;
        end else begin
            if (counter == max_count - 1) begin
                counter <= 0;
					 clk_div <= ~clk_div;
            end else
                counter <= counter + 1;
        end
    end
    
endmodule