package com.crappycomic.emulator101

typealias EmulationResult = Pair<State, Int>

typealias Emulator = (State) -> EmulationResult

typealias Register = (State) -> UByte

/**
 * Emulates the instruction pointed to by the given [state] and returns the new [State] along with
 * the number of cycles it took to execute the instruction.
 */
fun emulate(state: State): EmulationResult {
    val emulator: Emulator = when (state.opcode) {
        Opcode.ADD_A -> emulateAddRegister(State::registerA, false)
        Opcode.ADD_A_WITH_CARRY -> emulateAddRegister(State::registerA, true)
        Opcode.ADD_B -> emulateAddRegister(State::registerB, false)
        Opcode.ADD_B_WITH_CARRY -> emulateAddRegister(State::registerB, true)
        Opcode.ADD_C -> emulateAddRegister(State::registerC, false)
        Opcode.ADD_C_WITH_CARRY -> emulateAddRegister(State::registerC, true)
        Opcode.ADD_D -> emulateAddRegister(State::registerD, false)
        Opcode.ADD_D_WITH_CARRY -> emulateAddRegister(State::registerD, true)
        Opcode.ADD_E -> emulateAddRegister(State::registerE, false)
        Opcode.ADD_E_WITH_CARRY -> emulateAddRegister(State::registerE, true)
        Opcode.ADD_H -> emulateAddRegister(State::registerH, false)
        Opcode.ADD_H_WITH_CARRY -> emulateAddRegister(State::registerH, true)
        Opcode.ADD_IMMEDIATE -> emulateAddImmediate(false)
        Opcode.ADD_IMMEDIATE_WITH_CARRY -> emulateAddImmediate(true)
        Opcode.ADD_L -> emulateAddRegister(State::registerL, false)
        Opcode.ADD_L_WITH_CARRY -> emulateAddRegister(State::registerL, true)
        Opcode.ADD_MEMORY -> emulateAddMemory(false)
        Opcode.ADD_MEMORY_WITH_CARRY -> emulateAddMemory(true)
        Opcode.AND_A -> emulateAndRegister(State::registerA)
        Opcode.AND_B -> emulateAndRegister(State::registerB)
        Opcode.AND_C -> emulateAndRegister(State::registerC)
        Opcode.AND_D -> emulateAndRegister(State::registerD)
        Opcode.AND_E -> emulateAndRegister(State::registerE)
        Opcode.AND_H -> emulateAndRegister(State::registerH)
        Opcode.AND_IMMEDIATE -> ::emulateAndImmediate
        Opcode.AND_L -> emulateAndRegister(State::registerL)
        Opcode.AND_MEMORY -> ::emulateAndMemory
        Opcode.CALL -> emulateCallIf { true }
        Opcode.CALL_IF_CARRY -> emulateCallIf(State::flagCarry)
        Opcode.CALL_IF_MINUS -> emulateCallIf(State::flagSignMinus)
        Opcode.CALL_IF_NO_CARRY -> emulateCallIf(State::flagNoCarry)
        Opcode.CALL_IF_NOT_ZERO -> emulateCallIf(State::flagNotZero)
        Opcode.CALL_IF_PARITY_EVEN -> emulateCallIf(State::flagParityEven)
        Opcode.CALL_IF_PARITY_ODD -> emulateCallIf(State::flagParityOdd)
        Opcode.CALL_IF_PLUS -> emulateCallIf(State::flagSignPlus)
        Opcode.CALL_IF_ZERO -> emulateCallIf(State::flagZero)
        Opcode.COMPARE_A -> emulateCompareRegister(State::registerA)
        Opcode.COMPARE_B -> emulateCompareRegister(State::registerB)
        Opcode.COMPARE_C -> emulateCompareRegister(State::registerC)
        Opcode.COMPARE_D -> emulateCompareRegister(State::registerD)
        Opcode.COMPARE_E -> emulateCompareRegister(State::registerE)
        Opcode.COMPARE_H -> emulateCompareRegister(State::registerH)
        Opcode.COMPARE_IMMEDIATE -> ::emulateCompareImmediate
        Opcode.COMPARE_L -> emulateCompareRegister(State::registerL)
        Opcode.COMPARE_MEMORY -> ::emulateCompareMemory
        Opcode.COMPLEMENT_ACCUMULATOR -> ::emulateComplementAccumulator
        Opcode.COMPLEMENT_CARRY -> ::emulateComplementCarry
        Opcode.DECIMAL_ADJUST -> ::emulateDecimalAdjust
        Opcode.DECREMENT_A -> ::emulateDecrementA
        Opcode.DECREMENT_B -> ::emulateDecrementB
        Opcode.DECREMENT_C -> ::emulateDecrementC
        Opcode.DECREMENT_D -> ::emulateDecrementD
        Opcode.DECREMENT_E -> ::emulateDecrementE
        Opcode.DECREMENT_H -> ::emulateDecrementH
        Opcode.DECREMENT_L -> ::emulateDecrementL
        Opcode.DECREMENT_MEMORY -> ::emulateDecrementMemory
        Opcode.DECREMENT_PAIR_B -> ::emulateDecrementPairB
        Opcode.DECREMENT_PAIR_D -> ::emulateDecrementPairD
        Opcode.DECREMENT_PAIR_H -> ::emulateDecrementPairH
        Opcode.DECREMENT_PAIR_STACK_POINTER -> ::emulateDecrementPairStackPointer
        Opcode.DOUBLE_ADD_B -> emulateDoubleAdd(State::registerB, State::registerC)
        Opcode.DOUBLE_ADD_D -> emulateDoubleAdd(State::registerD, State::registerE)
        Opcode.DOUBLE_ADD_H -> emulateDoubleAdd(State::registerH, State::registerL)
        Opcode.DOUBLE_ADD_STACK_POINTER ->
            emulateDoubleAdd(State::stackPointerHigh, State::stackPointerLow)
        Opcode.EXCHANGE_REGISTERS -> ::emulateExchangeRegisters
        Opcode.EXCHANGE_STACK -> ::emulateExchangeStack
        Opcode.INCREMENT_A -> ::emulateIncrementA
        Opcode.INCREMENT_B -> ::emulateIncrementB
        Opcode.INCREMENT_C -> ::emulateIncrementC
        Opcode.INCREMENT_D -> ::emulateIncrementD
        Opcode.INCREMENT_E -> ::emulateIncrementE
        Opcode.INCREMENT_H -> ::emulateIncrementH
        Opcode.INCREMENT_L -> ::emulateIncrementL
        Opcode.INCREMENT_MEMORY -> ::emulateIncrementMemory
        Opcode.INCREMENT_PAIR_B -> ::emulateIncrementPairB
        Opcode.INCREMENT_PAIR_D -> ::emulateIncrementPairD
        Opcode.INCREMENT_PAIR_H -> ::emulateIncrementPairH
        Opcode.INCREMENT_PAIR_STACK_POINTER -> ::emulateIncrementPairStackPointer
        Opcode.JUMP -> emulateJumpIf { true }
        Opcode.JUMP_IF_CARRY -> emulateJumpIf(State::flagCarry)
        Opcode.JUMP_IF_MINUS -> emulateJumpIf(State::flagSignMinus)
        Opcode.JUMP_IF_NO_CARRY -> emulateJumpIf(State::flagNoCarry)
        Opcode.JUMP_IF_NOT_ZERO -> emulateJumpIf(State::flagNotZero)
        Opcode.JUMP_IF_PARITY_EVEN -> emulateJumpIf(State::flagParityEven)
        Opcode.JUMP_IF_PARITY_ODD -> emulateJumpIf(State::flagParityOdd)
        Opcode.JUMP_IF_PLUS -> emulateJumpIf(State::flagSignPlus)
        Opcode.JUMP_IF_ZERO -> emulateJumpIf(State::flagZero)
        Opcode.LOAD_ACCUMULATOR_B ->
            emulateLoadAccumulatorRegisters(State::registerB, State::registerC)
        Opcode.LOAD_ACCUMULATOR_D ->
            emulateLoadAccumulatorRegisters(State::registerD, State::registerE)
        Opcode.LOAD_ACCUMULATOR_DIRECT -> ::emulateLoadAccumulatorDirect
        Opcode.LOAD_HL_DIRECT -> ::emulateLoadHLDirect
        Opcode.LOAD_PAIR_IMMEDIATE_B -> ::emulateLoadPairImmediateB
        Opcode.LOAD_PAIR_IMMEDIATE_D -> ::emulateLoadPairImmediateD
        Opcode.LOAD_PAIR_IMMEDIATE_H -> ::emulateLoadPairImmediateH
        Opcode.LOAD_PAIR_IMMEDIATE_STACK_POINTER -> ::emulateLoadPairImmediateStackPointer
        Opcode.LOAD_PROGRAM_COUNTER -> ::emulateLoadProgramCounter
        Opcode.LOAD_STACK_POINTER -> ::emulateLoadStackPointer
        Opcode.MOVE_A_A -> emulateMoveA(State::registerA)
        Opcode.MOVE_A_B -> emulateMoveA(State::registerB)
        Opcode.MOVE_A_C -> emulateMoveA(State::registerC)
        Opcode.MOVE_A_D -> emulateMoveA(State::registerD)
        Opcode.MOVE_A_E -> emulateMoveA(State::registerE)
        Opcode.MOVE_A_H -> emulateMoveA(State::registerH)
        Opcode.MOVE_A_L -> emulateMoveA(State::registerL)
        Opcode.MOVE_A_MEMORY -> ::emulateMoveAMemory
        Opcode.MOVE_B_A -> emulateMoveB(State::registerA)
        Opcode.MOVE_B_B -> emulateMoveB(State::registerB)
        Opcode.MOVE_B_C -> emulateMoveB(State::registerC)
        Opcode.MOVE_B_D -> emulateMoveB(State::registerD)
        Opcode.MOVE_B_E -> emulateMoveB(State::registerE)
        Opcode.MOVE_B_H -> emulateMoveB(State::registerH)
        Opcode.MOVE_B_L -> emulateMoveB(State::registerL)
        Opcode.MOVE_B_MEMORY -> ::emulateMoveBMemory
        Opcode.MOVE_C_A -> emulateMoveC(State::registerA)
        Opcode.MOVE_C_B -> emulateMoveC(State::registerB)
        Opcode.MOVE_C_C -> emulateMoveC(State::registerC)
        Opcode.MOVE_C_D -> emulateMoveC(State::registerD)
        Opcode.MOVE_C_E -> emulateMoveC(State::registerE)
        Opcode.MOVE_C_H -> emulateMoveC(State::registerH)
        Opcode.MOVE_C_L -> emulateMoveC(State::registerL)
        Opcode.MOVE_D_A -> emulateMoveD(State::registerA)
        Opcode.MOVE_D_B -> emulateMoveD(State::registerB)
        Opcode.MOVE_D_C -> emulateMoveD(State::registerC)
        Opcode.MOVE_D_D -> emulateMoveD(State::registerD)
        Opcode.MOVE_D_E -> emulateMoveD(State::registerE)
        Opcode.MOVE_D_H -> emulateMoveD(State::registerH)
        Opcode.MOVE_D_L -> emulateMoveD(State::registerL)
        Opcode.MOVE_D_MEMORY -> ::emulateMoveDMemory
        Opcode.MOVE_E_A -> emulateMoveE(State::registerA)
        Opcode.MOVE_E_B -> emulateMoveE(State::registerB)
        Opcode.MOVE_E_C -> emulateMoveE(State::registerC)
        Opcode.MOVE_E_D -> emulateMoveE(State::registerD)
        Opcode.MOVE_E_E -> emulateMoveE(State::registerE)
        Opcode.MOVE_E_H -> emulateMoveE(State::registerH)
        Opcode.MOVE_E_L -> emulateMoveE(State::registerL)
        Opcode.MOVE_E_MEMORY -> ::emulateMoveEMemory
        Opcode.MOVE_H_A -> emulateMoveH(State::registerA)
        Opcode.MOVE_H_B -> emulateMoveH(State::registerB)
        Opcode.MOVE_H_C -> emulateMoveH(State::registerC)
        Opcode.MOVE_H_D -> emulateMoveH(State::registerD)
        Opcode.MOVE_H_E -> emulateMoveH(State::registerE)
        Opcode.MOVE_H_H -> emulateMoveH(State::registerH)
        Opcode.MOVE_H_L -> emulateMoveH(State::registerL)
        Opcode.MOVE_H_MEMORY -> ::emulateMoveHMemory
        Opcode.MOVE_IMMEDIATE_A -> ::emulateMoveImmediateA
        Opcode.MOVE_IMMEDIATE_B -> ::emulateMoveImmediateB
        Opcode.MOVE_IMMEDIATE_C -> ::emulateMoveImmediateC
        Opcode.MOVE_IMMEDIATE_D -> ::emulateMoveImmediateD
        Opcode.MOVE_IMMEDIATE_E -> ::emulateMoveImmediateE
        Opcode.MOVE_IMMEDIATE_H -> ::emulateMoveImmediateH
        Opcode.MOVE_IMMEDIATE_L -> ::emulateMoveImmediateL
        Opcode.MOVE_IMMEDIATE_MEMORY -> ::emulateMoveImmediateMemory
        Opcode.MOVE_L_A -> emulateMoveL(State::registerA)
        Opcode.MOVE_L_B -> emulateMoveL(State::registerB)
        Opcode.MOVE_L_C -> emulateMoveL(State::registerC)
        Opcode.MOVE_L_D -> emulateMoveL(State::registerD)
        Opcode.MOVE_L_E -> emulateMoveL(State::registerE)
        Opcode.MOVE_L_H -> emulateMoveL(State::registerH)
        Opcode.MOVE_L_L -> emulateMoveL(State::registerL)
        Opcode.MOVE_L_MEMORY -> ::emulateMoveLMemory
        Opcode.MOVE_MEMORY_A -> emulateMoveMemoryRegister(State::registerA)
        Opcode.MOVE_MEMORY_B -> emulateMoveMemoryRegister(State::registerB)
        Opcode.MOVE_MEMORY_C -> emulateMoveMemoryRegister(State::registerC)
        Opcode.MOVE_MEMORY_D -> emulateMoveMemoryRegister(State::registerD)
        Opcode.MOVE_MEMORY_E -> emulateMoveMemoryRegister(State::registerE)
        Opcode.MOVE_MEMORY_H -> emulateMoveMemoryRegister(State::registerH)
        Opcode.MOVE_MEMORY_L -> emulateMoveMemoryRegister(State::registerL)
        Opcode.NOOP -> ::emulateNoop
        Opcode.OR_A -> emulateOrRegister(State::registerA)
        Opcode.OR_B -> emulateOrRegister(State::registerB)
        Opcode.OR_C -> emulateOrRegister(State::registerC)
        Opcode.OR_D -> emulateOrRegister(State::registerD)
        Opcode.OR_E -> emulateOrRegister(State::registerE)
        Opcode.OR_H -> emulateOrRegister(State::registerH)
        Opcode.OR_IMMEDIATE -> ::emulateOrImmediate
        Opcode.OR_L -> emulateOrRegister(State::registerL)
        Opcode.OR_MEMORY -> ::emulateOrMemory
        Opcode.POP_B -> ::emulatePopB
        Opcode.POP_D -> ::emulatePopD
        Opcode.POP_H -> ::emulatePopH
        Opcode.POP_STATUS -> ::emulatePopStatus
        Opcode.PUSH_B -> emulatePush(State::registerB, State::registerC)
        Opcode.PUSH_D -> emulatePush(State::registerD, State::registerE)
        Opcode.PUSH_H -> emulatePush(State::registerH, State::registerL)
        Opcode.PUSH_STATUS -> emulatePush(State::registerA, State::flags)
        Opcode.RETURN -> emulateReturnIf({ true }, 10)
        Opcode.RETURN_IF_CARRY -> emulateReturnIf(State::flagCarry)
        Opcode.RETURN_IF_MINUS -> emulateReturnIf(State::flagSignMinus)
        Opcode.RETURN_IF_NO_CARRY -> emulateReturnIf(State::flagNoCarry)
        Opcode.RETURN_IF_NOT_ZERO -> emulateReturnIf(State::flagNotZero)
        Opcode.RETURN_IF_PARITY_EVEN -> emulateReturnIf(State::flagParityEven)
        Opcode.RETURN_IF_PARITY_ODD -> emulateReturnIf(State::flagParityOdd)
        Opcode.RETURN_IF_PLUS -> emulateReturnIf(State::flagSignPlus)
        Opcode.RETURN_IF_ZERO -> emulateReturnIf(State::flagZero)
        Opcode.ROTATE_LEFT -> ::emulateRotateLeft
        Opcode.ROTATE_LEFT_THROUGH_CARRY -> ::emulateRotateLeftThroughCarry
        Opcode.ROTATE_RIGHT -> ::emulateRotateRight
        Opcode.ROTATE_RIGHT_THROUGH_CARRY -> ::emulateRotateRightThroughCarry
        Opcode.SET_CARRY -> ::emulateSetCarry
        Opcode.STORE_ACCUMULATOR_B ->
            emulateStoreAccumulatorRegisters(State::registerB, State::registerC)
        Opcode.STORE_ACCUMULATOR_D ->
            emulateStoreAccumulatorRegisters(State::registerD, State::registerE)
        Opcode.STORE_ACCUMULATOR_DIRECT -> ::emulateStoreAccumulatorDirect
        Opcode.STORE_HL_DIRECT -> ::emulateStoreHLDirect
        Opcode.SUBTRACT_A -> emulateSubtractRegister(State::registerA, false)
        Opcode.SUBTRACT_A_WITH_BORROW -> emulateSubtractRegister(State::registerA, true)
        Opcode.SUBTRACT_B -> emulateSubtractRegister(State::registerB, false)
        Opcode.SUBTRACT_B_WITH_BORROW -> emulateSubtractRegister(State::registerB, true)
        Opcode.SUBTRACT_C -> emulateSubtractRegister(State::registerC, false)
        Opcode.SUBTRACT_C_WITH_BORROW -> emulateSubtractRegister(State::registerC, true)
        Opcode.SUBTRACT_D -> emulateSubtractRegister(State::registerD, false)
        Opcode.SUBTRACT_D_WITH_BORROW -> emulateSubtractRegister(State::registerD, true)
        Opcode.SUBTRACT_E -> emulateSubtractRegister(State::registerE, false)
        Opcode.SUBTRACT_E_WITH_BORROW -> emulateSubtractRegister(State::registerE, true)
        Opcode.SUBTRACT_H -> emulateSubtractRegister(State::registerH, false)
        Opcode.SUBTRACT_H_WITH_BORROW -> emulateSubtractRegister(State::registerH, true)
        Opcode.SUBTRACT_IMMEDIATE -> emulateSubtractImmediate(false)
        Opcode.SUBTRACT_IMMEDIATE_WITH_BORROW -> emulateSubtractImmediate(true)
        Opcode.SUBTRACT_L -> emulateSubtractRegister(State::registerL, false)
        Opcode.SUBTRACT_L_WITH_BORROW -> emulateSubtractRegister(State::registerL, true)
        Opcode.SUBTRACT_MEMORY -> emulateSubtractMemory(false)
        Opcode.SUBTRACT_MEMORY_WITH_BORROW -> emulateSubtractMemory(true)
        Opcode.XOR_A -> emulateXorRegister(State::registerA)
        Opcode.XOR_B -> emulateXorRegister(State::registerB)
        Opcode.XOR_C -> emulateXorRegister(State::registerC)
        Opcode.XOR_D -> emulateXorRegister(State::registerD)
        Opcode.XOR_E -> emulateXorRegister(State::registerE)
        Opcode.XOR_H -> emulateXorRegister(State::registerH)
        Opcode.XOR_IMMEDIATE -> ::emulateXorImmediate
        Opcode.XOR_L -> emulateXorRegister(State::registerL)
        Opcode.XOR_MEMORY -> ::emulateXorMemory
    }

    return emulator(state)
}

fun emulateAddImmediate(withCarry: Boolean) = { state: State ->
    val left = state.registerA
    val right = state.dataByte

    val result = left + right + (if (withCarry && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 7
}

fun emulateAddMemory(withCarry: Boolean) = { state: State ->
    val address = word(state.registerH, state.registerL)
    val left = state.registerA
    val right = state.memory[address]

    val result = left + right + (if (withCarry && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 7
}

fun emulateAddRegister(register: Register, withCarry: Boolean) = { state: State ->
    val left = state.registerA
    val right = register(state)

    val result = left + right + (if (withCarry && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 4
}

fun emulateAndImmediate(state: State) = (state.registerA and state.dataByte).let { result ->
    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateAndMemory(state: State) = word(state.registerH, state.registerL).let { address ->
    val result = state.registerA and state.memory[address]

    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateAndRegister(register: Register) = { state: State ->
    val result = state.registerA and register(state)

    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulateCallIf(predicate: (State) -> Boolean) = { state: State ->
    if (predicate(state)) {
        val (returnHigh, returnLow) = bytes(state.nextProgramCounter)

        state.copy(
            memory = state.memory.with(
                state.stackPointer sub 1 to returnHigh,
                state.stackPointer sub 2 to returnLow
            ),
            programCounter = state.dataWord,
            stackPointer = state.stackPointer sub 2
        ) to 17
    } else {
        state.withNextProgramCounter() to 11
    }
}

fun emulateCompareImmediate(state: State): EmulationResult {
    val left = state.registerA
    val right = state.dataByte

    val result = left - right
    val resultByte = result.toUByte()

    return state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter
    ) to 7
}

fun emulateCompareMemory(state: State): EmulationResult {
    val address = word(state.registerH, state.registerL)
    val left = state.registerA
    val right = state.memory[address]

    val result = left - right
    val resultByte = result.toUByte()

    return state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter
    ) to 7
}

fun emulateCompareRegister(register: Register) = { state: State ->
    val left = state.registerA
    val right = register(state)

    val result = left - right
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter
    ) to 4
}

fun emulateComplementAccumulator(state: State) =
    state.copy(
        registerA = state.registerA.inv(),
        programCounter = state.nextProgramCounter
    ) to 4

fun emulateComplementCarry(state: State) =
    state.copy(
        flagCarry = !state.flagCarry,
        programCounter = state.nextProgramCounter
    ) to 4

fun emulateDecimalAdjust(state: State): EmulationResult {
    var result = state.registerA.toInt()

    val auxiliaryCarry = if (state.flagAuxiliaryCarry || result and 0x0f > 0x09) {
        result += 0x06
        true
    } else {
        false
    }
    val carry = if (state.flagCarry || result and 0xf0 > 0x90) {
        result += 0x60
        true
    } else {
        false
    }

    val resultByte = result.toUByte()

    return state.copy(
        flagAuxiliaryCarry = auxiliaryCarry,
        flagCarry = carry,
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 4
}

fun emulateDecrementA(state: State) =
    (state.registerA sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerA, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerA = result
        ) to 5
    }

fun emulateDecrementB(state: State) =
    (state.registerB sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerB, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerB = result
        ) to 5
    }

fun emulateDecrementC(state: State) =
    (state.registerC sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerC, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerC = result
        ) to 5
    }

fun emulateDecrementD(state: State) =
    (state.registerD sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerD, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerD = result
        ) to 5
    }

fun emulateDecrementE(state: State) =
    (state.registerE sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerE, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerE = result
        ) to 5
    }

fun emulateDecrementH(state: State) =
    (state.registerH sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerH, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerH = result
        ) to 5
    }

fun emulateDecrementL(state: State) =
    (state.registerL sub 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerL, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerL = result
        ) to 5
    }

fun emulateDecrementMemory(state: State) =
    word(state.registerH, state.registerL).let { address ->
        val initial = state.memory[address]
        val result = initial sub 1

        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(initial, (-1).toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            memory = state.memory.with(
                address to result
            ),
            programCounter = state.nextProgramCounter
        ) to 10
    }

fun emulateDecrementPairB(state: State) =
    word(state.registerB, state.registerC).let { initial ->
        val (high, low) = bytes(initial sub 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerB = high,
            registerC = low
        ) to 5
    }

fun emulateDecrementPairD(state: State) =
    word(state.registerD, state.registerE).let { initial ->
        val (high, low) = bytes(initial sub 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerD = high,
            registerE = low
        ) to 5
    }

fun emulateDecrementPairH(state: State) =
    word(state.registerH, state.registerL).let { initial ->
        val (high, low) = bytes(initial sub 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerH = high,
            registerL = low
        ) to 5
    }

fun emulateDecrementPairStackPointer(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        stackPointer = state.stackPointer sub 1
    ) to 5

fun emulateDoubleAdd(highRegister: Register, lowRegister: Register) = { state: State ->
    val result =
        word(state.registerH, state.registerL) + word(highRegister(state), lowRegister(state))
    val (resultHigh, resultLow) = bytes(result.toUShort())

    state.copy(
        flagCarry = result[UShort.SIZE_BITS],
        programCounter = state.nextProgramCounter,
        registerH = resultHigh,
        registerL = resultLow
    ) to 10
}

fun emulateExchangeRegisters(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerD = state.registerH,
        registerE = state.registerL,
        registerH = state.registerD,
        registerL = state.registerE
    ) to 5

fun emulateExchangeStack(state: State) =
    state.copy(
        memory = state.memory.with(
            state.stackPointer add 1 to state.registerH,
            state.stackPointer to state.registerL
        ),
        programCounter = state.nextProgramCounter,
        registerH = state.memory[state.stackPointer add 1],
        registerL = state.memory[state.stackPointer],
    ) to 18

fun emulateIncrementA(state: State) =
    (state.registerA add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerA, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerA = result
        ) to 5
    }

fun emulateIncrementB(state: State) =
    (state.registerB add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerB, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerB = result
        ) to 5
    }

fun emulateIncrementC(state: State) =
    (state.registerC add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerC, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerC = result
        ) to 5
    }

fun emulateIncrementD(state: State) =
    (state.registerD add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerD, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerD = result
        ) to 5
    }

fun emulateIncrementE(state: State) =
    (state.registerE add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerE, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerE = result
        ) to 5
    }

fun emulateIncrementH(state: State) =
    (state.registerH add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerH, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerH = result
        ) to 5
    }

fun emulateIncrementL(state: State) =
    (state.registerL add 1).let { result ->
        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerL, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            programCounter = state.nextProgramCounter,
            registerL = result
        ) to 5
    }

fun emulateIncrementMemory(state: State) =
    word(state.registerH, state.registerL).let { address ->
        val initial = state.memory[address]
        val result = initial add 1

        state.copy(
            flagAuxiliaryCarry = flagAuxiliaryCarry(initial, 1.toUByte(), result),
            flagParity = flagParity(result),
            flagSign = flagSign(result),
            flagZero = flagZero(result),
            memory = state.memory.with(
                address to result
            ),
            programCounter = state.nextProgramCounter
        ) to 10
    }

fun emulateIncrementPairB(state: State) =
    word(state.registerB, state.registerC).let { initial ->
        val (high, low) = bytes(initial add 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerB = high,
            registerC = low
        ) to 5
    }

fun emulateIncrementPairD(state: State) =
    word(state.registerD, state.registerE).let { initial ->
        val (high, low) = bytes(initial add 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerD = high,
            registerE = low
        ) to 5
    }

fun emulateIncrementPairH(state: State) =
    word(state.registerH, state.registerL).let { initial ->
        val (high, low) = bytes(initial add 1)

        state.copy(
            programCounter = state.nextProgramCounter,
            registerH = high,
            registerL = low
        ) to 5
    }

fun emulateIncrementPairStackPointer(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        stackPointer = state.stackPointer add 1
    ) to 5

fun emulateJumpIf(predicate: (State) -> Boolean) = { state: State ->
    if (predicate(state)) {
        state.copy(programCounter = state.dataWord) to 10
    } else {
        state.withNextProgramCounter() to 10
    }
}

fun emulateLoadAccumulatorDirect(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerA = state.memory[state.dataWord]
    ) to 13

fun emulateLoadAccumulatorRegisters(highRegister: Register, lowRegister: Register) =
    { state: State ->
        val address = word(highRegister(state), lowRegister(state))

        state.copy(
            programCounter = state.nextProgramCounter,
            registerA = state.memory[address]
        ) to 7
    }

fun emulateLoadHLDirect(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerH = state.memory[state.dataWord add 1],
        registerL = state.memory[state.dataWord]
    ) to 16

fun emulateLoadPairImmediateB(state: State) =
    state.dataBytes.let { (high, low) ->
        state.copy(
            programCounter = state.nextProgramCounter,
            registerB = high,
            registerC = low
        ) to 10
    }

fun emulateLoadPairImmediateD(state: State) =
    state.dataBytes.let { (high, low) ->
        state.copy(
            programCounter = state.nextProgramCounter,
            registerD = high,
            registerE = low
        ) to 10
    }

fun emulateLoadPairImmediateH(state: State) =
    state.dataBytes.let { (high, low) ->
        state.copy(
            programCounter = state.nextProgramCounter,
            registerH = high,
            registerL = low
        ) to 10
    }

fun emulateLoadPairImmediateStackPointer(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        stackPointer = state.dataWord
    ) to 10

fun emulateLoadProgramCounter(state: State) =
    state.copy(
        programCounter = word(state.registerH, state.registerL)
    ) to 5

fun emulateLoadStackPointer(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        stackPointer = word(state.registerH, state.registerL)
    ) to 5

fun emulateMoveA(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerA = register(state)
    ) to 5
}

fun emulateMoveAMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerA = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveB(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerB = register(state)
    ) to 5
}

fun emulateMoveBMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerB = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveC(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerC = register(state)
    ) to 5
}

fun emulateMoveD(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerD = register(state)
    ) to 5
}

fun emulateMoveDMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerD = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveE(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerE = register(state)
    ) to 5
}

fun emulateMoveEMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerE = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveH(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerH = register(state)
    ) to 5
}

fun emulateMoveHMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerH = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveImmediateA(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerA = state.dataByte
    ) to 5

fun emulateMoveImmediateB(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerB = state.dataByte
    ) to 5

fun emulateMoveImmediateC(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerC = state.dataByte
    ) to 5

fun emulateMoveImmediateD(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerD = state.dataByte
    ) to 5

fun emulateMoveImmediateE(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerE = state.dataByte
    ) to 5

fun emulateMoveImmediateH(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerH = state.dataByte
    ) to 5

fun emulateMoveImmediateL(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerL = state.dataByte
    ) to 5

fun emulateMoveImmediateMemory(state: State) =
    word(state.registerH, state.registerL).let { address ->
        state.copy(
            memory = state.memory.with(
                address to state.dataByte
            ),
            programCounter = state.nextProgramCounter
        ) to 10
    }

fun emulateMoveL(register: Register) = { state: State ->
    state.copy(
        programCounter = state.nextProgramCounter,
        registerL = register(state)
    ) to 5
}

fun emulateMoveLMemory(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerL = state.memory[word(state.registerH, state.registerL)]
    ) to 7

fun emulateMoveMemoryRegister(register: Register) = { state: State ->
    val address = word(state.registerH, state.registerL)

    state.copy(
        memory = state.memory.with(
            address to register(state)
        ),
        programCounter = state.nextProgramCounter
    ) to 7
}

fun emulateNoop(state: State) = state.withNextProgramCounter() to 4

fun emulateOrImmediate(state: State) = (state.registerA or state.dataByte).let { result ->
    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateOrMemory(state: State) = word(state.registerH, state.registerL).let { address ->
    val result = state.registerA or state.memory[address]

    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateOrRegister(register: Register) = { state: State ->
    val result = state.registerA or register(state)

    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulatePopB(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerB = state.memory[state.stackPointer add 1],
        registerC = state.memory[state.stackPointer],
        stackPointer = state.stackPointer add 2
    ) to 10

fun emulatePopD(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerD = state.memory[state.stackPointer add 1],
        registerE = state.memory[state.stackPointer],
        stackPointer = state.stackPointer add 2
    ) to 10

fun emulatePopH(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        registerH = state.memory[state.stackPointer add 1],
        registerL = state.memory[state.stackPointer],
        stackPointer = state.stackPointer add 2
    ) to 10

fun emulatePopStatus(state: State) =
    state.memory[state.stackPointer].let { flags ->
        state.copy(
            flagAuxiliaryCarry = flags[State.FLAG_BIT_AUXILIARY_CARRY],
            flagCarry = flags[State.FLAG_BIT_CARRY],
            flagParity = flags[State.FLAG_BIT_PARITY],
            flagSign = flags[State.FLAG_BIT_SIGN],
            flagZero = flags[State.FLAG_BIT_ZERO],
            programCounter = state.nextProgramCounter,
            registerA = state.memory[state.stackPointer add 1],
            stackPointer = state.stackPointer add 2
        ) to 10
    }

fun emulatePush(highRegister: Register, lowRegister: Register) = { state: State ->
    state.copy(
        memory = state.memory.with(
            state.stackPointer sub 1 to highRegister(state),
            state.stackPointer sub 2 to lowRegister(state)
        ),
        programCounter = state.nextProgramCounter,
        stackPointer = state.stackPointer sub 2
    ) to 11
}

fun emulateReturnIf(predicate: (State) -> Boolean, cycles: Int = 11) = { state: State ->
    if (predicate(state)) {
        state.copy(
            programCounter = state.stackWord,
            stackPointer = state.stackPointer add 2
        ) to cycles
    } else {
        state.withNextProgramCounter() to 5
    }
}

fun emulateRotateLeft(state: State): EmulationResult {
    val carry = state.registerA[UByte.SIZE_BITS - 1]
    val result = (state.registerA shl 1).set(0, carry)

    return state.copy(
        flagCarry = carry,
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulateRotateLeftThroughCarry(state: State): EmulationResult {
    val carry = state.registerA[UByte.SIZE_BITS - 1]
    val result = (state.registerA shl 1).set(0, state.flagCarry)

    return state.copy(
        flagCarry = carry,
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulateRotateRight(state: State): EmulationResult {
    val carry = state.registerA[0]
    val result = (state.registerA shr 1).set(UByte.SIZE_BITS - 1, carry)

    return state.copy(
        flagCarry = carry,
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulateRotateRightThroughCarry(state: State): EmulationResult {
    val carry = state.registerA[0]
    val result = (state.registerA shr 1).set(UByte.SIZE_BITS - 1, state.flagCarry)

    return state.copy(
        flagCarry = carry,
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}

fun emulateSetCarry(state: State) =
    state.copy(
        flagCarry = true,
        programCounter = state.nextProgramCounter
    ) to 4

fun emulateStoreAccumulatorDirect(state: State) =
    state.copy(
        memory = state.memory.with(
            state.dataWord to state.registerA
        ),
        programCounter = state.nextProgramCounter
    ) to 13

fun emulateStoreAccumulatorRegisters(highRegister: Register, lowRegister: Register) =
    { state: State ->
        val address = word(highRegister(state), lowRegister(state))

        state.copy(
            memory = state.memory.with(
                address to state.registerA
            ),
            programCounter = state.nextProgramCounter
        ) to 7
    }

fun emulateStoreHLDirect(state: State) =
    state.copy(
        memory = state.memory.with(
            state.dataWord add 1 to state.registerH,
            state.dataWord to state.registerL
        ),
        programCounter = state.nextProgramCounter
    ) to 16

fun emulateSubtractImmediate(withBorrow: Boolean) = { state: State ->
    val left = state.registerA
    val right = state.dataByte

    val result = left - right - (if (withBorrow && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 7
}

fun emulateSubtractMemory(withBorrow: Boolean) = { state: State ->
    val address = word(state.registerH, state.registerL)
    val left = state.registerA
    val right = state.memory[address]

    val result = left - right - (if (withBorrow && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 7
}

fun emulateSubtractRegister(register: Register, withBorrow: Boolean) = { state: State ->
    val left = state.registerA
    val right = register(state)

    val result = left - right - (if (withBorrow && state.flagCarry) 1 else 0).toUInt()
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(left, right, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter,
        registerA = resultByte
    ) to 7
}

fun emulateXorImmediate(state: State) = (state.registerA xor state.dataByte).let { result ->
    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateXorMemory(state: State) = word(state.registerH, state.registerL).let { address ->
    val result = state.registerA xor state.memory[address]

    state.copy(
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 7
}

fun emulateXorRegister(register: Register) = { state: State ->
    val result = state.registerA xor register(state)

    state.copy(
        flagAuxiliaryCarry = false,
        flagCarry = false,
        flagParity = flagParity(result),
        flagSign = flagSign(result),
        flagZero = flagZero(result),
        programCounter = state.nextProgramCounter,
        registerA = result
    ) to 4
}
