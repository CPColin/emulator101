package com.crappycomic.emulator101

/**
 * Disassembles and prints the instruction pointed to by the given [state].
 */
fun disassemble(state: State) {
    val address = state.programCounter
    val opcode = state.opcode
    val output = StringBuilder()

    val (mnemonic, arguments) = when (opcode) {
        Opcode.ADD_IMMEDIATE -> "ADI" to "#"
        Opcode.AND_IMMEDIATE -> "ANI" to "#"
        Opcode.JUMP -> "JMP" to "$"
        Opcode.JUMP_IF_CARRY -> "JC" to "$"
        Opcode.JUMP_IF_MINUS -> "JM" to "$"
        Opcode.JUMP_IF_NO_CARRY -> "JNC" to "$"
        Opcode.JUMP_IF_NOT_ZERO -> "JNZ" to "$"
        Opcode.JUMP_IF_PARITY_EVEN -> "JPE" to "$"
        Opcode.JUMP_IF_PARITY_ODD -> "JPO" to "$"
        Opcode.JUMP_IF_PLUS -> "JP" to "$"
        Opcode.JUMP_IF_ZERO -> "JZ" to "$"
        Opcode.LOAD_PAIR_IMMEDIATE_STACK_POINTER -> "LXI" to "SP,#"
        Opcode.NOOP -> "NOP" to null
        Opcode.RETURN -> "RET" to null
    }

    output.append(format(address))
    output.append(' ')
    output.append(mnemonic)

    if (arguments is String) {
        while (output.length < 12) {
            output.append(' ')
        }

        output.append(arguments)

        if (opcode.size > 1) {
            if (opcode.size == 3) {
                output.append(format(state.memory[address + 2.toUShort()]))
            }

            output.append(format(state.memory[address + 1.toUShort()]))
        }
    }

    println(output)
}