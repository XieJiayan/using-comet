module trailing_zero #(
	// the width of the input verctor , or the number of input 
	parameter WIDTH = 8,
	// mode == 0 means trailing the trailing zero , otherwise means
	// counting the leading zero
	parameter MODE 	= 0,   
	// the width of the output siganl width , 
	// means which port we will grant the request	
	parameter COUNT_WIDTH = $log2(WIDTH) 
)(
	input wire 	[WIDTH-1 :0]  		in_req,	
	output reg	[COUNT_WIDTAH-1:0]	o_grant,
	output reg						o_empty
);
	
// mode==0, if we want to trailing the zero , we should reverse the input_vector
genvar i;
generate if (MODE == 0) begin
	wire 	[WIDTH-1 :0]  		new_req,	
	for (i=0 ; i<WIDTH ; i++){
		assign new_req[i] = in_req[WIDTH-1-i]; 
	}
end 
else begin
	assign new_req = in_req;
end	
endgenerate

// the implement logic is from paper : A Design for High Speed Leading-Zero Counter
wire V;
wire [COUNT_WIDTH-1 :0] Z; 
assign  V = ~((~(new_req[7]+new_req[6])) & (~(new_req[5]+new_req[4]))) + \\
			 ~((~(new_req[3]+new_req[2])) & (~(new_req[1]+new_req[0])));
assign  Z[0] =  ~(new_req[7]+((~new_req[6]) & new_req[5])) & \\
			((new_req[6]+new_req[4]) +    ~((~new_req[2])& new_req[1] + new_req[3])) ;
assign  Z[1] = 	(~(new_req[7]+new_req[6])) & (~(new_req[5]+new_req[4]) & (~(new_req[3] + new_req[2]))) ;
assign  Z[2] =  (~(new_req[7]+new_req[6])) & (~(new_req[5]+new_req[4]));


endmodule