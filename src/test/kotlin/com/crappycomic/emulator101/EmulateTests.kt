package com.crappycomic.emulator101

import kotlin.test.Test
import kotlin.test.assertEquals

class EmulateTests {
    private fun testState(opcode: Opcode) = State(
        memory = Memory(
            size = 0x100
        ).with(
            0.toUShort() to opcode.byte
        )
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
}