`include "axi_pkg.sv"

/// An AXI4-Lite interface.
interface AXI_LITE #(
  parameter int unsigned AXI_ADDR_WIDTH = 0,
  parameter int unsigned AXI_DATA_WIDTH = 0
);

  localparam int unsigned AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;

  typedef logic [AXI_ADDR_WIDTH-1:0] addr_t;
  typedef logic [AXI_DATA_WIDTH-1:0] data_t;
  typedef logic [AXI_STRB_WIDTH-1:0] strb_t;

  // AW channel
  addr_t          aw_addr;
  axi_pkg::prot_t aw_prot;
  logic           aw_valid;
  logic           aw_ready;

  data_t          w_data;
  strb_t          w_strb;
  logic           w_valid;
  logic           w_ready;

  axi_pkg::resp_t b_resp;
  logic           b_valid;
  logic           b_ready;

  addr_t          ar_addr;
  axi_pkg::prot_t ar_prot;
  logic           ar_valid;
  logic           ar_ready;

  data_t          r_data;
  axi_pkg::resp_t r_resp;
  logic           r_valid;
  logic           r_ready;

  modport Master (
    output aw_addr, aw_prot, aw_valid, input aw_ready,
    output w_data, w_strb, w_valid, input w_ready,
    input b_resp, b_valid, output b_ready,
    output ar_addr, ar_prot, ar_valid, input ar_ready,
    input r_data, r_resp, r_valid, output r_ready
  );

  modport Slave (
    input aw_addr, aw_prot, aw_valid, output aw_ready,
    input w_data, w_strb, w_valid, output w_ready,
    output b_resp, b_valid, input b_ready,
    input ar_addr, ar_prot, ar_valid, output ar_ready,
    output r_data, r_resp, r_valid, input r_ready
  );


endinterface

