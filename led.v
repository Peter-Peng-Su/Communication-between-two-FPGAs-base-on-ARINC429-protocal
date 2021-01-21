module led(clk,txstate,send_rate,rec_rate,start,led);
input clk,txstate,send_rate,rec_rate,start;
output reg [3:0]led;
always@(posedge clk)
begin
	if(txstate)
		led[0] <= 1;
	else
		led[0] <= 0;
	if(start)
		led[1] <= 1;
	else
		led[1] <= 0;
	if(send_rate)
		led[2] <= 1;
	else
		led[2] <= 0;
	if(rec_rate)
		led[3] <= 1;
	else
		led[3] <= 0;
end
endmodule
