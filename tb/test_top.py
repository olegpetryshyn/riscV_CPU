#===========================================================================
# File Name = test top 
# Function  = a python script used by cocotb to verify the correct function
# of the program in hexadecimal loaded in the instruction memory
# register usage:
    # x0 constantly 0
    # x1 first load 
    # x2 second load with LUI operator usage
    # x3 load from memory (has to be equal to x1)
    # x4 failed branch assesment 
    # x5 fibonacci branch assesment
    # x6 f(n-1) in fibonacci count 
    # x7 f(n) in fibonacci count 
    # x8 f(n+1) in fibonacci count 
    # x9 temporary register used as an offset for the load and store in x3
    # x10 total simulation fully complete (if equal to arbitrary number 37)
# in this python script are present the various assertions necessary to 
# evaluate if the program has been successfuly run on the cpu
#===========================================================================

# importing clock
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

# programming reset_n  routine (to verify the PC isn't changing)
async def reset(dut):
    dut.rset_n.value = 0 
    await ClockCycles(dut.clk, 3) 
    dut.rset_n.value = 1
    await RisingEdge(dut.clk)

# main test 
@cocotb.test()
async def test_addition(dut):
    """Test execution insttuction: """
    # 1. Clock start (test 20 cycles)
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    # 2. Reset sequece
    await reset(dut)
    dut._log.info("Reset complete, CPU in execution...")

    # 3. 5 cycle execution monitoring the program counter
    for cycle in range(50):
        await RisingEdge(dut.clk)
        dut._log.info(f"Ciclo {cycle}: PC = 0x{int(dut.pc.value):08x}")

    # 4. Register reading (referencing register file program)
    rf = dut.instancecore.instancerf

    val_x1 = int(rf.register[1].value)
    val_x2 = int(rf.register[2].value)
    val_x3 = int(rf.register[3].value)
    val_x4 = int(rf.register[4].value)
    val_x5 = int(rf.register[5].value)
    val_x6 = int(rf.register[6].value)
    val_x7 = int(rf.register[7].value)
    val_x8 = int(rf.register[8].value)
    val_x9 = int(rf.register[9].value)
    val_x10 = int(rf.register[10].value)

    dut._log.info(f"Register x1 = {val_x1} (Attended: 0)")
    dut._log.info(f"Register x2 = {val_x2} (Attended: 0xA12CF67(169004903))")
    dut._log.info(f"Register x3 = {val_x3} (Attended: 5)")
    dut._log.info(f"Register x4 = {val_x4} (Attended: 1)")
    dut._log.info(f"Register x5 = {val_x5} (Attended: 0)")
    dut._log.info(f"Register x6 = {val_x6} (Attended: 8)")
    dut._log.info(f"Register x7 = {val_x7} (Attended: 13)")
    dut._log.info(f"Register x8 = {val_x8} (Attended: 13)")
    dut._log.info(f"Register x9 = {val_x9} (Attended: 0x00001000)")
    dut._log.info(f"Register x10 = {val_x10} (Attended: 37)")

    # 5. Verification asserts
    assert val_x1 == 0,         f"Error x1: Attended 0, Obtained         {val_x1}"
    assert val_x2 == 169004903, f"Error x2: Attended 0xA12CF67(169004903), Obtained {val_x2}"
    assert val_x3 == 5,         f"Error x3: Attended 5, Obtained         {val_x3}"
    assert val_x4 == 1,         f"Error x4: Attended 1, Obtained         {val_x4}"
    assert val_x5 == 0,         f"Error x5: Attended 0, Obtained         {val_x5}"
    assert val_x6 == 8,         f"Error x6: Attended 8, Obtained         {val_x6}"
    assert val_x7 == 13,        f"Error x7: Attended 13, Obtained        {val_x7}"
    assert val_x8 == 13,        f"Error x8: Attended 13, Obtained        {val_x8}"
    assert val_x9 == 4096,      f"Error x9: Attended 4096, Obtained      {val_x9}"
    assert val_x10 == 37,       f"Error x10: Attended 37, Obtained       {val_x10}"

    dut._log.info("Test successfully passed: CPU single core is operative!")