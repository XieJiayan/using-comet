链接： [Support for interfaces in top level ports · Issue #1185 · verilator/verilator · GitHub](https://github.com/verilator/verilator/issues/1185)https://github.com/verilator/verilator/issues/1185

```verilog
/* verilator lint_off DECLFILENAME */
/* verilator lint_off UNDRIVEN */
/* verilator lint_off UNUSED */
interface APB;
logic [31:0] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [31:0] PWDATA;
logic [31:0] PRDATA;
logic PREADY;

modport master (
	output PADDR, PSEL, PENABLE, PWRITE, PWDATA,
	input PRDATA, PREADY
);

modport slave (
	input PADDR, PSEL, PENABLE, PWRITE, PWDATA,
	output PRDATA, PREADY
);
endinterface
/* verilator lint_on DECLFILENAME */

module SYSREG(
	clk, 
	resetn,
	APB.slave slave
);
input clk;
input resetn;

endmodule

module SYSREG_WRAP(
clk,
resetn,
APB_PADDR,
APB_PSEL,
APB_PWRITE,
APB_PWDATA,
APB_PRDATA,
APB_PREADY
);
input clk;
input resetn;
input [31:0] APB_PADDR;
input APB_PSEL;
input APB_PWRITE;
input [31:0] APB_PWDATA;
output [31:0] APB_PRDATA;
output APB_PREADY;

APB slave;

assign slave.PADDR = APB_PADDR;
assign slave.PSEL = APB_PSEL;
assign slave.PWRITE = APB_PWRITE;
assign slave.PWDATA = APB_PWDATA;
assign APB_PRDATA = slave.PRDATA;
assign APB_PREADY = slave.PREADY;

SYSREG sysreg_wrap(
	.clk,
	.resetn,
	.slave
);

endmodule

```
