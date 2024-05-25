`timescale 1ns / 1ps

module debounce_explicit(
    input wire clk,
    input wire rst_n,
    input wire sw,
    output reg db_level,
    output reg db_tick
);
    /*
    Instance Template:
    debounce_explicit
    (
        .clk(clk),
        .rst_n(rst_n),
        .sw(sw),
        .db_level(),
        .db_tick(key_tick)
    );
    */

    // FSM symbolic state declarations
    localparam [1:0] idle    = 2'b00,
                     delay0  = 2'b01,
                     one     = 2'b10,
                     delay1  = 2'b11;
    
    localparam N = 21; // 21 bits is 42ms -> 2^N / 50MHz = 42ms

    reg [1:0] state_reg, state_nxt;       // FSM state registers
    reg [N-1:0] timer_reg, timer_nxt;     // Timer registers
    reg timer_zero, timer_inc, timer_tick;// Control and status signals

    // FSM and timer register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= idle;
            timer_reg <= 0;
        end else begin
            state_reg <= state_nxt;
            timer_reg <= timer_nxt;
        end
    end

    // FSM control path next-state logic
    always @* begin
        state_nxt = state_reg;
        timer_zero = 0;
        timer_inc = 0;
        db_tick = 0;
        db_level = 0;

        case (state_reg)
            idle: 
                if (sw == 1) begin
                    timer_zero = 1; // Load the timer with value of zero
                    state_nxt = delay0;
                end

            delay0: 
                if (sw == 1) begin
                    timer_inc = 1; // Increment timer by 1
                    if (timer_tick) begin // If timer reaches the max (next edge will wrap the timer to zero again)
                        state_nxt = one;
                        db_tick = 1;
                    end
                end else begin
                    state_nxt = idle;
                end

            one: 
                begin
                    db_level = 1;
                    if (sw == 0) begin
                        timer_zero = 1; // Load the timer with value of zero
                        state_nxt = delay1;
                    end
                end

            delay1: 
                begin
                    db_level = 1;
                    if (sw == 0) begin
                        timer_inc = 1;
                        if (timer_tick) // If timer reaches the max (wherein the next edge will wrap the timer to zero again)
                            state_nxt = idle;
                    end else begin
                        state_nxt = one;
                    end
                end

            default: state_nxt = idle;
        endcase                    
    end

    // Datapath (timer) logic and operation
    always @* begin
        timer_nxt = timer_reg;
        if (timer_zero) 
            timer_nxt = 0; // Load zero 
        else if (timer_inc) 
            timer_nxt = timer_reg + 1; // Increment by one

        timer_tick = (timer_reg == {N{1'b1}}) ? 1 : 0; // Notify if timer is already at max
    end

endmodule
