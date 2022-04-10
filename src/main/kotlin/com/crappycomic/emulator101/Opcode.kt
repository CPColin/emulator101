package com.crappycomic.emulator101

enum class Opcode(val byte: UByte, val size: Int = 1) {
    NOOP(0x00),
    LOAD_PAIR_IMMEDIATE_STACK_POINTER(0x31, 3),
    JUMP_IF_NOT_ZERO(0xc2, 3),
    JUMP(0xc3, 3),
    ADD_IMMEDIATE(0xc6, 2),
    RETURN(0xc9),
    JUMP_IF_ZERO(0xca, 3),
    JUMP_IF_NO_CARRY(0xd2, 3),
    JUMP_IF_CARRY(0xda, 3),
    JUMP_IF_PARITY_ODD(0xe2, 3),
    JUMP_IF_PARITY_EVEN(0xea, 3),
    AND_IMMEDIATE(0xe6, 2),
    JUMP_IF_PLUS(0xf2, 3),
    JUMP_IF_MINUS(0xfa, 3),
    ;

    constructor(byte: Int, size: Int = 1) : this(byte.toUByte(), size)
}

val opcodes = Opcode.values().associateBy { it.byte }
