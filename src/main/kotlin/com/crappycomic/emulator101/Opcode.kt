package com.crappycomic.emulator101

enum class Opcode(val byte: UByte, val size: Int = 1) {
    NOOP(0x00),
    LOAD_PAIR_IMMEDIATE_B(0x01, 3),
    STORE_ACCUMULATOR_B(0x02),
    INCREMENT_PAIR_B(0x03),
    INCREMENT_B(0x04),
    DECREMENT_B(0x05),
    MOVE_IMMEDIATE_B(0x06, 2),
    ROTATE_LEFT(0x07),
    DOUBLE_ADD_B(0x09),
    LOAD_ACCUMULATOR_B(0x0a),
    DECREMENT_PAIR_B(0x0b),
    INCREMENT_C(0x0c),
    DECREMENT_C(0x0d),
    MOVE_IMMEDIATE_C(0x0e, 2),
    ROTATE_RIGHT(0x0f),
    LOAD_PAIR_IMMEDIATE_D(0x11, 3),
    STORE_ACCUMULATOR_D(0x12),
    INCREMENT_PAIR_D(0x13),
    INCREMENT_D(0x14),
    DECREMENT_D(0x15),
    MOVE_IMMEDIATE_D(0x16, 2),
    ROTATE_LEFT_THROUGH_CARRY(0x17),
    DOUBLE_ADD_D(0x19),
    LOAD_ACCUMULATOR_D(0x1a),
    DECREMENT_PAIR_D(0x1b),
    INCREMENT_E(0x1c),
    DECREMENT_E(0x1d),
    MOVE_IMMEDIATE_E(0x1e, 2),
    ROTATE_RIGHT_THROUGH_CARRY(0x1f),
    LOAD_PAIR_IMMEDIATE_H(0x21, 3),
    STORE_HL_DIRECT(0x22, 3),
    INCREMENT_PAIR_H(0x23),
    INCREMENT_H(0x24),
    DECREMENT_H(0x25),
    MOVE_IMMEDIATE_H(0x26, 2),
    DECIMAL_ADJUST(0x27),
    DOUBLE_ADD_H(0x29),
    LOAD_HL_DIRECT(0x2a, 3),
    DECREMENT_PAIR_H(0x2b),
    INCREMENT_L(0x2c),
    DECREMENT_L(0x2d),
    MOVE_IMMEDIATE_L(0x2e, 2),
    COMPLEMENT_ACCUMULATOR(0x2f),
    LOAD_PAIR_IMMEDIATE_STACK_POINTER(0x31, 3),
    STORE_ACCUMULATOR_DIRECT(0x32, 3),
    INCREMENT_PAIR_STACK_POINTER(0x33),
    INCREMENT_MEMORY(0x34),
    DECREMENT_MEMORY(0x35),
    MOVE_IMMEDIATE_MEMORY(0x36, 2),
    SET_CARRY(0x37),
    DOUBLE_ADD_STACK_POINTER(0x39),
    LOAD_ACCUMULATOR_DIRECT(0x3a, 3),
    DECREMENT_PAIR_STACK_POINTER(0x3b),
    INCREMENT_A(0x3c),
    DECREMENT_A(0x3d),
    MOVE_IMMEDIATE_A(0x3e, 2),
    COMPLEMENT_CARRY(0x3f),
    MOVE_B_B(0x40),
    MOVE_B_C(0x41),
    MOVE_B_D(0x42),
    MOVE_B_E(0x43),
    MOVE_B_H(0x44),
    MOVE_B_L(0x45),
    MOVE_B_MEMORY(0x46),
    MOVE_B_A(0x47),
    MOVE_C_B(0x48),
    MOVE_C_C(0x49),
    MOVE_C_D(0x4a),
    MOVE_C_E(0x4b),
    MOVE_C_H(0x4c),
    MOVE_C_L(0x4d),
    MOVE_C_A(0x4f),
    MOVE_D_B(0x50),
    MOVE_D_C(0x51),
    MOVE_D_D(0x52),
    MOVE_D_E(0x53),
    MOVE_D_H(0x54),
    MOVE_D_L(0x55),
    MOVE_D_MEMORY(0x56),
    MOVE_D_A(0x57),
    MOVE_E_B(0x58),
    MOVE_E_C(0x59),
    MOVE_E_D(0x5a),
    MOVE_E_E(0x5b),
    MOVE_E_H(0x5c),
    MOVE_E_L(0x5d),
    MOVE_E_MEMORY(0x5e),
    MOVE_E_A(0x5f),
    MOVE_H_B(0x60),
    MOVE_H_C(0x61),
    MOVE_H_D(0x62),
    MOVE_H_E(0x63),
    MOVE_H_H(0x64),
    MOVE_H_L(0x65),
    MOVE_H_MEMORY(0x66),
    MOVE_H_A(0x67),
    MOVE_L_B(0x68),
    MOVE_L_C(0x69),
    MOVE_L_D(0x6a),
    MOVE_L_E(0x6b),
    MOVE_L_H(0x6c),
    MOVE_L_L(0x6d),
    MOVE_L_MEMORY(0x6e),
    MOVE_L_A(0x6f),
    MOVE_MEMORY_B(0x70),
    MOVE_MEMORY_C(0x71),
    MOVE_MEMORY_D(0x72),
    MOVE_MEMORY_E(0x73),
    MOVE_MEMORY_H(0x74),
    MOVE_MEMORY_L(0x75),
    HALT(0x76),
    MOVE_MEMORY_A(0x77),
    MOVE_A_B(0x78),
    MOVE_A_C(0x79),
    MOVE_A_D(0x7a),
    MOVE_A_E(0x7b),
    MOVE_A_H(0x7c),
    MOVE_A_L(0x7d),
    MOVE_A_MEMORY(0x7e),
    MOVE_A_A(0x7f),
    ADD_B(0x80),
    ADD_C(0x81),
    ADD_D(0x82),
    ADD_E(0x83),
    ADD_H(0x84),
    ADD_L(0x85),
    ADD_MEMORY(0x86),
    ADD_A(0x87),
    ADD_B_WITH_CARRY(0x88),
    ADD_C_WITH_CARRY(0x89),
    ADD_D_WITH_CARRY(0x8a),
    ADD_E_WITH_CARRY(0x8b),
    ADD_H_WITH_CARRY(0x8c),
    ADD_L_WITH_CARRY(0x8d),
    ADD_MEMORY_WITH_CARRY(0x8e),
    ADD_A_WITH_CARRY(0x8f),
    SUBTRACT_B(0x90),
    SUBTRACT_C(0x91),
    SUBTRACT_D(0x92),
    SUBTRACT_E(0x93),
    SUBTRACT_H(0x94),
    SUBTRACT_L(0x95),
    SUBTRACT_MEMORY(0x96),
    SUBTRACT_A(0x97),
    SUBTRACT_B_WITH_BORROW(0x98),
    SUBTRACT_C_WITH_BORROW(0x99),
    SUBTRACT_D_WITH_BORROW(0x9a),
    SUBTRACT_E_WITH_BORROW(0x9b),
    SUBTRACT_H_WITH_BORROW(0x9c),
    SUBTRACT_L_WITH_BORROW(0x9d),
    SUBTRACT_MEMORY_WITH_BORROW(0x9e),
    SUBTRACT_A_WITH_BORROW(0x9f),
    AND_B(0xa0),
    AND_C(0xa1),
    AND_D(0xa2),
    AND_E(0xa3),
    AND_H(0xa4),
    AND_L(0xa5),
    AND_MEMORY(0xa6),
    AND_A(0xa7),
    XOR_B(0xa8),
    XOR_C(0xa9),
    XOR_D(0xaa),
    XOR_E(0xab),
    XOR_H(0xac),
    XOR_L(0xad),
    XOR_MEMORY(0xae),
    XOR_A(0xaf),
    OR_B(0xb0),
    OR_C(0xb1),
    OR_D(0xb2),
    OR_E(0xb3),
    OR_H(0xb4),
    OR_L(0xb5),
    OR_MEMORY(0xb6),
    OR_A(0xb7),
    COMPARE_B(0xb8),
    COMPARE_C(0xb9),
    COMPARE_D(0xba),
    COMPARE_E(0xbb),
    COMPARE_H(0xbc),
    COMPARE_L(0xbd),
    COMPARE_MEMORY(0xbe),
    COMPARE_A(0xbf),
    RETURN_IF_NOT_ZERO(0xc0),
    POP_B(0xc1),
    JUMP_IF_NOT_ZERO(0xc2, 3),
    JUMP(0xc3, 3),
    CALL_IF_NOT_ZERO(0xc4, 3),
    PUSH_B(0xc5),
    ADD_IMMEDIATE(0xc6, 2),
    RETURN_IF_ZERO(0xc8),
    RETURN(0xc9),
    JUMP_IF_ZERO(0xca, 3),
    CALL_IF_ZERO(0xcc, 3),
    CALL(0xcd, 3),
    ADD_IMMEDIATE_WITH_CARRY(0xce, 2),
    RETURN_IF_NO_CARRY(0xd0),
    POP_D(0xd1),
    JUMP_IF_NO_CARRY(0xd2, 3),
    CALL_IF_NO_CARRY(0xd4, 3),
    PUSH_D(0xd5),
    SUBTRACT_IMMEDIATE(0xd6, 2),
    RETURN_IF_CARRY(0xd8),
    JUMP_IF_CARRY(0xda, 3),
    CALL_IF_CARRY(0xdc, 3),
    SUBTRACT_IMMEDIATE_WITH_BORROW(0xde, 2),
    RETURN_IF_PARITY_ODD(0xe0),
    POP_H(0xe1),
    JUMP_IF_PARITY_ODD(0xe2, 3),
    EXCHANGE_STACK(0xe3),
    CALL_IF_PARITY_ODD(0xe4, 3),
    PUSH_H(0xe5),
    AND_IMMEDIATE(0xe6, 2),
    RETURN_IF_PARITY_EVEN(0xe8),
    LOAD_PROGRAM_COUNTER(0xe9),
    JUMP_IF_PARITY_EVEN(0xea, 3),
    EXCHANGE_REGISTERS(0xeb),
    CALL_IF_PARITY_EVEN(0xec, 3),
    XOR_IMMEDIATE(0xee, 2),
    RETURN_IF_PLUS(0xf0),
    POP_STATUS(0xf1),
    JUMP_IF_PLUS(0xf2, 3),
    CALL_IF_PLUS(0xf4, 3),
    PUSH_STATUS(0xf5),
    OR_IMMEDIATE(0xf6, 2),
    RETURN_IF_MINUS(0xf8),
    LOAD_STACK_POINTER(0xf9),
    JUMP_IF_MINUS(0xfa, 3),
    CALL_IF_MINUS(0xfc, 3),
    COMPARE_IMMEDIATE(0xfe, 2),
    ;

    constructor(byte: Int, size: Int = 1) : this(byte.toUByte(), size)
}

val opcodes = Opcode.values().associateBy { it.byte }
