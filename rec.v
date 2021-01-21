module rec(RxA,RxB,clk,rec_rate_sel,dat24);
output reg [23:0] dat24;
reg [23:0] buffer24;
input clk,rec_rate_sel;
input RxA,RxB;
reg [8:0] cnt_h;
reg [13:0] cnt_l;
reg clk_h,clk_l,clk_buff;
parameter Idle=0,BeginRx=1,RecBit=2,RecZero=3,RecNull=4;
reg [2:0] state;
reg [4:0] count;

always@(posedge clk)	//分频,输出clk_h(100k)和clk_l(10)
begin
	if(cnt_h==250)
	begin
		cnt_h <= 0;
		clk_h <= ~clk_h;	//100k赫兹
		if(cnt_l==10000)
		begin
			cnt_l <= 0;
			clk_l <= ~clk_l;	//10赫兹
		end
		else
			cnt_l <= cnt_l+1;
	end
	else
		cnt_h <= cnt_h+1;
end

always@(posedge clk)	//两个速率通信
begin
	if(rec_rate_sel)
		clk_buff <= clk_h;
	else
		clk_buff <= clk_l;
end

always@(negedge clk_buff)	//状态转移图,见书
begin
	case(state)
		Idle:
		begin
			if((RxA||RxB)==0)
				state <= Idle;
			else
			begin
				count <= 1;
				buffer24[23] <= (RxA)&&(~RxB);
				state <= RecZero;
			end
		end
		RecBit:
		begin
			count <= count+1;
			buffer24[23] <= (RxA)&&(~RxB);
			state <= RecZero;
		end
		RecZero:
		begin
			if(count==24)
			begin
				count <= 1;
				state <= RecNull;
			end
			else
			begin
				buffer24 <= buffer24>>1;
				state <= RecBit;
			end
		end
		RecNull:
		begin
			if(count==6)
			begin
				dat24 <= buffer24;
				state <= Idle;
			end
			else
			begin
				count <= count+1;
				state <= RecNull;
			end
		end
		default:
			state <= Idle;
	endcase
end 

endmodule
