package com.crappycomic.emulator101

import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource
import kotlin.test.Test
import kotlin.test.assertEquals

@ParameterizedTestClass
class EmulateTests {
    private fun testState(opcode: Opcode) = State(
        memory = Memory(
            size = 0x100
        ).with(
            0.toUShort() to opcode.byte
        ),
        stackPointer = 0x100.toUShort()
    )

    @Test
    fun disableInterrupts() {
        val state = testState(Opcode.DISABLE_INTERRUPTS)

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                interruptsEnabled = false,
                programCounter = state.programCounter add 1
            ),
            result
        )
    }

    @Test
    fun enableInterrupts() {
        val state = testState(Opcode.ENABLE_INTERRUPTS).copy(interruptsEnabled = true)

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                interruptsEnabled = true,
                programCounter = state.programCounter add 1
            ),
            result
        )
    }

    @Test
    fun halt() {
        val state = testState(Opcode.HALT)

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                programCounter = state.programCounter add 1,
                stopped = true
            ),
            result
        )
    }

    @ParameterizedTest
    @ValueSource(ints = [0, 1, 2, 3, 4, 5, 6, 7])
    fun restart(index: Int) {
        val opcode = Opcode.valueOf("RESTART_$index")
        val state = testState(opcode)

        val (high, low) = bytes(state.nextProgramCounter)

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                memory = state.memory.with(
                    state.stackPointer sub 1 to high,
                    state.stackPointer sub 2 to low
                ),
                programCounter = (index * 8).toUShort(),
                stackPointer = state.stackPointer sub 2
            ),
            result
        )
    }
}