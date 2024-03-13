module passthrough #(
	parameter int unsigned NumSlvPorts = 32'd2,
  parameter int unsigned AXI_ADDR_WIDTH = 16,
  parameter int unsigned AXI_DATA_WIDTH = 32,
  parameter 
)(
	input logic clk,
  input logic restn,
  
  AXI_LITE.Slave	s_axi [Nums_axiPort-1 : 0],
  AXI_LITE.Master m_axi [Nums_axiPort-1 : 0]
);
  
  typedef logic [AxiAddrWidth-1:0]   addr_t;
  typedef logic [AxiDataWidth-1:0]   data_t;
  typedef logic [AxiDataWidth/8-1:0] strb_t;
  // channels typedef
  `AXI_LITE_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t)
  `AXI_LITE_TYPEDEF_B_CHAN_T(b_chan_t)
  `AXI_LITE_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_R_CHAN_T(r_chan_t, data_t)
  `AXI_LITE_TYPEDEF_REQ_T(axi_req_t, aw_chan_t, w_chan_t, ar_chan_t)
  `AXI_LITE_TYPEDEF_RESP_T(axi_resp_t, b_chan_t, r_chan_t)

  for (genvar i = 0; i < Nos_axiPorts; i++) begin : gen_assign_s_axi_ports
    spill_register #(
      .T       ( aw_chan_t  ),
      .Bypass  ( 1'b1   )
    ) i_aw_spill_reg (
      .clk_i   ( clk                    ),
      .rst  ( rst                   ),
      .valid_i ( s_axi[i].awvalid   ),
      .ready_o ( s_axi[i].awready  ),
      .data_i  ( s_axi[i].awaddr     ),
      .valid_o ( m_axi[i].awvalid       ),
      .ready_i ( m_axi[i].awready      ),
      .data_o  ( m_axi[i].awaddr        )
    );
    spill_register #(
      .T       ( w_chan_t ),
      .Bypass  ( 1'b1  )
    ) i_w_spill_reg (
      .clk_i   ( clk                   ),
      .rst  ( rst                  ),
      .valid_i ( s_axi[i].wvalid   ),
      .ready_o ( s_axi[i].wready  ),
      .data_i  ( s_axi[i].wdata         ),
      .valid_o ( m_axi[i].wvalid       ),
      .ready_i ( m_axi[i].wready      ),
      .data_o  ( m_axi[i].wdata             )
    );
    spill_register #(
      .T       ( b_chan_t ),
      .Bypass  ( 1'b1  )
    ) i_b_spill_reg (
      .clk_i   ( clk_i                  ),
      .rst  ( rst                 ),
      .valid_i ( m_axi[i].b_valid     ),
      .ready_o ( m_axi[i].b_ready      ),
      .data_i  ( m_axi[i].b           ),
      .valid_o ( s_axi[i].b_valid ),
      .ready_i ( s_axi[i].b_ready  ),
      .data_o  ( s_axi[i].b       )
    );
    spill_register #(
      .T       ( ar_chan_t ),
      .Bypass  ( 1'b1  )
    ) i_ar_spill_reg (
      .clk_i   ( clk                    ),
      .rst  ( rst                   ),
      .valid_i ( s_axi[i].arvalid   ),
      .ready_o ( s_axi[i].arready  ),
      .data_i  ( s_axi[i].araddr    ),
      .valid_o ( m_axi[i].arvalid      ),
      .ready_i ( m_axi[i].arready      ),
      .data_o  ( m_axi[i].araddr       )
    );
    spill_register #(
      .T       ( r_chan_t ),
      .Bypass  ( 1'b1  )
    ) i_r_spill_reg (
      .clk_i   ( clk                  ),
      .rst  ( rst                 ),
      .valid_i ( m_axi[i].rvalid     ),
      .ready_o ( m_axi[i].rready      ),
      .data_i  ( m_axi[i].rdata           ),
      .valid_o ( s_axi[i].rvalid ),
      .ready_i ( s_axi[i].rready  ),
      .data_o  ( s_axi[i].rdata       )
    );

  end



endmodule