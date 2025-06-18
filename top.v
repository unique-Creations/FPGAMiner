module top (
    input clk,  // 12 MHz clock from Alchitry Cu
    output [7:0] led // 8 onboard LEDs
);
    
reg [63:0] counter = 0;

always @(posedge clk) begin
    counter <= counter + 1;
    led <= counter[31:24]; // Slow blink on upper bits
end



endmodule