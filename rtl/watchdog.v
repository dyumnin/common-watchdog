module watchdog(
	input wire clk,
	input wire rst_n,
	input wire heartbeat,
	input wire [9:0] sec_count,
	input wire [9:0] msec_count,
	input wire [9:0] usec_count,
	output reg timeout;
)

reg [9:0] msec_counter;
reg [9:0] usec_counter;
reg [9:0] sec_counter;

reg sec_trigger;
reg msec_trigger;
reg usec_trigger;

timer timer (
	.clk(clk),
	.rst_n(rst_n),
	.divFactor(divFactor_1),
	.usec_clk(),
	.usec_pulse(usec_pulse),
	.msec_clk(),
	.msec_pulse(msec_pulse),
	.sec_clk(),
	.sec_pulse(sec_pulse)
);
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n) begin
		sec_trigger<=0;
		msec_trigger<=0;
		usec_trigger<=0;
		sec_counter<=0;
		msec_counter<=0;
		usec_counter<=0;
	end
	else
	begin
		if(!sec_trigger && sec_pulse) begin
			sec_counter<=sec_counter+1;
			if(sec_counter==sec_count)begin
				sec_counter<=0;
				sec_trigger<=1;

			end
		end
		if(!msec_trigger && msec_pulse) begin
			msec_counter<=msec_counter+1;
			if(msec_counter==msec_count)begin
				msec_counter<=0;
				msec_trigger<=1;

			end
		end
		if(!usec_trigger && usec_pulse) begin
			usec_counter<=usec_counter+1;
			if(usec_counter==usec_count)begin
				usec_counter<=0;
				usec_trigger<=1;

			end
		end
		if(sec_trigger &&msec_trigger &&usec_trigger)begin
			timeout<=1;
		end
		if(!timeout && heartbeat)begin
		sec_trigger<=0;
		msec_trigger<=0;
		usec_trigger<=0;
		sec_counter<=0;
		msec_counter<=0;
		usec_counter<=0;
		end
	end
end

