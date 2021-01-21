module commu
(
	input clk,
	input [3:0]key,
	input RxA,
	input RxB,
	output [5:0]dig,
	output [0:7]seg,
	output TxA,
	output TxB,
	output busy,
	output [3:0] led
);

wire [3:0] key_out;
key_deb key_deb_inst
(
	.clk(clk),
	.key_in(key),
	.key_out(key_out)
);

wire [3:0] dat0,dat1,dat2,dat3,dat4,dat5;
wire [2:0]cnt_out;
cnt cnt_inst
(	
	.clk(clk),
	.key(key_out[3:0]),
	.dat0(dat0),
	.dat1(dat1),
	.dat2(dat2),
	.dat3(dat3),
	.dat4(dat4),
	.dat5(dat5),
	.dig_cnt(cnt_out),
	.start(start),
	.send_rate(send_rate),
	.rec_rate(rec_rate),
	.txstate(txstate)
);

wire [2:0]disp_cnt;
wire [0:7]seg_in;
disp disp_inst
(
	.clk50M(clk),
	.dat0(dat0),
	.dat1(dat1),
	.dat2(dat2),
	.dat3(dat3),
	.dat4(dat4),
	.dat5(dat5),
	.rec_dat24(dat_rec24),
	.txstate(txstate),
	.dig(dig),
	.seg(seg_in),
	.dig_cnt(disp_cnt)
);

flikerer flikerer_inst
(
	.clk(clk),
	.seg_in(seg_in),
	.disp_out(disp_cnt),
	.cnt_out(cnt_out),
	.txstate(txstate),
	.seg(seg)
);

reg [23:0] dat24;
always@(clk)
begin
	dat24[3:0] <= dat0;
	dat24[7:4] <= dat1;
	dat24[11:8] <= dat2;
	dat24[15:12] <= dat3;
	dat24[19:16] <= dat4;
	dat24[23:20] <= dat5;
end

send send_inst
(
	.dat24(dat24),
	.TxA(TxA),
	.TxB(TxB),
	.busy(busy),
	.start(start),	//key[1]的话,按key[0]不换位
	.clk(clk),
	.send_rate_sel(send_rate)
);

led led_inst
(
	.clk(clk),
	.txstate(txstate),
	.send_rate(send_rate),
	.rec_rate(rec_rate),
	.start(TxA),
	.led(led)
);

wire [23:0] dat_rec24;
rec rec_inst
(
	.dat24(dat_rec24),
	.clk(clk),
	.RxA(RxA),
	.RxB(RxB),
	.rec_rate_sel(rec_rate)
);

endmodule
