package com.crappycomic.emulator101

data class State(
    val flagAuxiliaryCarry: Boolean = false,

    val flagCarry: Boolean = false,

    val flagParity: Boolean = false,

    val flagSign: Boolean = false,

    val flagZero: Boolean = false,

    val memory: Memory,

    val programCounter: UShort = 0.toUShort(),

    val registerA: UByte = 0.toUByte(),

    val registerB: UByte = 0.toUByte(),

    val registerC: UByte = 0.toUByte(),

    val registerD: UByte = 0.toUByte(),

    val registerE: UByte = 0.toUByte(),

    val registerH: UByte = 0.toUByte(),

    val registerL: UByte = 0.toUByte(),

    val stackPointer: UShort = 0.toUShort(),

    val stopped: Boolean = false
) {
    val dataByte = memory[programCounter add 1]

    val dataBytes = memory[programCounter add 2] to memory[programCounter add 1]

    val dataWord = dataBytes.let { word(it.first, it.second) }

    val flagNoCarry = !flagCarry

    val flagNotZero = !flagZero

    val flagParityEven = flagParity

    val flagParityOdd = !flagParity

    val flags = 0.toUByte()
        .set(FLAG_BIT_CARRY, flagCarry)
        .set(1, true) // Unused, always high (living the dream)
        .set(FLAG_BIT_PARITY, flagParity)
        .set(FLAG_BIT_AUXILIARY_CARRY, flagAuxiliaryCarry)
        .set(FLAG_BIT_ZERO, flagZero)
        .set(FLAG_BIT_SIGN, flagSign)

    val flagSignMinus = flagSign

    val flagSignPlus = !flagSign

    val opcode: Opcode =
        memory[programCounter].let { byte ->
            opcodes[byte]
                ?: error("Unsupported opcode ${format(byte)} at address ${format(programCounter)}")
        }

    val nextProgramCounter = programCounter add opcode.size

    val stackBytes = memory[stackPointer add 1] to memory[stackPointer]

    val stackPointerHigh = bytes(stackPointer).first

    val stackPointerLow = bytes(stackPointer).second

    val stackWord = stackBytes.let { word(it.first, it.second) }

    fun withNextProgramCounter() = copy(programCounter = nextProgramCounter)

    companion object {
        const val FLAG_BIT_CARRY = 0

        const val FLAG_BIT_PARITY = 2

        const val FLAG_BIT_AUXILIARY_CARRY = 4

        const val FLAG_BIT_ZERO = 6

        const val FLAG_BIT_SIGN = 7
    }
}