"Emulates execution of the next instruction, given the current [[state]] of the CPU and memory.
 Returns the new state and the number of cycles the instruction took."
shared [State, Integer] emulate(State state) {
    import com.crappycomic.emulator101 {
        Opcode { ... }
    }
    
    value opcode = state.opcode;
    
    // TODO: Break up into smaller files, so my laptop doesn't melt.
    
    value emulator = switch (opcode)
        case (addA) emulateAddRegister(State.registerA, false)
        case (addB) emulateAddRegister(State.registerB, false)
        case (addC) emulateAddRegister(State.registerC, false)
        case (addD) emulateAddRegister(State.registerD, false)
        case (addE) emulateAddRegister(State.registerE, false)
        case (addH) emulateAddRegister(State.registerH, false)
        case (addL) emulateAddRegister(State.registerL, false)
        case (addMemory) emulateAddMemory(false)
        case (addImmediate) emulateAddImmediate(false)
        case (addAWithCarry) emulateAddRegister(State.registerA, true)
        case (addBWithCarry) emulateAddRegister(State.registerB, true)
        case (addCWithCarry) emulateAddRegister(State.registerC, true)
        case (addDWithCarry) emulateAddRegister(State.registerD, true)
        case (addEWithCarry) emulateAddRegister(State.registerE, true)
        case (addHWithCarry) emulateAddRegister(State.registerH, true)
        case (addLWithCarry) emulateAddRegister(State.registerL, true)
        case (addMemoryWithCarry) emulateAddMemory(true)
        case (addImmediateWithCarry) emulateAddImmediate(true)
        case (andA) emulateAndRegister(State.registerA)
        case (andB) emulateAndRegister(State.registerB)
        case (andC) emulateAndRegister(State.registerC)
        case (andD) emulateAndRegister(State.registerD)
        case (andE) emulateAndRegister(State.registerE)
        case (andH) emulateAndRegister(State.registerH)
        case (andL) emulateAndRegister(State.registerL)
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
        case (compareA) emulateCompareRegister(State.registerA)
        case (compareB) emulateCompareRegister(State.registerB)
        case (compareC) emulateCompareRegister(State.registerC)
        case (compareD) emulateCompareRegister(State.registerD)
        case (compareE) emulateCompareRegister(State.registerE)
        case (compareH) emulateCompareRegister(State.registerH)
        case (compareL) emulateCompareRegister(State.registerL)
        case (compareMemory) emulateCompareMemory
        case (compareImmediate) emulateCompareImmediate
        case (complementAccumulator) emulateComplementAccumulator
        case (complementCarry) emulateComplementCarry
        case (decimalAdjust) emulateDecimalAdjust
        case (decrementA) emulateDecrementRegisterA
        case (decrementB) emulateDecrementRegisterB
        case (decrementC) emulateDecrementRegisterC
        case (decrementD) emulateDecrementRegisterD
        case (decrementE) emulateDecrementRegisterE
        case (decrementH) emulateDecrementRegisterH
        case (decrementL) emulateDecrementRegisterL
        case (decrementMemory) emulateDecrementMemory
        case (decrementPairB) emulateDecrementPair(stateRegisterB, stateRegisterC)
        case (decrementPairD) emulateDecrementPair(stateRegisterD, stateRegisterE)
        case (decrementPairH) emulateDecrementPair(stateRegisterH, stateRegisterL)
        case (decrementPairStackPointer)
            emulateDecrementPair(stateStackPointerHigh, stateStackPointerLow)
        case (disableInterrupts) emulateDisableInterrupts
        case (doubleAddB) emulateDoubleAdd(State.registerB, State.registerC)
        case (doubleAddD) emulateDoubleAdd(State.registerD, State.registerE)
        case (doubleAddH) emulateDoubleAdd(State.registerH, State.registerL)
        case (doubleAddStackPointer)
            emulateDoubleAdd(State.stackPointerHigh, State.stackPointerLow)
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
        case (incrementPairB) emulateIncrementPairBC
        case (incrementPairD) emulateIncrementPairDE
        case (incrementPairH) emulateIncrementPairHL
        case (incrementPairStackPointer) emulateIncrementPairStackPointer
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
        case (loadAccumulatorB) emulateLoadAccumulator(State.registerB, State.registerC)
        case (loadAccumulatorD) emulateLoadAccumulator(State.registerD, State.registerE)
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
        case (moveAA) emulateMoveRegisters(stateRegisterA, State.registerA)
        case (moveAB) emulateMoveRegisters(stateRegisterA, State.registerB)
        case (moveAC) emulateMoveRegisters(stateRegisterA, State.registerC)
        case (moveAD) emulateMoveRegisters(stateRegisterA, State.registerD)
        case (moveAE) emulateMoveRegisters(stateRegisterA, State.registerE)
        case (moveAH) emulateMoveRegisters(stateRegisterA, State.registerH)
        case (moveAL) emulateMoveRegisters(stateRegisterA, State.registerL)
        case (moveAMemory) emulateMoveRegisterMemory(stateRegisterA)
        case (moveBA) emulateMoveRegisters(stateRegisterB, State.registerA)
        case (moveBB) emulateMoveRegisters(stateRegisterB, State.registerB)
        case (moveBC) emulateMoveRegisters(stateRegisterB, State.registerC)
        case (moveBD) emulateMoveRegisters(stateRegisterB, State.registerD)
        case (moveBE) emulateMoveRegisters(stateRegisterB, State.registerE)
        case (moveBH) emulateMoveRegisters(stateRegisterB, State.registerH)
        case (moveBL) emulateMoveRegisters(stateRegisterB, State.registerL)
        case (moveBMemory) emulateMoveRegisterMemory(stateRegisterB)
        case (moveCA) emulateMoveRegisters(stateRegisterC, State.registerA)
        case (moveCB) emulateMoveRegisters(stateRegisterC, State.registerB)
        case (moveCC) emulateMoveRegisters(stateRegisterC, State.registerC)
        case (moveCD) emulateMoveRegisters(stateRegisterC, State.registerD)
        case (moveCE) emulateMoveRegisters(stateRegisterC, State.registerE)
        case (moveCH) emulateMoveRegisters(stateRegisterC, State.registerH)
        case (moveCL) emulateMoveRegisters(stateRegisterC, State.registerL)
        case (moveCMemory) emulateMoveRegisterMemory(stateRegisterC)
        case (moveDA) emulateMoveRegisters(stateRegisterD, State.registerA)
        case (moveDB) emulateMoveRegisters(stateRegisterD, State.registerB)
        case (moveDC) emulateMoveRegisters(stateRegisterD, State.registerC)
        case (moveDD) emulateMoveRegisters(stateRegisterD, State.registerD)
        case (moveDE) emulateMoveRegisters(stateRegisterD, State.registerE)
        case (moveDH) emulateMoveRegisters(stateRegisterD, State.registerH)
        case (moveDL) emulateMoveRegisters(stateRegisterD, State.registerL)
        case (moveDMemory) emulateMoveRegisterMemory(stateRegisterD)
        case (moveEA) emulateMoveRegisters(stateRegisterE, State.registerA)
        case (moveEB) emulateMoveRegisters(stateRegisterE, State.registerB)
        case (moveEC) emulateMoveRegisters(stateRegisterE, State.registerC)
        case (moveED) emulateMoveRegisters(stateRegisterE, State.registerD)
        case (moveEE) emulateMoveRegisters(stateRegisterE, State.registerE)
        case (moveEH) emulateMoveRegisters(stateRegisterE, State.registerH)
        case (moveEL) emulateMoveRegisters(stateRegisterE, State.registerL)
        case (moveEMemory) emulateMoveRegisterMemory(stateRegisterE)
        case (moveHA) emulateMoveRegisters(stateRegisterH, State.registerA)
        case (moveHB) emulateMoveRegisters(stateRegisterH, State.registerB)
        case (moveHC) emulateMoveRegisters(stateRegisterH, State.registerC)
        case (moveHD) emulateMoveRegisters(stateRegisterH, State.registerD)
        case (moveHE) emulateMoveRegisters(stateRegisterH, State.registerE)
        case (moveHH) emulateMoveRegisters(stateRegisterH, State.registerH)
        case (moveHL) emulateMoveRegisters(stateRegisterH, State.registerL)
        case (moveHMemory) emulateMoveRegisterMemory(stateRegisterH)
        case (moveLA) emulateMoveRegisters(stateRegisterL, State.registerA)
        case (moveLB) emulateMoveRegisters(stateRegisterL, State.registerB)
        case (moveLC) emulateMoveRegisters(stateRegisterL, State.registerC)
        case (moveLD) emulateMoveRegisters(stateRegisterL, State.registerD)
        case (moveLE) emulateMoveRegisters(stateRegisterL, State.registerE)
        case (moveLH) emulateMoveRegisters(stateRegisterL, State.registerH)
        case (moveLL) emulateMoveRegisters(stateRegisterL, State.registerL)
        case (moveLMemory) emulateMoveRegisterMemory(stateRegisterL)
        case (moveMemoryA) emulateMoveMemoryRegister(State.registerA)
        case (moveMemoryB) emulateMoveMemoryRegister(State.registerB)
        case (moveMemoryC) emulateMoveMemoryRegister(State.registerC)
        case (moveMemoryD) emulateMoveMemoryRegister(State.registerD)
        case (moveMemoryE) emulateMoveMemoryRegister(State.registerE)
        case (moveMemoryH) emulateMoveMemoryRegister(State.registerH)
        case (moveMemoryL) emulateMoveMemoryRegister(State.registerL)
        case (noop) emulateNoop
        case (orA) emulateOrRegister(State.registerA)
        case (orB) emulateOrRegister(State.registerB)
        case (orC) emulateOrRegister(State.registerC)
        case (orD) emulateOrRegister(State.registerD)
        case (orE) emulateOrRegister(State.registerE)
        case (orH) emulateOrRegister(State.registerH)
        case (orL) emulateOrRegister(State.registerL)
        case (orMemory) emulateOrMemory
        case (orImmediate) emulateOrImmediate
        case (output) emulateOutput
        case (popB) emulatePop(stateRegisterB, stateRegisterC)
        case (popD) emulatePop(stateRegisterD, stateRegisterE)
        case (popH) emulatePop(stateRegisterH, stateRegisterL)
        case (popStatus) emulatePop(stateRegisterA, stateFlags)
        case (pushB) emulatePush(State.registerB, State.registerC)
        case (pushD) emulatePush(State.registerD, State.registerE)
        case (pushH) emulatePush(State.registerH, State.registerL)
        case (pushStatus) emulatePush(State.registerA, State.flags)
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
        case (storeAccumulatorB) emulateStoreAccumulator(State.registerB, State.registerC)
        case (storeAccumulatorD) emulateStoreAccumulator(State.registerD, State.registerE)
        case (storeAccumulatorDirect) emulateStoreAccumulatorDirect
        case (storeHLDirect) emulateStoreHLDirect
        case (subtractA) emulateSubtractRegister(State.registerA, false)
        case (subtractB) emulateSubtractRegister(State.registerB, false)
        case (subtractC) emulateSubtractRegister(State.registerC, false)
        case (subtractD) emulateSubtractRegister(State.registerD, false)
        case (subtractE) emulateSubtractRegister(State.registerE, false)
        case (subtractH) emulateSubtractRegister(State.registerH, false)
        case (subtractL) emulateSubtractRegister(State.registerL, false)
        case (subtractMemory) emulateSubtractMemory(false)
        case (subtractImmediate) emulateSubtractImmediate(false)
        case (subtractAWithBorrow) emulateSubtractRegister(State.registerA, true)
        case (subtractBWithBorrow) emulateSubtractRegister(State.registerB, true)
        case (subtractCWithBorrow) emulateSubtractRegister(State.registerC, true)
        case (subtractDWithBorrow) emulateSubtractRegister(State.registerD, true)
        case (subtractEWithBorrow) emulateSubtractRegister(State.registerE, true)
        case (subtractHWithBorrow) emulateSubtractRegister(State.registerH, true)
        case (subtractLWithBorrow) emulateSubtractRegister(State.registerL, true)
        case (subtractMemoryWithBorrow) emulateSubtractMemory(true)
        case (subtractImmediateWithBorrow) emulateSubtractImmediate(true)
        case (xorA) emulateXorRegister(State.registerA)
        case (xorB) emulateXorRegister(State.registerB)
        case (xorC) emulateXorRegister(State.registerC)
        case (xorD) emulateXorRegister(State.registerD)
        case (xorE) emulateXorRegister(State.registerE)
        case (xorH) emulateXorRegister(State.registerH)
        case (xorL) emulateXorRegister(State.registerL)
        case (xorMemory) emulateXorMemory
        case (xorImmediate) emulateXorImmediate
        ;
    
    return emulator(state);
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

[State, Integer] emulateAddRegister(Byte(State) register, Boolean withCarry)(State state) {
    value left = state.registerA;
    value right = register(state);
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

[State, Integer] emulateAndRegister(Byte(State) register)(State state) {
    value result = state.registerA.and(register(state));
    
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

[State, Integer] emulateCompareRegister(Byte(State) register)(State state) {
    value left = state.registerA;
    value right = register(state);
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

[State, Integer] emulateDecrementPair(ByteRegister highRegister, ByteRegister lowRegister)
        (State state) {
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

[State, Integer] emulateDecrementRegisterA(State state) {
    value initial = state.registerA;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterA->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterB(State state) {
    value initial = state.registerB;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterB->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterC(State state) {
    value initial = state.registerC;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterC->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterD(State state) {
    value initial = state.registerD;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterD->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterE(State state) {
    value initial = state.registerE;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterE->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterH(State state) {
    value initial = state.registerH;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterH->val,
            stateParity->flagParity(val),
            stateAuxiliaryCarry->flagAuxiliaryCarry(initial, -1.byte, val),
            stateZero->flagZero(val),
            stateSign->flagSign(val)
        },
        5
    ];
}

[State, Integer] emulateDecrementRegisterL(State state) {
    value initial = state.registerL;
    value val = initial.predecessor;
    
    return [
        state.with {
            stateRegisterL->val,
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

[State, Integer] emulateDoubleAdd(Byte(State) highRegister, Byte(State) lowRegister)(State state) {
    value registerHL = word(state.registerH, state.registerL);
    value addend = word {
        high = highRegister(state);
        low = lowRegister(state);
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

[State, Integer] emulateIncrementPairBC(State state) {
    value pair = word(state.registerB, state.registerC);
    value [high, low] = bytes(pair + 1);
    
    return [
        state.with {
            stateRegisterB->high,
            stateRegisterC->low
        },
        5
    ];
}

[State, Integer] emulateIncrementPairDE(State state) {
    value pair = word(state.registerD, state.registerE);
    value [high, low] = bytes(pair + 1);
    
    return [
        state.with {
            stateRegisterD->high,
            stateRegisterE->low
        },
        5
    ];
}

[State, Integer] emulateIncrementPairHL(State state) {
    value pair = word(state.registerH, state.registerL);
    value [high, low] = bytes(pair + 1);
    
    return [
        state.with {
            stateRegisterH->high,
            stateRegisterL->low
        },
        5
    ];
}

[State, Integer] emulateIncrementPairStackPointer(State state) {
    return [
        state.with {
            stateStackPointer->state.stackPointer + 1
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
            register->val,
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

[State, Integer] emulateLoadAccumulator(Byte(State) highRegister, Byte(State) lowRegister)
        (State state) {
    value address = word(highRegister(state), lowRegister(state));
    
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

[State, Integer] emulateMoveMemoryRegister(Byte(State) register)
        (State state) {
    value address = word(state.registerH, state.registerL);
    
    return [
        state.with {
            address->register(state)
        },
        7
    ];
}

[State, Integer] emulateMoveRegisters(ByteRegister destinationRegister, Byte(State) sourceRegister)
        (State state) {
    return [
        state.with {
            destinationRegister->sourceRegister(state)
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

[State, Integer] emulateOrRegister(Byte(State) register)
        (State state) {
    value result = state.registerA.or(register(state));
    
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

[State, Integer] emulatePush(Byte(State) highAttribute, Byte(State) lowAttribute)
        (State state) {
    value high = highAttribute(state);
    value low = lowAttribute(state);
    
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

[State, Integer] emulateStoreAccumulator(Byte(State) registerHigh, Byte(State) registerLow)
        (State state) {
    value address = word(registerHigh(state), registerLow(state));
    
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

[State, Integer] emulateSubtractRegister(Byte(State) register, Boolean withBorrow)
        (State state) {
    value left = state.registerA;
    value right = register(state);
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

[State, Integer] emulateXorRegister(Byte(State) register)(State state) {
    value result = state.registerA.xor(register(state));
    
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
