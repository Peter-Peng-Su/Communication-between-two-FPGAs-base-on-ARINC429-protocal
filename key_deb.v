//按键消抖
module key_deb
(
	input clk,
	input [3:0] key_in,
	output reg [3:0] key_out
);
reg [18:0] cnt;
reg clk100;
reg [3:0] key0,key1,key2;
always@(posedge clk)
begin
	if(cnt==250_000)
	begin
		cnt <= 0;
		clk100 <= ~clk100;
	end
	else
		cnt <= cnt+1;
end

always@(posedge clk100)	//key_out各个位要分开写,可能由于||运算符的原因
begin
	key_out[0] <= (key_in[0]||key0[0]||key1[0]||key2[0]);
	key2[0] <= key1[0];
	key1[0] <= key0[0];
	key0[0] <= key_in[0];
end

always@(posedge clk100)
begin
	key_out[1] <= (key_in[1]||key0[1]||key1[1]||key2[1]);
	key2[1] <= key1[1];
	key1[1] <= key0[1];
	key0[1] <= key_in[1];
end

always@(posedge clk100)
begin
	key_out[2] <= (key_in[2]||key0[2]||key1[2]||key2[2]);
	key2[2] <= key1[2];
	key1[2] <= key0[2];
	key0[2] <= key_in[2];
end

always@(posedge clk100)
begin
	key_out[3] <= (key_in[3]||key0[3]||key1[3]||key2[3]);
	key2[3] <= key1[3];
	key1[3] <= key0[3];
	key0[3] <= key_in[3];
end
endmodule
