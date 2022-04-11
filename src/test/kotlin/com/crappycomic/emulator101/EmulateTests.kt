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