`timescale 1ns / 1ps

module vga_interface(
    input wire clk,
    input wire rst_n,
    // asyn_fifo IO
    input wire empty_fifo,
    input wire [15:0] din,
    output wire clk_vga,
    output reg rd_en,
    // VGA output
    output reg [4:0] vga_out_r,
    output reg [5:0] vga_out_g,
    output reg [4:0] vga_out_b,
    output wire vga_out_vs,
    output wire vga_out_hs
);
    // FSM state declarations
    localparam delay = 0,
               idle = 1,
               display = 2;
    
    reg [1:0] state_q, state_d;
    wire [11:0] pixel_x, pixel_y;
    wire clk_out;
    
    // Register operations
    always @(posedge clk_out or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= delay;
        end else begin
            state_q <= state_d;
        end
    end
    
    // FSM next-state logic
    always @* begin
        state_d = state_q;
        rd_en = 0;
        vga_out_r = 0;
        vga_out_g = 0;
        vga_out_b = 0;
        case (state_q)
            idle:  
                if (pixel_x == 1 && pixel_y == 0 && !empty_fifo) begin // wait for pixel-data coming from asyn_fifo 
                    vga_out_r = din[15:11]; 
                    vga_out_g = din[10:5];
                    vga_out_b = din[4:0];
                    rd_en = 1;    
                    state_d = display;
                end
					 
				delay: 
					 if (pixel_x == 1 && pixel_y == 1) 
						state_d = idle; // delay of one frame (33ms) needed to start up the camera
						
            display: 
                if (pixel_x >= 1 && pixel_x <= 640 && pixel_y < 480) begin // we will continue to read the asyn_fifo as long as current pixel coordinate is inside the visible screen (640x480) 
                    vga_out_r = din[15:11]; 
                    vga_out_g = din[10:5];
                    vga_out_b = din[4:0];
                    rd_en = 1;    
                end
        endcase
    end
    
    assign clk_vga = clk_out;
    
    // Module instantiations
    vga_core m0 (
        .clk(clk_out), // clock must be 25MHz for 640x480
        .rst_n(rst_n),  
        .hsync(vga_out_hs),
        .vsync(vga_out_vs),
        .video_on(),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    
    clk25 m1 ( // clock for vga (640x480 60fps)
        // Clock in ports
        .refclk(clk),      // IN
        // Clock out ports
        .outclk_0(clk_out), // OUT
        // Status and control signals
        .rst(~rst_n), // IN
        .locked()     // OUT (not used)
    );

endmodule
