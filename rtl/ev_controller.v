module ev_controller(
    input clk,
    input reset,
    input vehicle_detect,
    input auth_success,
    input battery_full,
    input disconnect,

    output reg charger_on,
    output reg charging_done,
    output reg auth_failed
);

    parameter IDLE               = 3'b000;
    parameter VEHICLE_DETECTED   = 3'b001;
    parameter AUTHENTICATION     = 3'b010;
    parameter CHARGING           = 3'b011;
    parameter CHARGE_COMPLETE    = 3'b100;
    parameter ERROR_STATE        = 3'b101;
    parameter DISCONNECT_STATE   = 3'b110;

    reg [2:0] current_state;
    reg [2:0] next_state;

    always @(posedge clk or posedge reset)
    begin
        if(reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*)
    begin
        case(current_state)

            IDLE:
                if(vehicle_detect)
                    next_state = VEHICLE_DETECTED;
                else
                    next_state = IDLE;

            VEHICLE_DETECTED:
                next_state = AUTHENTICATION;

            AUTHENTICATION:
                if(auth_success)
                    next_state = CHARGING;
                else
                    next_state = ERROR_STATE;

            CHARGING:
                if(battery_full)
                    next_state = CHARGE_COMPLETE;
                else
                    next_state = CHARGING;

            CHARGE_COMPLETE:
                if(disconnect)
                    next_state = DISCONNECT_STATE;
                else
                    next_state = CHARGE_COMPLETE;

            DISCONNECT_STATE:
                next_state = IDLE;

            ERROR_STATE:
                if(disconnect)
                    next_state = IDLE;
                else
                    next_state = ERROR_STATE;

            default:
                next_state = IDLE;

        endcase
    end

    always @(*)
    begin
        charger_on = 0;
        charging_done = 0;
        auth_failed = 0;

        case(current_state)

            CHARGING:
                charger_on = 1;

            CHARGE_COMPLETE:
                charging_done = 1;

            ERROR_STATE:
                auth_failed = 1;

        endcase
    end

endmodule
