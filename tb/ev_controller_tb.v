module ev_controller_tb;

    reg clk;
    reg reset;
    reg vehicle_detect;
    reg auth_success;
    reg battery_full;
    reg disconnect;

    wire charger_on;
    wire charging_done;
    wire auth_failed;

    ev_controller uut (
        .clk(clk),
        .reset(reset),
        .vehicle_detect(vehicle_detect),
        .auth_success(auth_success),
        .battery_full(battery_full),
        .disconnect(disconnect),
        .charger_on(charger_on),
        .charging_done(charging_done),
        .auth_failed(auth_failed)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin

        $dumpfile("sim/ev_controller.vcd");
        $dumpvars(0, ev_controller_tb);

        clk = 0;
        reset = 1;
        vehicle_detect = 0;
        auth_success = 0;
        battery_full = 0;
        disconnect = 0;

        #10 reset = 0;

        // Vehicle Connected
        #10 vehicle_detect = 1;

        // Authentication Success
        #10 auth_success = 1;

        // Battery Fully Charged
        #20 battery_full = 1;

        // Vehicle Disconnected
        #20 disconnect = 1;

        // Reset Signals
        #10
        vehicle_detect = 0;
        auth_success = 0;
        battery_full = 0;
        disconnect = 0;

        #20 $finish;

    end

endmodule
