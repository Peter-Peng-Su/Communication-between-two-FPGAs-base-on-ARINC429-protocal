module cnt(clk,key,dat0,dat1,dat2,dat3,dat4,dat5,dig_cnt,start,send_rate,rec_rate,txstate);	//dig_cnt为位选择状态,start为发送指令
input clk;
input [3:0]key;
output reg [3:0]dat0,dat1,dat2,dat3,dat4,dat5;
output reg [2:0] dig_cnt;
output reg start,send_rate,rec_rate,txstate;
reg [3:0] key_o;

always@(posedge clk)
begin
	key_o[0] <= key[0];
	key_o[1] <= key[1];
	key_o[2] <= key[2];
	key_o[3] <= key[3];
end

always@(posedge clk)
begin
	if((dig_cnt==6)&&~key_o[1])
		start <= 1;
	else
		start <= 0;
end

always@(negedge key_o[0])	// 不能为posedge clk or negedge key_o
begin
	if(dig_cnt==3'd6)
		dig_cnt <= 0;
	else
		dig_cnt <= dig_cnt + 1;
end

always@(negedge key_o[1])
begin
	if(dig_cnt!=6)
	begin
		case(dig_cnt)
			3'd0:dat0 <= dat0 + 3'd1;
			3'd1:dat1 <= dat1 + 3'd1;
			3'd2:dat2 <= dat2 + 3'd1;
			3'd3:dat3 <= dat3 + 3'd1;
			3'd4:dat4 <= dat4 + 3'd1;
			3'd5:dat5 <= dat5 + 3'd1;
			default:
				;	//若为dig_cnt <= dig_cnt+1; , Error (10028): Can't resolve multiple constant drivers for net "digi[2]" at cnt.v(18)
		endcase
	end
end

always@(negedge key_o[2])
begin
	txstate <= ~txstate;
end

always@(negedge key_o[3])
begin
	case(txstate)
		1'b0:send_rate <= ~send_rate;
		1'b1:rec_rate <= ~rec_rate;
	endcase
end
endmodule
