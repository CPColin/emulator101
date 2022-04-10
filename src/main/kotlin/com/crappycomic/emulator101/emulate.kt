package com.crappycomic.emulator101

/**
 * Emulates the instruction pointed to by the given [state] and returns the new [State] along with
 * the number of cycles it took to execute the instruction.
 */
fun emulate(state: State): Pair<State, Int> {
    val emulator: (State) -> Pair<State, Int> = when (state.opcode) {
        Opcode.ADD_IMMEDIATE -> ::emulateAddImmediate
        Opcode.AND_IMMEDIATE -> ::emulateAndImmediate
        Opcode.JUMP -> emulateJumpIf { true }
        Opcode.JUMP_IF_CARRY -> emulateJumpIf(State::flagCarry)
        Opcode.JUMP_IF_MINUS -> emulateJumpIf(State::flagSignMinus)
        Opcode.JUMP_IF_NO_CARRY -> emulateJumpIf(State::flagNoCarry)
        Opcode.JUMP_IF_NOT_ZERO -> emulateJumpIf(State::flagNotZero)
        Opcode.JUMP_IF_PARITY_EVEN -> emulateJumpIf(State::flagParityEven)
        Opcode.JUMP_IF_PARITY_ODD -> emulateJumpIf(State::flagParityOdd)
        Opcode.JUMP_IF_PLUS -> emulateJumpIf(State::flagSignPlus)
        Opcode.JUMP_IF_ZERO -> emulateJumpIf(State::flagZero)
        Opcode.LOAD_PAIR_IMMEDIATE_STACK_POINTER -> ::emulateLoadPairImmediateStackPointer
        Opcode.NOOP -> ::emulateNoop
        Opcode.RETURN -> emulateReturnIf { true }
    }

    return emulator(state)
}

fun emulateAddImmediate(state: State) = (state.registerA + state.dataByte).let { result ->
    val resultByte = result.toUByte()

    state.copy(
        flagAuxiliaryCarry = flagAuxiliaryCarry(state.registerA, state.dataByte, resultByte),
        flagCarry = flagCarry(result),
        flagParity = flagParity(resultByte),
        flagSign = flagSign(resultByte),
        flagZero = flagZero(resultByte),
        programCounter = state.nextProgramCounter
    ) to 7
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

fun emulateJumpIf(predicate: (State) -> Boolean) = { state: State ->
    if (predicate(state)) {
        state.copy(programCounter = state.dataWord) to 10
    } else {
        state.withNextProgramCounter() to 10
    }
}

fun emulateLoadPairImmediateStackPointer(state: State) =
    state.copy(
        programCounter = state.nextProgramCounter,
        stackPointer = state.dataWord
    ) to 10

fun emulateNoop(state: State) = state.withNextProgramCounter() to 4

fun emulateReturnIf(cycles: Int = 11, predicate: (State) -> Boolean) = { state: State ->
    if (predicate(state)) {
        state.copy(
            programCounter = state.stackWord,
            stackPointer = state.stackPointer add 2
        ) to cycles
    } else {
        state.withNextProgramCounter() to 5
    }
}