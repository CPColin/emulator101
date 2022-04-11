package com.crappycomic.emulator101

import kotlin.test.Test
import kotlin.test.assertEquals

class OpcodeTests {
    @Test
    fun opcodesAreSortedByByte() {
        val opcodes = Opcode.values().toList()
        val opcodesSortedByByte = opcodes.sortedBy { it.byte }

        assertEquals(opcodesSortedByByte, opcodes)
    }
}
