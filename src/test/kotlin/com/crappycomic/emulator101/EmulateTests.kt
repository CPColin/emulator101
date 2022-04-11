package com.crappycomic.emulator101

import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource
import org.mockito.kotlin.doReturn
import org.mockito.kotlin.mock
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever
import java.util.*
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

    @Test
    fun input() {
        val random = Random(0)

        val data = random.nextInt().toUByte()
        val device = random.nextInt().toUByte()

        val inputOutput = mock<InputOutput> {
            whenever(mock.input(device)).doReturn(data)
        }

        val state = testState(Opcode.INPUT).let {
            it.copy(
                inputOutput = inputOutput,
                memory = it.memory.with(
                    1.toUShort() to device
                )
            )
        }

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                programCounter = state.programCounter add 2,
                registerA = data
            ),
            result
        )

        verify(inputOutput).input(device)
    }

    @Test
    fun output() {
        val random = Random(1)

        val data = random.nextInt().toUByte()
        val device = random.nextInt().toUByte()

        val inputOutput = mock<InputOutput> {
            whenever(mock.output(device, data)).doReturn(mock)
        }

        val state = testState(Opcode.OUTPUT).let {
            it.copy(
                inputOutput = inputOutput,
                memory = it.memory.with(
                    1.toUShort() to device
                ),
                registerA = data
            )
        }

        val (result, _) = emulate(state)

        assertEquals(
            state.copy(
                programCounter = state.programCounter add 2
            ),
            result
        )

        verify(inputOutput).output(device, data)
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