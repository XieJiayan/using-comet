`ifndef AXILITE_SVH
`define AXILITE_SVH

/// An AXI4-Lite interface.
interface AXI_LITE #(
  parameter int unsigned AXI_ADDR_WIDTH = 16,
  parameter int unsigned AXI_DATA_WIDTH = 32 
);

  localparam int unsigned AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;

  typedef logic [AXI_ADDR_WIDTH-1:0] addr_t;
  typedef logic [AXI_DATA_WIDTH-1:0] data_t;
  typedef logic [AXI_STRB_WIDTH-1:0] strb_t;

  // AW channel
  addrt          awaddr;
  axipkg::prot_t awprot;
  logic           awvalid;
  logic           awready;

  datat          wdata;
  strbt          wstrb;
  logic           wvalid;
  logic           wready;

  axipkg::resp_t bresp;
  logic           bvalid;
  logic           bready;

  addrt          araddr;
  axipkg::prot_t  arprot;
  logic           arvalid;
  logic           arready;

  datat          rdata;
  axipkg::resp_t rresp;
  logic           rvalid;
  logic           rready;

  modport Master (
    output awaddr, awprot, awvalid, input awready,
    output wdata, wstrb, wvalid, input wready,
    input bresp, bvalid, output bready,
    output araddr, arprot, arvalid, input arready,
    input rdata, rresp, rvalid, output rready
  );

  modport Slave (
    input awaddr, awprot, awvalid, output awready,
    input wdata, wstrb, wvalid, output wready,
    output bresp, bvalid, input bready,
    input araddr, arprot, arvalid, output arready,
    output rdata, rresp, rvalid, input rready
  );

  modport Monitor (
    input awaddr, awprot, awvalid, awready,
          wdata, wstrb, wvalid, wready,
          bresp, bvalid, bready,
          araddr, arprot, arvalid, arready,
          rdata, rresp, rvalid, rready
  );

endinterface


`endif AXILITE_SVH



