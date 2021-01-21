module disp(clk50M,dat0,dat1,dat2,dat3,dat4,dat5,rec_dat24,txstate,dig,seg,dig_cnt);
input clk50M,txstate;
input [3:0]dat0,dat1,dat2,dat3,dat4,dat5;
input [23:0]rec_dat24;
output reg [5:0]dig;
output reg [0:7]seg;
parameter N = 25000,WIDTH = 15;
reg clk2k;
reg [WIDTH-1:0]cnt;
output reg [2:0]dig_cnt;
reg [3:0]bin_data;

always@(posedge clk50M)
begin
	if(cnt == N-1)
	begin
		cnt <= 0;
		clk2k <= ~clk2k;
	end
	else
		cnt <= cnt +1;
end

always@(posedge clk2k)
begin
	if(dig_cnt==3'b101)
	begin
		dig_cnt <= 0;
	end
	else
		dig_cnt <= dig_cnt + 1;
end

always@(dig_cnt)
begin
	case(dig_cnt)	//位
		3'd0:dig <= 6'b011111;
		3'd1:dig <= 6'b101111;
		3'd2:dig <= 6'b110111;
		3'd3:dig <= 6'b111011;
		3'd4:dig <= 6'b111101;
		3'd5:dig <= 6'b111110;
		default:dig <= 6'b000000;
	endcase
	if(~txstate)
	begin
		case(dig_cnt)	//段的数
			3'd0:bin_data <= dat0;
			3'd1:bin_data <= dat1;
			3'd2:bin_data <= dat2;
			3'd3:bin_data <= dat3;
			3'd4:bin_data <= dat4;
			3'd5:bin_data <= dat5;
			default:bin_data <= 4'h4;			//默认为"-"
		endcase
	end
	else
	begin
		case(dig_cnt)	//段的数
			3'd0:bin_data <= rec_dat24[3:0];
			3'd1:bin_data <= rec_dat24[7:4];
			3'd2:bin_data <= rec_dat24[11:8];
			3'd3:bin_data <= rec_dat24[15:12];
			3'd4:bin_data <= rec_dat24[19:16];
			3'd5:bin_data <= rec_dat24[23:20];
		default:bin_data <= 4'h4;			//默认为"-"
		endcase
	end
	case(bin_data)	//段码
		4'h0:seg <= {8'b0000_0011};	//"0"					
		4'h1:seg <= {8'b1001_1111};	//"1"					
		4'h2:seg <= {8'b0010_0101};	//"2"					
		4'h3:seg <= {8'b0000_1101};	//"3"
		4'h4:seg <= {8'b1001_1001};	//"4"
		4'h5:seg <= {8'b0100_1001};	//"5"
		4'h6:seg <= {8'b0100_0001};	//"6"
		4'h7:seg <= {8'b0001_1111};	//"7"
		4'h8:seg <= {8'b0000_0001};	//"8"
		4'h9:seg <= {8'b0000_1001};	//"9"
		4'ha:seg <= {8'b0001_0001};	//"A"		
		4'hb:seg <= {8'b1100_0001};	//"B"
		4'hc:seg <= {8'b0110_0011};	//"C"
		4'hd:seg <= {8'b1000_0101};	//"D"
		4'he:seg <= {8'b0110_0001};	//"E"
		4'hf:seg <= {8'b0111_0001};	//"F"
		default:seg <= 8'b1111_1111;
	endcase
end
endmodule 