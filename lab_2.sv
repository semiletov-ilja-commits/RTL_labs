module lab_2 (
    input logic clk,
    input logic en,
    input logic rst,
    input logic inv,
    output logic [3:0] dig,
    output logic [6:0] seg
);
    
    logic c0, c1;
    logic [6:0] seg_1, seg_2;
    logic [1:0] dig_1, dig_2;
    logic [17:0] disp_counter;
    logic [1:0] disp_state;
    
    // Регистры для хранения текущих значений цифр
    logic [6:0] digit0, digit1, digit2, digit3;
    
    CLOCKS CLOCKS_inst (
        .inclk0 ( clk ),
        .c0 ( c0 ),
        .c1 ( c1 )
    );
    
    top hex12 (
        .clk (c0),
        .rst (rst),
        .en (en),
        .inv (inv),
        .dig (dig_1),
        .seg (seg_1)
    );
    
    top hex34 (
        .clk (c1),
        .rst (rst),
        .en (en),
        .inv (inv),
        .dig (dig_2),
        .seg (seg_2)
    );
    
    always_ff @(posedge c0 or negedge rst) begin
        if (!rst) begin
            digit0 <= 7'b1111111;
            digit1 <= 7'b1111111;
        end else begin
            if (dig_1 == 2'b01) digit0 <= seg_1;
            if (dig_1 == 2'b10) digit1 <= seg_1;
        end
    end
    
    always_ff @(posedge c1 or negedge rst) begin
        if (!rst) begin
            digit2 <= 7'b1111111;
            digit3 <= 7'b1111111;
        end else begin
            if (dig_2 == 2'b01) digit2 <= seg_2;
            if (dig_2 == 2'b10) digit3 <= seg_2;
        end
    end
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) disp_counter <= 0;
        else disp_counter <= disp_counter + 1;
    end
    
    assign disp_state = disp_counter[17:16];
    
    always_comb begin
        case (disp_state)
            2'b00: begin dig = 4'b1110; seg = digit0; end
            2'b01: begin dig = 4'b1101; seg = digit1; end
            2'b10: begin dig = 4'b1011; seg = digit2; end
            2'b11: begin dig = 4'b0111; seg = digit3; end
            default: begin dig = 4'b1111; seg = 7'b1111111; end
        endcase
    end

endmodule