package com.crappycomic.emulator101

/**
 * Represents the state of the 8080 CPU and its connected [InputOutput] hardware.
 */
class State(
    val flagAuxiliaryCarry: Boolean = false,

    val flagCarry: Boolean = false,

    val flagParity: Boolean = false,

    val flagSign: Boolean = false,

    val flagZero: Boolean = false,

    val inputOutput: InputOutput = InputOutput.noop,

    val interrupt: Opcode? = null,

    val interruptsEnabled: Boolean = false,

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
        if (interrupt is Opcode) {
            interrupt
        } else {
            memory[programCounter].let { byte ->
                opcodes[byte]
                    ?: error("Unsupported opcode ${format(byte)} at address ${format(programCounter)}, $memory")
            }
        }

    val nextProgramCounter =
        if (interrupt is Opcode) programCounter else programCounter add opcode.size

    val stackPointerHigh = bytes(stackPointer).first

    val stackPointerLow = bytes(stackPointer).second

    val stackWord = word(memory[stackPointer add 1], memory[stackPointer])

    override fun equals(other: Any?) =
        other is State &&
                flagAuxiliaryCarry == other.flagAuxiliaryCarry &&
                flagCarry == other.flagCarry &&
                flagParity == other.flagParity &&
                flagSign == other.flagSign &&
                flagZero == other.flagZero &&
                inputOutput == other.inputOutput &&
                interrupt == other.interrupt &&
                interruptsEnabled == other.interruptsEnabled &&
                memory == other.memory &&
                programCounter == other.programCounter &&
                registerA == other.registerA &&
                registerB == other.registerB &&
                registerC == other.registerC &&
                registerD == other.registerD &&
                registerE == other.registerE &&
                registerH == other.registerH &&
                registerL == other.registerL &&
                stackPointer == other.stackPointer &&
                stopped == other.stopped

    override fun hashCode(): Int {
        var result = flagAuxiliaryCarry.hashCode()
        result = 31 * result + flagCarry.hashCode()
        result = 31 * result + flagParity.hashCode()
        result = 31 * result + flagSign.hashCode()
        result = 31 * result + flagZero.hashCode()
        result = 31 * result + inputOutput.hashCode()
        result = 31 * result + (interrupt?.hashCode() ?: 0)
        result = 31 * result + interruptsEnabled.hashCode()
        result = 31 * result + memory.hashCode()
        result = 31 * result + programCounter.hashCode()
        result = 31 * result + registerA.hashCode()
        result = 31 * result + registerB.hashCode()
        result = 31 * result + registerC.hashCode()
        result = 31 * result + registerD.hashCode()
        result = 31 * result + registerE.hashCode()
        result = 31 * result + registerH.hashCode()
        result = 31 * result + registerL.hashCode()
        result = 31 * result + stackPointer.hashCode()
        result = 31 * result + stopped.hashCode()
        result = 31 * result + dataByte.hashCode()
        result = 31 * result + dataBytes.hashCode()
        result = 31 * result + dataWord.hashCode()
        result = 31 * result + flagNoCarry.hashCode()
        result = 31 * result + flagNotZero.hashCode()
        result = 31 * result + flagParityEven.hashCode()
        result = 31 * result + flagParityOdd.hashCode()
        result = 31 * result + flags.hashCode()
        result = 31 * result + flagSignMinus.hashCode()
        result = 31 * result + flagSignPlus.hashCode()
        result = 31 * result + opcode.hashCode()
        result = 31 * result + nextProgramCounter.hashCode()
        result = 31 * result + stackPointerHigh.hashCode()
        result = 31 * result + stackPointerLow.hashCode()
        result = 31 * result + stackWord.hashCode()
        return result
    }

    override fun toString() =
        """
            State {
                flagAuxiliaryCarry: $flagAuxiliaryCarry
                flagCarry: $flagCarry
                flagParity: $flagParity
                flagSign: $flagSign
                flagZero: $flagZero
                inputOutput: InputOutput
                interrupt: $interrupt
                interruptsEnabled: $interruptsEnabled
                memory: Memory
                programCounter: $programCounter
                registerA: $registerA
                registerB: $registerB
                registerC: $registerC
                registerD: $registerD
                registerE: $registerE
                registerH: $registerH
                registerL: $registerL
                stackPointer: $stackPointer
                stopped: $stopped
            }
        """.trimIndent()

    /**
     * Returns a copy of this instance with the given fields updated. Advances the [programCounter]
     * to the next value unless explicitly given. Always clears the current [interrupt]. (The latter
     * is why we can't just use a data class and copy().)
     */
    fun with(
        flagAuxiliaryCarry: Boolean = this.flagAuxiliaryCarry,
        flagCarry: Boolean = this.flagCarry,
        flagParity: Boolean = this.flagParity,
        flagSign: Boolean = this.flagSign,
        flagZero: Boolean = this.flagZero,
        inputOutput: InputOutput = this.inputOutput,
        interruptsEnabled: Boolean = this.interruptsEnabled,
        memory: Memory = this.memory,
        programCounter: UShort = this.nextProgramCounter,
        registerA: UByte = this.registerA,
        registerB: UByte = this.registerB,
        registerC: UByte = this.registerC,
        registerD: UByte = this.registerD,
        registerE: UByte = this.registerE,
        registerH: UByte = this.registerH,
        registerL: UByte = this.registerL,
        stackPointer: UShort = this.stackPointer,
        stopped: Boolean = this.stopped
    ) = State(
        flagAuxiliaryCarry = flagAuxiliaryCarry,
        flagCarry = flagCarry,
        flagParity = flagParity,
        flagSign = flagSign,
        flagZero = flagZero,
        inputOutput = inputOutput,
        interrupt = null,
        interruptsEnabled = interruptsEnabled,
        memory = memory,
        programCounter = programCounter,
        registerA = registerA,
        registerB = registerB,
        registerC = registerC,
        registerD = registerD,
        registerE = registerE,
        registerH = registerH,
        registerL = registerL,
        stackPointer = stackPointer,
        stopped = stopped
    )

    fun withInterrupt(interrupt: Opcode) = State(
        flagAuxiliaryCarry = flagAuxiliaryCarry,
        flagCarry = flagCarry,
        flagParity = flagParity,
        flagSign = flagSign,
        flagZero = flagZero,
        inputOutput = inputOutput,
        interrupt = interrupt,
        interruptsEnabled = false,
        memory = memory,
        programCounter = programCounter,
        registerA = registerA,
        registerB = registerB,
        registerC = registerC,
        registerD = registerD,
        registerE = registerE,
        registerH = registerH,
        registerL = registerL,
        stackPointer = stackPointer,
        stopped = false
    )

    companion object {
        const val FLAG_BIT_CARRY = 0

        const val FLAG_BIT_PARITY = 2

        const val FLAG_BIT_AUXILIARY_CARRY = 4

        const val FLAG_BIT_ZERO = 6

        const val FLAG_BIT_SIGN = 7
    }
}