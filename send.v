module send(TxA,TxB,busy,start,clk,send_rate_sel,dat24);	//start==1时发送
input [23:0] dat24;
reg [23:0] buffer24;
input start,clk,send_rate_sel;
output reg TxA,TxB,busy;
reg [8:0] cnt_h;
reg [13:0] cnt_l;
reg clk_h,clk_l,clk_buff,buzy;
parameter Idle=0,BeginTx=1,SendBit=2,SendZero=3,SendNull=4;
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

always@(posedge clk_buff)	//状态转移图,见书
begin
	case(state)
		Idle:
		begin
			if(start==0)
				state <= Idle;
			else
				state <= BeginTx;
			buzy <= 0;
			TxA <= 0;
			TxB <= 0;
		end
		BeginTx:
		begin
			count <= 0;
			buffer24 <= dat24;
			buzy <= 1;
			TxA <= 0;
			TxB <= 0;
			state <= SendBit;
		end
		SendBit:
		begin
			count <= count+1;
			TxA <= buffer24[0];
			TxB <= ~buffer24[0];
			state <= SendZero;
		end
		SendZero:
		begin
			if(count==24)
			begin
				count <= 1;
				state <= SendNull;
			end
			else
				state <= SendBit;
			buffer24 <= buffer24>>1;
			TxA <= 0;
			TxB <= 0;
		end
		SendNull:
		begin
			if(count==6)
				state <= Idle;
			else
			begin
				count <= count+1;
				state <= SendNull;
			end
		end
		default:
			state <= Idle;
	endcase
end 

always@(posedge clk)	//两个速率通信
begin
	if(send_rate_sel)
		clk_buff <= clk_h;
	else
		clk_buff <= clk_l;
end

endmodule
