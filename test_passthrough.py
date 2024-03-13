import itertools
import logging
import os
import random

import cocotb_test.simulator
import pytest

import cocotb
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge

from cocotbext.axi import AxiBus, AxiMaster, AxiRam

# 定义测试
@cocotb.coroutine
def axi_example_test(dut):

    clock = Clock(dut.clk, 10, units="us")  # Create a 10us period clock on port clk
    # Start the clock. Start it low to avoid issues on the first RisingEdge
    cocotb.start_soon(clock.start(start_high=False)) 
    
    # 实例化 AXI-lite master 
    axi_master_one = AxiMaster(AxiBus.from_prefix(dut, "s_axi[0]"), dut.clk, dut.rst)
    axi_master_two = AxiMaster(AxiBus.from_prefix(dut, "s_axi[1]"), dut.clk, dut.rst)

    # 实例化 AXI-lite slave RAM
    axi_ram_one = AxiRam(AxiBus.from_prefix(dut, "m_axi[0]"), dut.clk, dut.rst, size=2**32)
    axi_ram_two = AxiRam(AxiBus.from_prefix(dut, "m_axi[1]"), dut.clk, dut.rst, size=2**32)

    # 写入数据到 RAM
    yield axi_master_one.write(0x0000, b'01010101')
    yield axi_master_one.write(0x0000, b'10101010')

    # 从 RAM 读取数据
    data_one = yield axi_master_one.read(0x0000, 8)
    data_two = yield axi_master_two.read(0x0000, 8)
    assert data_one == b'01010101', f"Expected 'test_data_one', but got {data_one}"
    assert data_two == b'10101010', f"Expected 'test_data_two', but got {data_two}"

# 创建测试工厂
tf = TestFactory(axi_example_test)

# 运行测试
tf.generate_tests()

# cocotb-test

tests_dir = os.path.dirname(__file__)
rtl_dir = os.path.abspath(os.path.join(tests_dir, '..', '..', 'rtl'))


@pytest.mark.parametrize("NumSlvPort", [1, 2])
@pytest.mark.parametrize("AXI_ADDR_WIDTH", [16])
@pytest.mark.parametrize("AXI_DATA_WIDTH", [16,32])
def test_passthrough(request,NumSlvPort,AXI_ADDR_WIDTH , AXI_DATA_WIDTH):
    dut = "passthrough"
    #dut = "axis_register"
    module = os.path.splitext(os.path.basename(__file__))[0]
    toplevel = dut

    ## Code Source
    verilog_sources = [
        os.path.join(rtl_dir, f"{dut}.sv"),
    ]
    ## Parameter
    parameters = {}
    parameters['NumSlvPort'] = NumSlvPort 
    parameters['AXI_ADDR_WIDTH'] = AXI_ADDR_WIDTH
    parameters['AXI_DATA_WIDTH'] = AXI_DATA_WIDTH

    extra_env = {f'PARAM_{k}': str(v) for k, v in parameters.items()}

    sim_build = os.path.join(tests_dir, "sim_build",
        request.node.name.replace('[', '-').replace(']', ''))

    cocotb_test.simulator.run(
        python_search=[tests_dir],
        verilog_sources=verilog_sources,
        toplevel=toplevel,
        module=module,
        parameters=parameters,
        sim_build=sim_build,
        extra_env=extra_env,
    )
