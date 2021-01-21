module flikerer
(
	input clk,
	input [7:0]seg_in,
	input [2:0]disp_out,
	input [2:0]cnt_out,
	input txstate,
	output reg [7:0]seg
);

reg [24:0] cnt;
reg clk1;

always@(posedge clk)	//必须得是posedge
begin
	if(cnt == 25_000_000)
	begin
		cnt <= 0;
		clk1 <= ~clk1;
	end
	else
		cnt <= cnt +1;
end

always@(posedge clk)
begin
	if(clk1)
	begin
		if((disp_out==cnt_out)&&~txstate)
			seg <= 8'hff;
		else
			seg <= seg_in;
	end
	else
		seg <= seg_in;
end
endmodule
