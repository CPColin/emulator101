package com.crappycomic.emulator101

/**
 * Disassembles and prints the instruction pointed to by the given [state].
 */
fun disassemble(state: State) {
    val address = state.programCounter
    val opcode = state.opcode
    val output = StringBuilder()

    val (mnemonic, arguments) = when (opcode) {
        Opcode.ADD_A -> "ADD" to "A"
        Opcode.ADD_A_WITH_CARRY -> "ADC" to "A"
        Opcode.ADD_B -> "ADD" to "B"
        Opcode.ADD_B_WITH_CARRY -> "ADC" to "B"
        Opcode.ADD_C -> "ADD" to "C"
        Opcode.ADD_C_WITH_CARRY -> "ADC" to "C"
        Opcode.ADD_D -> "ADD" to "D"
        Opcode.ADD_D_WITH_CARRY -> "ADC" to "D"
        Opcode.ADD_E -> "ADD" to "E"
        Opcode.ADD_E_WITH_CARRY -> "ADC" to "E"
        Opcode.ADD_H -> "ADD" to "H"
        Opcode.ADD_H_WITH_CARRY -> "ADC" to "H"
        Opcode.ADD_IMMEDIATE -> "ADI" to "#"
        Opcode.ADD_IMMEDIATE_WITH_CARRY -> "ACI" to "#"
        Opcode.ADD_L -> "ADD" to "L"
        Opcode.ADD_L_WITH_CARRY -> "ADC" to "L"
        Opcode.ADD_MEMORY -> "ADD" to "M"
        Opcode.ADD_MEMORY_WITH_CARRY -> "ADC" to "M"
        Opcode.AND_A -> "ANA" to "A"
        Opcode.AND_B -> "ANA" to "B"
        Opcode.AND_C -> "ANA" to "C"
        Opcode.AND_D -> "ANA" to "D"
        Opcode.AND_E -> "ANA" to "E"
        Opcode.AND_H -> "ANA" to "H"
        Opcode.AND_IMMEDIATE -> "ANI" to "#"
        Opcode.AND_L -> "ANA" to "L"
        Opcode.AND_MEMORY -> "ANA" to "M"
        Opcode.CALL -> "CALL" to "$"
        Opcode.CALL_IF_CARRY -> "CC" to "$"
        Opcode.CALL_IF_MINUS -> "CM" to "$"
        Opcode.CALL_IF_NO_CARRY -> "CNC" to "$"
        Opcode.CALL_IF_NOT_ZERO -> "CNZ" to "$"
        Opcode.CALL_IF_PARITY_EVEN -> "CPE" to "$"
        Opcode.CALL_IF_PARITY_ODD -> "CPO" to "$"
        Opcode.CALL_IF_PLUS -> "CP" to "$"
        Opcode.CALL_IF_ZERO -> "CZ" to "$"
        Opcode.COMPARE_A -> "CMP" to "A"
        Opcode.COMPARE_B -> "CMP" to "B"
        Opcode.COMPARE_C -> "CMP" to "C"
        Opcode.COMPARE_D -> "CMP" to "D"
        Opcode.COMPARE_E -> "CMP" to "E"
        Opcode.COMPARE_H -> "CMP" to "H"
        Opcode.COMPARE_IMMEDIATE -> "CPI" to "#"
        Opcode.COMPARE_L -> "CMP" to "L"
        Opcode.COMPARE_MEMORY -> "CMP" to "M"
        Opcode.COMPLEMENT_ACCUMULATOR -> "CMA" to null
        Opcode.COMPLEMENT_CARRY -> "CMC" to null
        Opcode.DECIMAL_ADJUST -> "DAA" to null
        Opcode.DECREMENT_A -> "DCR" to "A"
        Opcode.DECREMENT_B -> "DCR" to "B"
        Opcode.DECREMENT_C -> "DCR" to "C"
        Opcode.DECREMENT_D -> "DCR" to "D"
        Opcode.DECREMENT_E -> "DCR" to "E"
        Opcode.DECREMENT_H -> "DCR" to "H"
        Opcode.DECREMENT_L -> "DCR" to "L"
        Opcode.DECREMENT_MEMORY -> "DCR" to "M"
        Opcode.DECREMENT_PAIR_B -> "DCX" to "B"
        Opcode.DECREMENT_PAIR_D -> "DCX" to "D"
        Opcode.DECREMENT_PAIR_H -> "DCX" to "H"
        Opcode.DECREMENT_PAIR_STACK_POINTER -> "DCX" to "SP"
        Opcode.DISABLE_INTERRUPTS -> "DI" to null
        Opcode.DOUBLE_ADD_B -> "DAD" to "B"
        Opcode.DOUBLE_ADD_D -> "DAD" to "D"
        Opcode.DOUBLE_ADD_H -> "DAD" to "H"
        Opcode.DOUBLE_ADD_STACK_POINTER -> "DAD" to "SP"
        Opcode.ENABLE_INTERRUPTS -> "EI" to null
        Opcode.EXCHANGE_REGISTERS -> "XCHG" to null
        Opcode.EXCHANGE_STACK -> "XTHL" to null
        Opcode.HALT -> "HLT" to null
        Opcode.INCREMENT_A -> "INR" to "A"
        Opcode.INCREMENT_B -> "INR" to "B"
        Opcode.INCREMENT_C -> "INR" to "C"
        Opcode.INCREMENT_D -> "INR" to "D"
        Opcode.INCREMENT_E -> "INR" to "E"
        Opcode.INCREMENT_H -> "INR" to "H"
        Opcode.INCREMENT_L -> "INR" to "L"
        Opcode.INCREMENT_MEMORY -> "INR" to "M"
        Opcode.INCREMENT_PAIR_B -> "INX" to "B"
        Opcode.INCREMENT_PAIR_D -> "INX" to "D"
        Opcode.INCREMENT_PAIR_H -> "INX" to "H"
        Opcode.INCREMENT_PAIR_STACK_POINTER -> "INX" to "SP"
        Opcode.INPUT -> "IN" to ""
        Opcode.JUMP -> "JMP" to "$"
        Opcode.JUMP_IF_CARRY -> "JC" to "$"
        Opcode.JUMP_IF_MINUS -> "JM" to "$"
        Opcode.JUMP_IF_NO_CARRY -> "JNC" to "$"
        Opcode.JUMP_IF_NOT_ZERO -> "JNZ" to "$"
        Opcode.JUMP_IF_PARITY_EVEN -> "JPE" to "$"
        Opcode.JUMP_IF_PARITY_ODD -> "JPO" to "$"
        Opcode.JUMP_IF_PLUS -> "JP" to "$"
        Opcode.JUMP_IF_ZERO -> "JZ" to "$"
        Opcode.LOAD_ACCUMULATOR_B -> "LDAX" to "B"
        Opcode.LOAD_ACCUMULATOR_D -> "LDAX" to "D"
        Opcode.LOAD_ACCUMULATOR_DIRECT -> "LDA" to "$"
        Opcode.LOAD_HL_DIRECT -> "LHLD" to "$"
        Opcode.LOAD_PAIR_IMMEDIATE_B -> "LXI" to "B,#"
        Opcode.LOAD_PAIR_IMMEDIATE_D -> "LXI" to "D,#"
        Opcode.LOAD_PAIR_IMMEDIATE_H -> "LXI" to "H,#"
        Opcode.LOAD_PAIR_IMMEDIATE_STACK_POINTER -> "LXI" to "SP,#"
        Opcode.LOAD_PROGRAM_COUNTER -> "PCHL" to null
        Opcode.LOAD_STACK_POINTER -> "SPHL" to null
        Opcode.MOVE_A_A -> "MOV" to "A,A"
        Opcode.MOVE_A_B -> "MOV" to "A,B"
        Opcode.MOVE_A_C -> "MOV" to "A,C"
        Opcode.MOVE_A_D -> "MOV" to "A,D"
        Opcode.MOVE_A_E -> "MOV" to "A,E"
        Opcode.MOVE_A_H -> "MOV" to "A,H"
        Opcode.MOVE_A_L -> "MOV" to "A,L"
        Opcode.MOVE_A_MEMORY -> "MOV" to "A,M"
        Opcode.MOVE_B_A -> "MOV" to "B,A"
        Opcode.MOVE_B_B -> "MOV" to "B,B"
        Opcode.MOVE_B_C -> "MOV" to "B,C"
        Opcode.MOVE_B_D -> "MOV" to "B,D"
        Opcode.MOVE_B_E -> "MOV" to "B,E"
        Opcode.MOVE_B_H -> "MOV" to "B,H"
        Opcode.MOVE_B_L -> "MOV" to "B,L"
        Opcode.MOVE_B_MEMORY -> "MOV" to "B,M"
        Opcode.MOVE_C_A -> "MOV" to "C,A"
        Opcode.MOVE_C_B -> "MOV" to "C,B"
        Opcode.MOVE_C_C -> "MOV" to "C,C"
        Opcode.MOVE_C_D -> "MOV" to "C,D"
        Opcode.MOVE_C_E -> "MOV" to "C,E"
        Opcode.MOVE_C_H -> "MOV" to "C,H"
        Opcode.MOVE_C_L -> "MOV" to "C,L"
        Opcode.MOVE_C_MEMORY -> "MOV" to "C,M"
        Opcode.MOVE_D_A -> "MOV" to "D,A"
        Opcode.MOVE_D_B -> "MOV" to "D,B"
        Opcode.MOVE_D_C -> "MOV" to "D,C"
        Opcode.MOVE_D_D -> "MOV" to "D,D"
        Opcode.MOVE_D_E -> "MOV" to "D,E"
        Opcode.MOVE_D_H -> "MOV" to "D,H"
        Opcode.MOVE_D_L -> "MOV" to "D,L"
        Opcode.MOVE_D_MEMORY -> "MOV" to "D,M"
        Opcode.MOVE_E_A -> "MOV" to "E,A"
        Opcode.MOVE_E_B -> "MOV" to "E,B"
        Opcode.MOVE_E_C -> "MOV" to "E,C"
        Opcode.MOVE_E_D -> "MOV" to "E,D"
        Opcode.MOVE_E_E -> "MOV" to "E,E"
        Opcode.MOVE_E_H -> "MOV" to "E,H"
        Opcode.MOVE_E_L -> "MOV" to "E,L"
        Opcode.MOVE_E_MEMORY -> "MOV" to "E,M"
        Opcode.MOVE_H_A -> "MOV" to "H,A"
        Opcode.MOVE_H_B -> "MOV" to "H,B"
        Opcode.MOVE_H_C -> "MOV" to "H,C"
        Opcode.MOVE_H_D -> "MOV" to "H,D"
        Opcode.MOVE_H_E -> "MOV" to "H,E"
        Opcode.MOVE_H_H -> "MOV" to "H,H"
        Opcode.MOVE_H_L -> "MOV" to "H,L"
        Opcode.MOVE_H_MEMORY -> "MOV" to "H,M"
        Opcode.MOVE_IMMEDIATE_A -> "MVI" to "A,#"
        Opcode.MOVE_IMMEDIATE_B -> "MVI" to "B,#"
        Opcode.MOVE_IMMEDIATE_C -> "MVI" to "C,#"
        Opcode.MOVE_IMMEDIATE_D -> "MVI" to "D,#"
        Opcode.MOVE_IMMEDIATE_E -> "MVI" to "E,#"
        Opcode.MOVE_IMMEDIATE_H -> "MVI" to "H,#"
        Opcode.MOVE_IMMEDIATE_L -> "MVI" to "L,#"
        Opcode.MOVE_IMMEDIATE_MEMORY -> "MVI" to "M,#"
        Opcode.MOVE_L_A -> "MOV" to "L,A"
        Opcode.MOVE_L_B -> "MOV" to "L,B"
        Opcode.MOVE_L_C -> "MOV" to "L,C"
        Opcode.MOVE_L_D -> "MOV" to "L,D"
        Opcode.MOVE_L_E -> "MOV" to "L,E"
        Opcode.MOVE_L_H -> "MOV" to "L,H"
        Opcode.MOVE_L_L -> "MOV" to "L,L"
        Opcode.MOVE_L_MEMORY -> "MOV" to "L,M"
        Opcode.MOVE_MEMORY_A -> "MOV" to "M,A"
        Opcode.MOVE_MEMORY_B -> "MOV" to "M,B"
        Opcode.MOVE_MEMORY_C -> "MOV" to "M,C"
        Opcode.MOVE_MEMORY_D -> "MOV" to "M,D"
        Opcode.MOVE_MEMORY_E -> "MOV" to "M,E"
        Opcode.MOVE_MEMORY_H -> "MOV" to "M,H"
        Opcode.MOVE_MEMORY_L -> "MOV" to "M,L"
        Opcode.NOOP -> "NOP" to null
        Opcode.OR_A -> "ORA" to "A"
        Opcode.OR_B -> "ORA" to "B"
        Opcode.OR_C -> "ORA" to "C"
        Opcode.OR_D -> "ORA" to "D"
        Opcode.OR_E -> "ORA" to "E"
        Opcode.OR_H -> "ORA" to "H"
        Opcode.OR_IMMEDIATE -> "ORI" to "#"
        Opcode.OR_L -> "ORA" to "L"
        Opcode.OR_MEMORY -> "ORA" to "M"
        Opcode.OUTPUT -> "OUT" to ""
        Opcode.POP_B -> "POP" to "B"
        Opcode.POP_D -> "POP" to "D"
        Opcode.POP_H -> "POP" to "H"
        Opcode.POP_STATUS -> "POP" to "PSW"
        Opcode.PUSH_B -> "PUSH" to "B"
        Opcode.PUSH_D -> "PUSH" to "D"
        Opcode.PUSH_H -> "PUSH" to "H"
        Opcode.PUSH_STATUS -> "PUSH" to "PSW"
        Opcode.RESTART_0 -> "RST" to "0"
        Opcode.RESTART_1 -> "RST" to "1"
        Opcode.RESTART_2 -> "RST" to "2"
        Opcode.RESTART_3 -> "RST" to "3"
        Opcode.RESTART_4 -> "RST" to "4"
        Opcode.RESTART_5 -> "RST" to "5"
        Opcode.RESTART_6 -> "RST" to "6"
        Opcode.RESTART_7 -> "RST" to "7"
        Opcode.RETURN -> "RET" to null
        Opcode.RETURN_IF_CARRY -> "RC" to null
        Opcode.RETURN_IF_MINUS -> "RM" to null
        Opcode.RETURN_IF_NO_CARRY -> "RNC" to null
        Opcode.RETURN_IF_NOT_ZERO -> "RNZ" to null
        Opcode.RETURN_IF_PARITY_EVEN -> "RPE" to null
        Opcode.RETURN_IF_PARITY_ODD -> "RPO" to null
        Opcode.RETURN_IF_PLUS -> "RP" to null
        Opcode.RETURN_IF_ZERO -> "RZ" to null
        Opcode.ROTATE_LEFT -> "RLC" to null // RLC and RAL feel backwards
        Opcode.ROTATE_LEFT_THROUGH_CARRY -> "RAL" to null
        Opcode.ROTATE_RIGHT -> "RRC" to null // RRC and RAR feel backwards
        Opcode.ROTATE_RIGHT_THROUGH_CARRY -> "RAR" to null
        Opcode.SET_CARRY -> "STC" to null
        Opcode.STORE_ACCUMULATOR_B -> "STX" to "B"
        Opcode.STORE_ACCUMULATOR_D -> "STX" to "D"
        Opcode.STORE_ACCUMULATOR_DIRECT -> "STA" to "$"
        Opcode.STORE_HL_DIRECT -> "SHLD" to "$"
        Opcode.SUBTRACT_A -> "SUB" to "A"
        Opcode.SUBTRACT_A_WITH_BORROW -> "SBB" to "A"
        Opcode.SUBTRACT_B -> "SUB" to "B"
        Opcode.SUBTRACT_B_WITH_BORROW -> "SBB" to "B"
        Opcode.SUBTRACT_C -> "SUB" to "C"
        Opcode.SUBTRACT_C_WITH_BORROW -> "SBB" to "C"
        Opcode.SUBTRACT_D -> "SUB" to "D"
        Opcode.SUBTRACT_D_WITH_BORROW -> "SBB" to "D"
        Opcode.SUBTRACT_E -> "SUB" to "E"
        Opcode.SUBTRACT_E_WITH_BORROW -> "SBB" to "E"
        Opcode.SUBTRACT_H -> "SUB" to "H"
        Opcode.SUBTRACT_H_WITH_BORROW -> "SBB" to "H"
        Opcode.SUBTRACT_IMMEDIATE -> "SUI" to "#"
        Opcode.SUBTRACT_IMMEDIATE_WITH_BORROW -> "SBI" to "#"
        Opcode.SUBTRACT_L -> "SUB" to "L"
        Opcode.SUBTRACT_L_WITH_BORROW -> "SBB" to "L"
        Opcode.SUBTRACT_MEMORY -> "SUB" to "M"
        Opcode.SUBTRACT_MEMORY_WITH_BORROW -> "SBB" to "M"
        Opcode.XOR_A -> "XRA" to "A"
        Opcode.XOR_B -> "XRA" to "B"
        Opcode.XOR_C -> "XRA" to "C"
        Opcode.XOR_D -> "XRA" to "D"
        Opcode.XOR_E -> "XRA" to "E"
        Opcode.XOR_H -> "XRA" to "H"
        Opcode.XOR_IMMEDIATE -> "XRI" to "#"
        Opcode.XOR_L -> "XRA" to "L"
        Opcode.XOR_MEMORY -> "XRA" to "M"
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