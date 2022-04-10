package com.crappycomic.emulator101

import kotlin.test.Test

class CpuDiagnostic {
    @Test
    fun run() {
        val rom = javaClass.getResource("/cpudiag.bin")

        requireNotNull(rom) { "Unable to load cpudiag.bin. Check the README." }

        // The first 0x100 bytes of CP/M memory is reserved for system call handlers.
        // We'll load the ROM at 0x100 and disable the handler at 0x005, then handle system calls
        // in our while loop.
        val initialProgramCounter = 0x0100.toUShort()
        val memory = Memory(
            initialValues = rom.readBytes(),
            initialValuesOffset = initialProgramCounter.toInt(),
            size = 0x1000
        ).with(0x0005 to Opcode.RETURN.byte)

        var state = State(
            memory = memory,
            programCounter = initialProgramCounter
        )

        while (true) {
            disassemble(state)

            state = emulate(state).first

            if (state.programCounter < initialProgramCounter) {
                when (state.programCounter.toInt()) {
                    0x0 -> {
                        println("Exiting")

                        break
                    }
                    0x5 -> {
                        when (state.registerC.toInt()) {
                            0x02 -> {
                                // Console Output
                                print(state.registerE.toInt().toChar())
                            }
                            0x09 -> {
                                // Print String
                                var address = word(state.registerD, state.registerE) add 3
                                val output = StringBuilder()

                                // Append characters until a '$' is found.
                                while (state.memory[address] != '$'.code.toUByte()) {
                                    output.append(state.memory[address].toInt().toChar())

                                    address++
                                }
                            }
                            else -> println("System call ${state.registerC} not implemented")
                        }
                    }
                    else -> println("Jump to handler at ${state.programCounter} not implemented")
                }
            }
        }
    }
}
