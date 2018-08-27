"Emulates execution of the next instruction, given the current [[state]] of the CPU and memory.
 Returns the new state and the number of cycles the instruction took."
shared [State, Integer] emulate(State state, Machine? machine = null) {
    value opcode = state.opcode;
    
    // TODO: Idea: In places where we only read from a register, we could use Byte(State),
    // instead of ByteRegister, and maybe be a littler cleaner/faster.
    
    // TODO: Break up into smaller files, so my laptop doesn't melt.
    
    value emulator = switch (opcode)
        case (addA) emulateAddRegister(stateRegisterA, false)
        case (addB) emulateAddRegister(stateRegisterB, false)
        case (addC) emulateAddRegister(stateRegisterC, false)
        case (addD) emulateAddRegister(stateRegisterD, false)
        case (addE) emulateAddRegister(stateRegisterE, false)
        case (addH) emulateAddRegister(stateRegisterH, false)
        case (addL) emulateAddRegister(stateRegisterL, false)
        case (addMemory) emulateAddMemory(false)
        case (addImmediate) emulateAddImmediate(false)
        case (addAWithCarry) emulateAddRegister(stateRegisterA, true)
        case (addBWithCarry) emulateAddRegister(stateRegisterB, true)
        case (addCWithCarry) emulateAddRegister(stateRegisterC, true)
        case (addDWithCarry) emulateAddRegister(stateRegisterD, true)
        case (addEWithCarry) emulateAddRegister(stateRegisterE, true)
        case (addHWithCarry) emulateAddRegister(stateRegisterH, true)
        case (addLWithCarry) emulateAddRegister(stateRegisterL, true)
        case (addMemoryWithCarry) emulateAddMemory(true)
        case (addImmediateWithCarry) emulateAddImmediate(true)
        case (andA) emulateAndRegister(stateRegisterA)
        case (andB) emulateAndRegister(stateRegisterB)
        case (andC) emulateAndRegister(stateRegisterC)
        case (andD) emulateAndRegister(stateRegisterD)
        case (andE) emulateAndRegister(stateRegisterE)
        case (andH) emulateAndRegister(stateRegisterH)
        case (andL) emulateAndRegister(stateRegisterL)
        case (andImmediate) emulateAndImmediate
        case (andMemory) emulateAndMemory
        case (call) emulateCallIf((state) => true)
        case (callIfCarry) emulateCallIf(State.carry)
        case (callIfMinus) emulateCallIf(State.sign)
        case (callIfNoCarry) emulateCallIf(not(State.carry))
        case (callIfNotZero) emulateCallIf(not(State.zero))
        case (callIfParityEven) emulateCallIf(State.parity)
        case (callIfParityOdd) emulateCallIf(not(State.parity))
        case (callIfPlus) emulateCallIf(not(State.sign))
        case (callIfZero) emulateCallIf(State.zero)
        case (compareA) emulateCompareRegister(stateRegisterA)
        case (compareB) emulateCompareRegister(stateRegisterB)
        case (compareC) emulateCompareRegister(stateRegisterC)
        case (compareD) emulateCompareRegister(stateRegisterD)
        case (compareE) emulateCompareRegister(stateRegisterE)
        case (compareH) emulateCompareRegister(stateRegisterH)
        case (compareL) emulateCompareRegister(stateRegisterL)
        case (compareMemory) emulateCompareMemory
        case (compareImmediate) emulateCompareImmediate
        case (complementAccumulator) emulateComplementAccumulator
        case (complementCarry) emulateComplementCarry
        case (decimalAdjust) emulateDecimalAdjust
        case (decrementA) emulateDecrementRegister(stateRegisterA)
        case (decrementB) emulateDecrementRegister(stateRegisterB)
        case (decrementC) emulateDecrementRegister(stateRegisterC)
        case (decrementD) emulateDecrementRegister(stateRegisterD)
        case (decrementE) emulateDecrementRegister(stateRegisterE)
        case (decrementH) emulateDecrementRegister(stateRegisterH)
        case (decrementL) emulateDecrementRegister(stateRegisterL)
        case (decrementMemory) emulateDecrementMemory
        case (decrementPairB) emulateDecrementPair(stateRegisterB, stateRegisterC)
        case (decrementPairD) emulateDecrementPair(stateRegisterD, stateRegisterE)
        case (decrementPairH) emulateDecrementPair(stateRegisterH, stateRegisterL)
        case (decrementPairStackPointer)
            emulateDecrementPair(stateStackPointerHigh, stateStackPointerLow)
        case (disableInterrupts) emulateDisableInterrupts
        case (doubleAddB) emulateDoubleAdd(stateRegisterB, stateRegisterC)
        case (doubleAddD) emulateDoubleAdd(stateRegisterD, stateRegisterE)
        case (doubleAddH) emulateDoubleAdd(stateRegisterH, stateRegisterL)
        case (doubleAddStackPointer)
            emulateDoubleAdd(stateStackPointerHigh, stateStackPointerLow)
        case (enableInterrupts) emulateEnableInterrupts
        case (exchangeRegisters) emulateExchangeRegisters
        case (exchangeStack) emulateExchangeStack
        case (halt) emulateHalt
        case (incrementA) emulateIncrementRegister(stateRegisterA)
        case (incrementB) emulateIncrementRegister(stateRegisterB)
        case (incrementC) emulateIncrementRegister(stateRegisterC)
        case (incrementD) emulateIncrementRegister(stateRegisterD)
        case (incrementE) emulateIncrementRegister(stateRegisterE)
        case (incrementH) emulateIncrementRegister(stateRegisterH)
        case (incrementL) emulateIncrementRegister(stateRegisterL)
        case (incrementMemory) emulateIncrementMemory
        case (incrementPairB) emulateIncrementPair(stateRegisterB, stateRegisterC)
        case (incrementPairD) emulateIncrementPair(stateRegisterD, stateRegisterE)
        case (incrementPairH) emulateIncrementPair(stateRegisterH, stateRegisterL)
        case (incrementPairStackPointer)
            emulateIncrementPair(stateStackPointerHigh, stateStackPointerLow)
        case (input) emulateInput
        case (jump) emulateJumpIf((state) => true)
        case (jumpIfCarry) emulateJumpIf(State.carry)
        case (jumpIfMinus) emulateJumpIf(State.sign)
        case (jumpIfNoCarry) emulateJumpIf(not(State.carry))
        case (jumpIfNotZero) emulateJumpIf(not(State.zero))
        case (jumpIfParityEven) emulateJumpIf(State.parity)
        case (jumpIfParityOdd) emulateJumpIf(not(State.parity))
        case (jumpIfPlus) emulateJumpIf(not(State.sign))
        case (jumpIfZero) emulateJumpIf(State.zero)
        case (loadAccumulatorB) emulateLoadAccumulator(stateRegisterB, stateRegisterC)
        case (loadAccumulatorD) emulateLoadAccumulator(stateRegisterD, stateRegisterE)
        case (loadAccumulatorDirect) emulateLoadAccumulatorDirect
        case (loadHLDirect) emulateLoadHLDirect
        case (loadPairImmediateB) emulateLoadPairImmediate(stateRegisterB, stateRegisterC)
        case (loadPairImmediateD) emulateLoadPairImmediate(stateRegisterD, stateRegisterE)
        case (loadPairImmediateH) emulateLoadPairImmediate(stateRegisterH, stateRegisterL)
        case (loadPairImmediateStackPointer)
            emulateLoadPairImmediate(stateStackPointerHigh, stateStackPointerLow)
        case (loadProgramCounter) emulateLoadProgramCounter
        case (loadStackPointer) emulateLoadStackPointer
        case (moveImmediateA) emulateMoveImmediate(stateRegisterA)
        case (moveImmediateB) emulateMoveImmediate(stateRegisterB)
        case (moveImmediateC) emulateMoveImmediate(stateRegisterC)
        case (moveImmediateD) emulateMoveImmediate(stateRegisterD)
        case (moveImmediateE) emulateMoveImmediate(stateRegisterE)
        case (moveImmediateH) emulateMoveImmediate(stateRegisterH)
        case (moveImmediateL) emulateMoveImmediate(stateRegisterL)
        case (moveImmediateMemory) emulateMoveImmediateMemory
        case (moveAA) emulateMoveRegisters(stateRegisterA, stateRegisterA)
        case (moveAB) emulateMoveRegisters(stateRegisterA, stateRegisterB)
        case (moveAC) emulateMoveRegisters(stateRegisterA, stateRegisterC)
        case (moveAD) emulateMoveRegisters(stateRegisterA, stateRegisterD)
        case (moveAE) emulateMoveRegisters(stateRegisterA, stateRegisterE)
        case (moveAH) emulateMoveRegisters(stateRegisterA, stateRegisterH)
        case (moveAL) emulateMoveRegisters(stateRegisterA, stateRegisterL)
        case (moveAMemory) emulateMoveRegisterMemory(stateRegisterA)
        case (moveBA) emulateMoveRegisters(stateRegisterB, stateRegisterA)
        case (moveBB) emulateMoveRegisters(stateRegisterB, stateRegisterB)
        case (moveBC) emulateMoveRegisters(stateRegisterB, stateRegisterC)
        case (moveBD) emulateMoveRegisters(stateRegisterB, stateRegisterD)
        case (moveBE) emulateMoveRegisters(stateRegisterB, stateRegisterE)
        case (moveBH) emulateMoveRegisters(stateRegisterB, stateRegisterH)
        case (moveBL) emulateMoveRegisters(stateRegisterB, stateRegisterL)
        case (moveBMemory) emulateMoveRegisterMemory(stateRegisterB)
        case (moveCA) emulateMoveRegisters(stateRegisterC, stateRegisterA)
        case (moveCB) emulateMoveRegisters(stateRegisterC, stateRegisterB)
        case (moveCC) emulateMoveRegisters(stateRegisterC, stateRegisterC)
        case (moveCD) emulateMoveRegisters(stateRegisterC, stateRegisterD)
        case (moveCE) emulateMoveRegisters(stateRegisterC, stateRegisterE)
        case (moveCH) emulateMoveRegisters(stateRegisterC, stateRegisterH)
        case (moveCL) emulateMoveRegisters(stateRegisterC, stateRegisterL)
        case (moveCMemory) emulateMoveRegisterMemory(stateRegisterC)
        case (moveDA) emulateMoveRegisters(stateRegisterD, stateRegisterA)
        case (moveDB) emulateMoveRegisters(stateRegisterD, stateRegisterB)
        case (moveDC) emulateMoveRegisters(stateRegisterD, stateRegisterC)
        case (moveDD) emulateMoveRegisters(stateRegisterD, stateRegisterD)
        case (moveDE) emulateMoveRegisters(stateRegisterD, stateRegisterE)
        case (moveDH) emulateMoveRegisters(stateRegisterD, stateRegisterH)
        case (moveDL) emulateMoveRegisters(stateRegisterD, stateRegisterL)
        case (moveDMemory) emulateMoveRegisterMemory(stateRegisterD)
        case (moveEA) emulateMoveRegisters(stateRegisterE, stateRegisterA)
        case (moveEB) emulateMoveRegisters(stateRegisterE, stateRegisterB)
        case (moveEC) emulateMoveRegisters(stateRegisterE, stateRegisterC)
        case (moveED) emulateMoveRegisters(stateRegisterE, stateRegisterD)
        case (moveEE) emulateMoveRegisters(stateRegisterE, stateRegisterE)
        case (moveEH) emulateMoveRegisters(stateRegisterE, stateRegisterH)
        case (moveEL) emulateMoveRegisters(stateRegisterE, stateRegisterL)
        case (moveEMemory) emulateMoveRegisterMemory(stateRegisterE)
        case (moveHA) emulateMoveRegisters(stateRegisterH, stateRegisterA)
        case (moveHB) emulateMoveRegisters(stateRegisterH, stateRegisterB)
        case (moveHC) emulateMoveRegisters(stateRegisterH, stateRegisterC)
        case (moveHD) emulateMoveRegisters(stateRegisterH, stateRegisterD)
        case (moveHE) emulateMoveRegisters(stateRegisterH, stateRegisterE)
        case (moveHH) emulateMoveRegisters(stateRegisterH, stateRegisterH)
        case (moveHL) emulateMoveRegisters(stateRegisterH, stateRegisterL)
        case (moveHMemory) emulateMoveRegisterMemory(stateRegisterH)
        case (moveLA) emulateMoveRegisters(stateRegisterL, stateRegisterA)
        case (moveLB) emulateMoveRegisters(stateRegisterL, stateRegisterB)
        case (moveLC) emulateMoveRegisters(stateRegisterL, stateRegisterC)
        case (moveLD) emulateMoveRegisters(stateRegisterL, stateRegisterD)
        case (moveLE) emulateMoveRegisters(stateRegisterL, stateRegisterE)
        case (moveLH) emulateMoveRegisters(stateRegisterL, stateRegisterH)
        case (moveLL) emulateMoveRegisters(stateRegisterL, stateRegisterL)
        case (moveLMemory) emulateMoveRegisterMemory(stateRegisterL)
        case (moveMemoryA) emulateMoveMemoryRegister(stateRegisterA)
        case (moveMemoryB) emulateMoveMemoryRegister(stateRegisterB)
        case (moveMemoryC) emulateMoveMemoryRegister(stateRegisterC)
        case (moveMemoryD) emulateMoveMemoryRegister(stateRegisterD)
        case (moveMemoryE) emulateMoveMemoryRegister(stateRegisterE)
        case (moveMemoryH) emulateMoveMemoryRegister(stateRegisterH)
        case (moveMemoryL) emulateMoveMemoryRegister(stateRegisterL)
        case (noop) emulateNoop
        case (orA) emulateOrRegister(stateRegisterA)
        case (orB) emulateOrRegister(stateRegisterB)
        case (orC) emulateOrRegister(stateRegisterC)
        case (orD) emulateOrRegister(stateRegisterD)
        case (orE) emulateOrRegister(stateRegisterE)
        case (orH) emulateOrRegister(stateRegisterH)
        case (orL) emulateOrRegister(stateRegisterL)
        case (orMemory) emulateOrMemory
        case (orImmediate) emulateOrImmediate
        case (output) emulateOutput
        case (popB) emulatePop(stateRegisterB, stateRegisterC)
        case (popD) emulatePop(stateRegisterD, stateRegisterE)
        case (popH) emulatePop(stateRegisterH, stateRegisterL)
        case (popStatus) emulatePop(stateRegisterA, stateFlags)
        case (pushB) emulatePush(stateRegisterB, stateRegisterC)
        case (pushD) emulatePush(stateRegisterD, stateRegisterE)
        case (pushH) emulatePush(stateRegisterH, stateRegisterL)
        case (pushStatus) emulatePush(stateRegisterA, stateFlags)
        case (restart0) emulateRestart
        case (restart1) emulateRestart
        case (restart2) emulateRestart
        case (restart3) emulateRestart
        case (restart4) emulateRestart
        case (restart5) emulateRestart
        case (restart6) emulateRestart
        case (restart7) emulateRestart
        case (\ireturn) emulateReturnIf((state) => true, 10)
        case (returnIfCarry) emulateReturnIf(State.carry)
        case (returnIfMinus) emulateReturnIf(State.sign)
        case (returnIfNoCarry) emulateReturnIf(not(State.carry))
        case (returnIfNotZero) emulateReturnIf(not(State.zero))
        case (returnIfParityEven) emulateReturnIf(State.parity)
        case (returnIfParityOdd) emulateReturnIf(not(State.parity))
        case (returnIfPlus) emulateReturnIf(not(State.sign))
        case (returnIfZero) emulateReturnIf(State.zero)
        case (rotateLeft) emulateRotateLeft
        case (rotateLeftThroughCarry) emulateRotateLeftThroughCarry
        case (rotateRight) emulateRotateRight
        case (rotateRightThroughCarry) emulateRotateRightThroughCarry
        case (setCarry) emulateSetCarry
        case (storeAccumulatorB) emulateStoreAccumulator(stateRegisterB, stateRegisterC)
        case (storeAccumulatorD) emulateStoreAccumulator(stateRegisterD, stateRegisterE)
        case (storeAccumulatorDirect) emulateStoreAccumulatorDirect
        case (storeHLDirect) emulateStoreHLDirect
        case (subtractA) emulateSubtractRegister(stateRegisterA, false)
        case (subtractB) emulateSubtractRegister(stateRegisterB, false)
        case (subtractC) emulateSubtractRegister(stateRegisterC, false)
        case (subtractD) emulateSubtractRegister(stateRegisterD, false)
        case (subtractE) emulateSubtractRegister(stateRegisterE, false)
        case (subtractH) emulateSubtractRegister(stateRegisterH, false)
        case (subtractL) emulateSubtractRegister(stateRegisterL, false)
        case (subtractMemory) emulateSubtractMemory(false)
        case (subtractImmediate) emulateSubtractImmediate(false)
        case (subtractAWithBorrow) emulateSubtractRegister(stateRegisterA, true)
        case (subtractBWithBorrow) emulateSubtractRegister(stateRegisterB, true)
        case (subtractCWithBorrow) emulateSubtractRegister(stateRegisterC, true)
        case (subtractDWithBorrow) emulateSubtractRegister(stateRegisterD, true)
        case (subtractEWithBorrow) emulateSubtractRegister(stateRegisterE, true)
        case (subtractHWithBorrow) emulateSubtractRegister(stateRegisterH, true)
        case (subtractLWithBorrow) emulateSubtractRegister(stateRegisterL, true)
        case (subtractMemoryWithBorrow) emulateSubtractMemory(true)
        case (subtractImmediateWithBorrow) emulateSubtractImmediate(true)
        case (xorA) emulateXorRegister(stateRegisterA)
        case (xorB) emulateXorRegister(stateRegisterB)
        case (xorC) emulateXorRegister(stateRegisterC)
        case (xorD) emulateXorRegister(stateRegisterD)
        case (xorE) emulateXorRegister(stateRegisterE)
        case (xorH) emulateXorRegister(stateRegisterH)
        case (xorL) emulateXorRegister(stateRegisterL)
        case (xorMemory) emulateXorMemory
        case (xorImmediate) emulateXorImmediate
        ;
    
    if (is Anything(State, Machine?) emulator) {
        return emulator(state, machine);
    } else {
        return emulator(state);
    }
}

"""Returns the appropriate value for the Auxiliary Carry flag, which is set when a carry comes out
   of the least significant nibble.
   
   For example, the following operation carried out of the low nibble and would set the flag:
   
   ```
     0000 1000
   + 0000 1010
   -----------
     0001 0010
   ```
   
   while the following operation did not carry out of the low nibble and would clear the flag:
   
   ```
     0000 0100
   + 0001 1010
   -----------
     0001 1110
   ```
   
   The code at <https://bluishcoder.co.nz/js8080/> inspired this code, where we compare bit #4, that
   is, the least significant bit of the most significant nibble. If the bits matched in the
   operands, the flag will match the bit in the result. Otherwise, the flag will be the opposite.
   """
shared Boolean flagAuxiliaryCarry(Byte left, Byte right, Byte result)
    => let (leftBit = left.get(4), rightBit = right.get(4), resultBit = result.get(4))
        if (leftBit == rightBit) then resultBit else !resultBit;

shared Boolean flagCarry(Integer val) => val.get(8);

shared Boolean flagParity(Byte val) => {
    for (bit in 0:8)
        val.get(bit)
}.count(identity) % 2 == 0;

shared Boolean flagSign(Byte val) => val.get(7);

shared Boolean flagZero(Byte val) => val.zero;

[State, Integer] emulateAddImmediate(Boolean withCarry)
        (State state) {
    value left = state.registerA;
    value right = state.dataByte;
    value result = left.unsigned + right.unsigned + (withCarry && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
    state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateAddMemory(Boolean withCarry)(State state) {
    value left = state.registerA;
    value address = word(state.registerH, state.registerL);
    value right = state.memory[address] else 0.byte;
    value result = left.unsigned + right.unsigned + (withCarry && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateAddRegister(ByteRegister register, Boolean withCarry)(State state) {
    value left = state.registerA;
    value right = register.bind(state).get();
    value result = left.unsigned + right.unsigned + (withCarry && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        4
    ];
}

[State, Integer] emulateAndImmediate(State state) {
    value result = state.registerA.and(state.dataByte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateAndMemory(State state) {
    value address = word(state.registerH, state.registerL);
    value result = state.registerA.and(state.memory[address] else 0.byte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateAndRegister(ByteRegister register)(State state) {
    value result = state.registerA.and(register.bind(state).get());
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        4
    ];
}

[State, Integer] emulateCallIf(Boolean(State) condition)(State state) {
    if (condition(state)) {
        value [high, low] = bytes(state.returnAddress);
        value address = state.dataWord;
        
        return [
            state.with {
                stateProgramCounter->address,
                stateStackPointer->state.stackPointer - 2,
                state.stackPointer - 1->high,
                state.stackPointer - 2->low
            },
            17
        ];
    } else {
        return [
            state.with {},
            11
        ];
    }
}

[State, Integer] emulateCompareImmediate(State state) {
    value left = state.registerA;
    value right = state.dataByte;
    value result = left.unsigned - right.unsigned;
    value resultByte = result.byte;
    
    return [
        state.with {
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, result.byte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateComplementAccumulator(State state) {
    return [
        state.with {
            stateRegisterA->state.registerA.not
        },
        4
    ];
}

[State, Integer] emulateComplementCarry(State state) {
    return [
        state.with {
            stateCarry->(!state.carry)
        },
        4
    ];
}

[State, Integer] emulateCompareMemory(State state) {
    value left = state.registerA;
    value address = word(state.registerH, state.registerL);
    value right = state.memory[address] else 0.byte;
    value result = left.unsigned - right.unsigned;
    value resultByte = result.byte;
    
    return [
        state.with {
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, result.byte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateCompareRegister(ByteRegister register)(State state) {
    value left = state.registerA;
    value right = register.bind(state).get();
    value result = left.unsigned - right.unsigned;
    value resultByte = result.byte;
    
    return [
        state.with {
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, result.byte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        4
    ];
}

[State, Integer] emulateDecimalAdjust(State state) {
    variable value result = state.registerA.unsigned;
    Boolean auxiliaryCarry;
    Boolean carry;
    
    if (state.auxiliaryCarry || result.and(#0f) > #09) {
        result += #06;
        auxiliaryCarry = true;
    } else {
        auxiliaryCarry = false;
    }
    
    if (state.carry || result.and(#f0) > #90) {
        result += #60;
        carry = true;
    } else {
        carry = false;
    }
    
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->resultByte,
            stateCarry->carry,
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->auxiliaryCarry,
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        4
    ];
}

[State, Integer] emulateDecrementMemory(State state) {
    value address = word(state.registerH, state.registerL);
    value initial = state.memory[address] else 0.byte;
    value val = initial.predecessor;
    
    return [
        state.with {
            address->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        10
    ];
}

[State, Integer] emulateDecrementPair(ByteRegister highRegister, ByteRegister lowRegister)(State state) {
    value pair = word(highRegister.bind(state).get(), lowRegister.bind(state).get());
    value [high, low] = bytes(pair - 1);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low
        },
        5
    ];
}

[State, Integer] emulateDecrementRegister(ByteRegister register)(State state) {
    value initial = register.bind(state).get();
    value val = initial.predecessor;
    
    return [
        state.with {
            register->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDisableInterrupts(State state) {
    return [
        state.with {
            stateInterruptsEnabled->false
        },
        4
    ];
}

[State, Integer] emulateDoubleAdd(ByteRegister highRegister, ByteRegister lowRegister)(State state) {
    value registerHL = word(state.registerH, state.registerL);
    value addend = word {
        high = highRegister.bind(state).get();
        low = lowRegister.bind(state).get();
    };
    value result = registerHL + addend;
    value [resultHigh, resultLow] = bytes(result);
    
    return [
        state.with {
            stateRegisterH->resultHigh,
            stateRegisterL->resultLow,
            stateCarry->result.get(16)
        },
        10
    ];
}

[State, Integer] emulateEnableInterrupts(State state) {
    return [
        state.with {
            stateInterruptsEnabled->true
        },
        4
    ];
}

[State, Integer] emulateExchangeRegisters(State state) {
    return [
        state.with {
            stateRegisterD->state.registerH,
            stateRegisterE->state.registerL,
            stateRegisterH->state.registerD,
            stateRegisterL->state.registerE
        },
        5
    ];
}

[State, Integer] emulateExchangeStack(State state) {
    value address = state.stackPointer;
    
    return [
        state.with {
            stateRegisterH->(state.memory[address + 1] else 0.byte),
            stateRegisterL->(state.memory[address] else 0.byte),
            address + 1->state.registerH,
            address->state.registerL
        },
        18
    ];
}

[State, Integer] emulateHalt(State state) {
    return [
        state.with {
            stateStopped->true
        },
        7
    ];
}

[State, Integer] emulateIncrementPair(ByteRegister highRegister, ByteRegister lowRegister)(State state) {
    value pair = word(highRegister.bind(state).get(), lowRegister.bind(state).get());
    value [high, low] = bytes(pair + 1);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low
        },
        5
    ];
}

[State, Integer] emulateIncrementMemory(State state) {
    value address = word(state.registerH, state.registerL);
    value initial = state.memory[address] else 0.byte;
    value val = initial.successor;
    
    return [
        state.with {
            address->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, 1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        10
    ];
}

[State, Integer] emulateIncrementRegister(ByteRegister register)
        (State state) {
    value initial = register.bind(state).get();
    value val = initial.successor;
    
    return [
        state.with {
            register->register.bind(state).get().successor,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, 1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateJumpIf(Boolean(State) condition)
        (State state) {
    if (condition(state)) {
        return [
            state.with {
                stateProgramCounter->state.dataWord
            },
            10
        ];
    } else {
        return [
            state.with {},
            10
        ];

    }
}

[State, Integer] emulateLoadAccumulator(ByteRegister highRegister, ByteRegister lowRegister)
        (State state) {
    value address = word(highRegister.bind(state).get(), lowRegister.bind(state).get());
    
    return [
        state.with {
            stateRegisterA->(state.memory[address] else 0.byte)
        },
        7
    ];
}

[State, Integer] emulateLoadAccumulatorDirect(State state) {
    value address = state.dataWord;
    
    return [
        state.with {
            stateRegisterA->(state.memory[address] else 0.byte)
        },
        13
    ];
}

[State, Integer] emulateLoadHLDirect(State state) {
    value address = state.dataWord;
    
    return [
        state.with {
            stateRegisterH->(state.memory[address + 1] else 0.byte),
            stateRegisterL->(state.memory[address] else 0.byte)
        },
        16
    ];
}

[State, Integer] emulateLoadPairImmediate(ByteRegister highRegister, ByteRegister lowRegister)
        (State state) {
    value [high, low] = state.dataBytes;
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low
        },
        10
    ];
}

[State, Integer] emulateLoadProgramCounter(State state) {
    value data = word(state.registerH, state.registerL);
    
    return [
        state.with {
            stateProgramCounter->data
        },
        5
    ];
}

[State, Integer] emulateLoadStackPointer(State state) {
    value data = word(state.registerH, state.registerL);
    
    return [
        state.with {
            stateStackPointer->data
        },
        5
    ];
}

[State, Integer] emulateMoveImmediate(ByteRegister register)
        (State state) {
    return [
        state.with {
            register->state.dataByte
        },
        5
    ];
}

[State, Integer] emulateMoveImmediateMemory(State state) {
    value high = state.registerH;
    value low = state.registerL;
    value address = word(high, low);
    
    return [
        state.with {
            address->state.dataByte
        },
        10
    ];
}

[State, Integer] emulateMoveMemoryRegister(ByteRegister register)
        (State state) {
    value address = word(state.registerH, state.registerL);
    
    return [
        state.with {
            address->register.bind(state).get()
        },
        7
    ];
}

[State, Integer] emulateMoveRegisters(ByteRegister destinationRegister, ByteRegister sourceRegister)
        (State state) {
    return [
        state.with {
            destinationRegister->sourceRegister.bind(state).get()
        },
        5
    ];
}

[State, Integer] emulateMoveRegisterMemory(ByteRegister register)
        (State state) {
    value high = state.registerH;
    value low = state.registerL;
    value address = word(high, low);
    value val = state.memory[address];
    
    assert (exists val);
    
    return [
        state.with {
            register->val
        },
        7
    ];
}

[State, Integer] emulateNoop(State state) {
    return [
        state.with {},
        4
    ];
}

[State, Integer] emulateOrImmediate(State state) {
    value result = state.registerA.or(state.dataByte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateOrMemory(State state) {
    value address = word(state.registerH, state.registerL);
    value result = state.registerA.or(state.memory[address] else 0.byte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateOrRegister(ByteRegister register)
        (State state) {
    value result = state.registerA.or(register.bind(state).get());
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        4
    ];
}

[State, Integer] emulatePop(ByteRegister highRegister, ByteRegister lowRegister)
        (State state) {
    value high = state.memory[state.stackPointer + 1];
    value low = state.memory[state.stackPointer];
    
    assert (exists high, exists low);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low,
            stateStackPointer->state.stackPointer + 2
        },
        10
    ];
}

[State, Integer] emulatePush(ByteRegister highAttribute, ByteRegister lowAttribute)
        (State state) {
    value high = highAttribute.bind(state).get();
    value low = lowAttribute.bind(state).get();
    
    return [
        state.with {
            stateStackPointer->state.stackPointer - 2,
            state.stackPointer - 1->high,
            state.stackPointer - 2->low
        },
        11
    ];
}

[State, Integer] emulateReturnIf(Boolean(State) condition, Integer returnCycles = 11)
        (State state) {
    if (condition(state)) {
        value address = word {
            high = state.memory[state.stackPointer + 1];
            low = state.memory[state.stackPointer];
        };
        
        return [
            state.with {
                stateStackPointer->state.stackPointer + 2,
                stateProgramCounter->address
            },
            returnCycles // RET is 10, others are 11
        ];
    } else {
        return [
            state.with {},
            5
        ];
    }
}

[State, Integer] emulateRotateLeft(State state) {
    value carry = state.registerA.get(7);
    value val = state.registerA.leftLogicalShift(1).set(0, carry);
    
    return [
        state.with {
            stateRegisterA->val,
            stateCarry->carry
        },
        4
    ];
}

[State, Integer] emulateRotateLeftThroughCarry(State state) {
    value carry = state.registerA.get(7);
    value val = state.registerA.leftLogicalShift(1).set(0, state.carry);
    
    return [
        state.with {
            stateRegisterA->val,
            stateCarry->carry
        },
        4
    ];
}

[State, Integer] emulateRotateRight(State state) {
    value carry = state.registerA.get(0);
    value val = state.registerA.rightLogicalShift(1).set(7, carry);
    
    return [
        state.with {
            stateRegisterA->val,
            stateCarry->carry
        },
        4
    ];
}

[State, Integer] emulateRotateRightThroughCarry(State state) {
    value carry = state.registerA.get(0);
    value val = state.registerA.rightLogicalShift(1).set(7, state.carry);
    
    return [
        state.with {
            stateRegisterA->val,
            stateCarry->carry
        },
        4
    ];
}

[State, Integer] emulateSetCarry(State state) {
    return [
        state.with {
            stateCarry->true
        },
        4
    ];
}

[State, Integer] emulateStoreAccumulator(ByteRegister registerHigh, ByteRegister registerLow)
        (State state) {
    value address = word(registerHigh.bind(state).get(), registerLow.bind(state).get());
    
    return [
        state.with {
            address->state.registerA
        },
        7
    ];
}

[State, Integer] emulateStoreAccumulatorDirect(State state) {
    value address = state.dataWord;
    
    return [
        state.with {
            address->state.registerA
        },
        13
    ];
}

[State, Integer] emulateStoreHLDirect(State state) {
    value address = state.dataWord;
    
    return [
        state.with {
            address + 1->state.registerH,
            address->state.registerL
        },
        16
    ];
}

[State, Integer] emulateSubtractImmediate(Boolean withBorrow)
        (State state) {
    value left = state.registerA;
    value right = state.dataByte;
    value result = left.unsigned - right.unsigned - (withBorrow && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateSubtractMemory(Boolean withBorrow)
        (State state) {
    value left = state.registerA;
    value address = word(state.registerH, state.registerL);
    value right = state.memory[address] else 0.byte;
    value result = left.unsigned - right.unsigned - (withBorrow && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        7
    ];
}

[State, Integer] emulateSubtractRegister(ByteRegister register, Boolean withBorrow)
        (State state) {
    value left = state.registerA;
    value right = register.bind(state).get();
    value result = left.unsigned - right.unsigned - (withBorrow && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            stateRegisterA->result.byte,
            stateCarry->flagCarry(result),
            stateParity->flagParity(resultByte),
            stateAuxiliaryCarry->flagAuxiliaryCarry(left, right, resultByte),
            stateZero->flagZero(resultByte),
            stateSign->flagSign(resultByte)
        },
        4
    ];
}

[State, Integer] emulateXorImmediate(State state) {
    value result = state.registerA.xor(state.dataByte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateXorMemory(State state) {
    value address = word(state.registerH, state.registerL);
    value result = state.registerA.xor(state.memory[address] else 0.byte);
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        7
    ];
}

[State, Integer] emulateXorRegister(ByteRegister register)(State state) {
    value result = state.registerA.xor(register.bind(state).get());
    
    return [
        state.with {
            stateRegisterA->result,
            stateCarry->false,
            stateParity->flagParity(result),
            stateAuxiliaryCarry->false,
            stateZero->flagZero(result),
            stateSign->flagSign(result)
        },
        4
    ];
}
