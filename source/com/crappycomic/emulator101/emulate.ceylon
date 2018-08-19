"Emulates execution of the next instruction, given the current [[state]] of the CPU and memory.
 Returns the new state and the number of cycles the instruction took."
shared [State, Integer] emulate(State state) {
    value val = state.memory[state.programCounter];
    
    assert (exists val);
    
    value opcode = opcodes[val];
    
    assert (exists opcode);
    
    value emulator = switch (opcode)
        case (addA) nothing
        case (addB) emulateAddRegister(`State.registerB`, false)
        case (addC) emulateAddRegister(`State.registerC`, false)
        case (addD) emulateAddRegister(`State.registerD`, false)
        case (addE) emulateAddRegister(`State.registerE`, false)
        case (addH) emulateAddRegister(`State.registerH`, false)
        case (addL) emulateAddRegister(`State.registerL`, false)
        case (addMemory) nothing
        case (addImmediate) emulateAddImmediate(false)
        case (addAWithCarry) nothing
        case (addBWithCarry) nothing
        case (addCWithCarry) nothing
        case (addDWithCarry) nothing
        case (addEWithCarry) nothing
        case (addHWithCarry) nothing
        case (addLWithCarry) nothing
        case (addMemoryWithCarry) nothing
        case (addImmediateWithCarry) emulateAddImmediate(true)
        case (andA) nothing
        case (andB) nothing
        case (andC) nothing
        case (andD) nothing
        case (andE) nothing
        case (andH) nothing
        case (andL) nothing
        case (andImmediate) emulateAndImmediate
        case (andMemory) nothing
        case (call) emulateCallIf((state) => true)
        case (callIfCarry) emulateCallIf(State.carry)
        case (callIfMinus) emulateCallIf(State.sign)
        case (callIfNoCarry) emulateCallIf(not(State.carry))
        case (callIfNotZero) emulateCallIf(not(State.zero))
        case (callIfParityEven) emulateCallIf(State.parity)
        case (callIfParityOdd) emulateCallIf(not(State.parity))
        case (callIfPlus) emulateCallIf(not(State.sign))
        case (callIfZero) emulateCallIf(State.zero)
        case (compareA) nothing
        case (compareB) nothing
        case (compareC) nothing
        case (compareD) nothing
        case (compareE) nothing
        case (compareH) nothing
        case (compareL) nothing
        case (compareMemory) nothing
        case (compareImmediate) emulateCompareImmediate
        case (decimalAdjust) nothing
        case (decrementA) emulateDecrementRegister(`State.registerA`)
        case (decrementB) emulateDecrementRegister(`State.registerB`)
        case (decrementC) emulateDecrementRegister(`State.registerC`)
        case (decrementD) emulateDecrementRegister(`State.registerD`)
        case (decrementE) emulateDecrementRegister(`State.registerE`)
        case (decrementH) emulateDecrementRegister(`State.registerH`)
        case (decrementL) emulateDecrementRegister(`State.registerL`)
        case (decrementMemory) nothing
        case (decrementPairH) nothing
        case (disableInterrupts) nothing
        case (doubleAddB) emulateDoubleAdd(`State.registerB`, `State.registerC`)
        case (doubleAddD) emulateDoubleAdd(`State.registerD`, `State.registerE`)
        case (doubleAddH) emulateDoubleAdd(`State.registerH`, `State.registerL`)
        case (enableInterrupts) nothing
        case (exchangeRegisters) emulateExchangeRegisters
        case (halt) nothing
        case (incrementA) emulateIncrementRegister(`State.registerA`)
        case (incrementB) emulateIncrementRegister(`State.registerB`)
        case (incrementC) emulateIncrementRegister(`State.registerC`)
        case (incrementD) emulateIncrementRegister(`State.registerD`)
        case (incrementE) emulateIncrementRegister(`State.registerE`)
        case (incrementH) emulateIncrementRegister(`State.registerH`)
        case (incrementL) emulateIncrementRegister(`State.registerL`)
        case (incrementPairB) emulateIncrementPair(`State.registerB`, `State.registerC`)
        case (incrementPairD) emulateIncrementPair(`State.registerD`, `State.registerE`)
        case (incrementPairH) emulateIncrementPair(`State.registerH`, `State.registerL`)
        case (input) nothing
        case (jump) emulateJumpIf((state) => true)
        case (jumpIfCarry) emulateJumpIf(State.carry)
        case (jumpIfMinus) emulateJumpIf(State.sign)
        case (jumpIfNoCarry) emulateJumpIf(not(State.carry))
        case (jumpIfNotZero) emulateJumpIf(not(State.zero))
        case (jumpIfParityEven) emulateJumpIf(State.parity)
        case (jumpIfParityOdd) emulateJumpIf(not(State.parity))
        case (jumpIfPlus) emulateJumpIf(not(State.sign))
        case (jumpIfZero) emulateJumpIf(State.zero)
        case (loadAccumulatorD) emulateLoadAccumulator(`State.registerD`, `State.registerE`)
        case (loadAccumulatorDirect) emulateLoadAccumulatorDirect
        case (loadHLDirect) nothing
        case (loadPairImmediateB) emulateLoadPairImmediate(`State.registerB`, `State.registerC`)
        case (loadPairImmediateD) emulateLoadPairImmediate(`State.registerD`, `State.registerE`)
        case (loadPairImmediateH) emulateLoadPairImmediate(`State.registerH`, `State.registerL`)
        case (loadPairImmediateStackPointer) emulateLoadPairImmediateStackPointer
        case (moveImmediateA) emulateMoveImmediate(`State.registerA`)
        case (moveImmediateB) emulateMoveImmediate(`State.registerB`)
        case (moveImmediateC) emulateMoveImmediate(`State.registerC`)
        case (moveImmediateD) emulateMoveImmediate(`State.registerD`)
        case (moveImmediateE) emulateMoveImmediate(`State.registerE`)
        case (moveImmediateH) emulateMoveImmediate(`State.registerH`)
        case (moveImmediateL) emulateMoveImmediate(`State.registerL`)
        case (moveImmediateMemory) emulateMoveImmediateMemory
        case (moveAA) emulateMoveRegisters(`State.registerA`, `State.registerA`)
        case (moveAB) emulateMoveRegisters(`State.registerA`, `State.registerB`)
        case (moveAC) emulateMoveRegisters(`State.registerA`, `State.registerC`)
        case (moveAD) emulateMoveRegisters(`State.registerA`, `State.registerD`)
        case (moveAE) emulateMoveRegisters(`State.registerA`, `State.registerE`)
        case (moveAH) emulateMoveRegisters(`State.registerA`, `State.registerH`)
        case (moveAL) emulateMoveRegisters(`State.registerA`, `State.registerL`)
        case (moveAMemory) emulateMoveRegisterMemory(`State.registerA`)
        case (moveBA) emulateMoveRegisters(`State.registerB`, `State.registerA`)
        case (moveBB) emulateMoveRegisters(`State.registerB`, `State.registerB`)
        case (moveBC) emulateMoveRegisters(`State.registerB`, `State.registerC`)
        case (moveBD) emulateMoveRegisters(`State.registerB`, `State.registerD`)
        case (moveBE) emulateMoveRegisters(`State.registerB`, `State.registerE`)
        case (moveBH) emulateMoveRegisters(`State.registerB`, `State.registerH`)
        case (moveBL) emulateMoveRegisters(`State.registerB`, `State.registerL`)
        case (moveBMemory) emulateMoveRegisterMemory(`State.registerB`)
        case (moveCA) emulateMoveRegisters(`State.registerC`, `State.registerA`)
        case (moveCB) emulateMoveRegisters(`State.registerC`, `State.registerB`)
        case (moveCC) emulateMoveRegisters(`State.registerC`, `State.registerC`)
        case (moveCD) emulateMoveRegisters(`State.registerC`, `State.registerD`)
        case (moveCE) emulateMoveRegisters(`State.registerC`, `State.registerE`)
        case (moveCH) emulateMoveRegisters(`State.registerC`, `State.registerH`)
        case (moveCL) emulateMoveRegisters(`State.registerC`, `State.registerL`)
        case (moveCMemory) emulateMoveRegisterMemory(`State.registerC`)
        case (moveDA) emulateMoveRegisters(`State.registerD`, `State.registerA`)
        case (moveDB) emulateMoveRegisters(`State.registerD`, `State.registerB`)
        case (moveDC) emulateMoveRegisters(`State.registerD`, `State.registerC`)
        case (moveDD) emulateMoveRegisters(`State.registerD`, `State.registerD`)
        case (moveDE) emulateMoveRegisters(`State.registerD`, `State.registerE`)
        case (moveDH) emulateMoveRegisters(`State.registerD`, `State.registerH`)
        case (moveDL) emulateMoveRegisters(`State.registerD`, `State.registerL`)
        case (moveDMemory) emulateMoveRegisterMemory(`State.registerD`)
        case (moveEA) emulateMoveRegisters(`State.registerE`, `State.registerA`)
        case (moveEB) emulateMoveRegisters(`State.registerE`, `State.registerB`)
        case (moveEC) emulateMoveRegisters(`State.registerE`, `State.registerC`)
        case (moveED) emulateMoveRegisters(`State.registerE`, `State.registerD`)
        case (moveEE) emulateMoveRegisters(`State.registerE`, `State.registerE`)
        case (moveEH) emulateMoveRegisters(`State.registerE`, `State.registerH`)
        case (moveEL) emulateMoveRegisters(`State.registerE`, `State.registerL`)
        case (moveEMemory) emulateMoveRegisterMemory(`State.registerE`)
        case (moveHA) emulateMoveRegisters(`State.registerH`, `State.registerA`)
        case (moveHB) emulateMoveRegisters(`State.registerH`, `State.registerB`)
        case (moveHC) emulateMoveRegisters(`State.registerH`, `State.registerC`)
        case (moveHD) emulateMoveRegisters(`State.registerH`, `State.registerD`)
        case (moveHE) emulateMoveRegisters(`State.registerH`, `State.registerE`)
        case (moveHH) emulateMoveRegisters(`State.registerH`, `State.registerH`)
        case (moveHL) emulateMoveRegisters(`State.registerH`, `State.registerL`)
        case (moveHMemory) emulateMoveRegisterMemory(`State.registerH`)
        case (moveLA) emulateMoveRegisters(`State.registerL`, `State.registerA`)
        case (moveLB) emulateMoveRegisters(`State.registerL`, `State.registerB`)
        case (moveLC) emulateMoveRegisters(`State.registerL`, `State.registerC`)
        case (moveLD) emulateMoveRegisters(`State.registerL`, `State.registerD`)
        case (moveLE) emulateMoveRegisters(`State.registerL`, `State.registerE`)
        case (moveLH) emulateMoveRegisters(`State.registerL`, `State.registerH`)
        case (moveLL) emulateMoveRegisters(`State.registerL`, `State.registerL`)
        case (moveLMemory) emulateMoveRegisterMemory(`State.registerL`)
        case (moveMemoryA) emulateMoveMemoryRegister(`State.registerA`)
        case (moveMemoryB) emulateMoveMemoryRegister(`State.registerB`)
        case (moveMemoryC) emulateMoveMemoryRegister(`State.registerC`)
        case (moveMemoryD) emulateMoveMemoryRegister(`State.registerD`)
        case (moveMemoryE) emulateMoveMemoryRegister(`State.registerE`)
        case (moveMemoryH) emulateMoveMemoryRegister(`State.registerH`)
        case (moveMemoryL) emulateMoveMemoryRegister(`State.registerL`)
        case (noop) emulateNoop
        case (orA) nothing
        case (orB) nothing
        case (orC) nothing
        case (orD) nothing
        case (orE) nothing
        case (orH) nothing
        case (orL) nothing
        case (orMemory) nothing
        case (orImmediate) emulateOrImmediate
        case (output) emulateOutput
        case (popB) emulatePop(`State.registerB`, `State.registerC`)
        case (popD) emulatePop(`State.registerD`, `State.registerE`)
        case (popH) emulatePop(`State.registerH`, `State.registerL`)
        case (popStatus) emulatePop(`State.registerA`, `State.flags`)
        case (pushB) emulatePush(`State.registerB`, `State.registerC`)
        case (pushD) emulatePush(`State.registerD`, `State.registerE`)
        case (pushH) emulatePush(`State.registerH`, `State.registerL`)
        case (pushStatus) emulatePush(`State.registerA`, `State.flags`)
        case (\ireturn) emulateReturnIf((state) => true, 10)
        case (returnIfCarry) emulateReturnIf(State.carry)
        case (returnIfMinus) emulateReturnIf(State.sign)
        case (returnIfNoCarry) emulateReturnIf(not(State.carry))
        case (returnIfNotZero) emulateReturnIf(not(State.zero))
        case (returnIfParityEven) emulateReturnIf(State.parity)
        case (returnIfParityOdd) emulateReturnIf(not(State.parity))
        case (returnIfPlus) emulateReturnIf(not(State.sign))
        case (returnIfZero) emulateReturnIf(State.zero)
        case (rotateAccumulatorLeft) nothing
        case (rotateAccumulatorRight) emulateRotateAccumulatorRight
        case (storeAccumulatorDirect) emulateStoreAccumulatorDirect
        case (storeHLDirect) nothing
        case (subtractA) nothing
        case (subtractB) nothing
        case (subtractC) nothing
        case (subtractD) nothing
        case (subtractE) nothing
        case (subtractH) nothing
        case (subtractL) nothing
        case (subtractMemory) nothing
        case (subtractImmediate) emulateSubtractImmediate(false)
        case (subtractAWithBorrow) nothing
        case (subtractBWithBorrow) nothing
        case (subtractCWithBorrow) nothing
        case (subtractDWithBorrow) nothing
        case (subtractEWithBorrow) nothing
        case (subtractHWithBorrow) nothing
        case (subtractLWithBorrow) nothing
        case (subtractMemoryWithBorrow) nothing
        case (subtractImmediateWithBorrow) emulateSubtractImmediate(true)
        case (xorA) emulateXorRegister(`State.registerA`)
        case (xorB) nothing
        case (xorC) nothing
        case (xorD) nothing
        case (xorE) nothing
        case (xorH) nothing
        case (xorL) nothing
        case (xorMemory) nothing
        case (xorImmediate) emulateXorImmediate
        ;
    
    if (is Anything(Opcode, State) emulator) {
        return emulator(opcode, state);
    } else {
        return emulator(state);
    }
}

Byte dataByte(State state) => state.memory[state.programCounter + 1] else 0.byte;

Byte[2] dataBytes(State state) => [
    state.memory[state.programCounter + 2] else 0.byte,
    state.memory[state.programCounter + 1] else 0.byte
];

Integer dataWord(State state)
        => let ([high, low] = dataBytes(state))
            word(high, low);

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

[State, Integer] emulateAddImmediate(Boolean withCarry)(State state) {
    value left = state.registerA;
    value right = dataByte(state);
    value result = left.unsigned + right.unsigned + (withCarry && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
    state.with {
            `State.registerA`->result.byte,
            `State.carry`->flagCarry(result),
            `State.parity`->flagParity(resultByte),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(left, right, resultByte),
            `State.zero`->flagZero(resultByte),
            `State.sign`->flagSign(resultByte),
            `State.programCounter`->state.programCounter + addImmediate.size
        },
        7
    ];
}

[State, Integer] emulateAddRegister(ByteRegister register, Boolean withCarry)
        (Opcode opcode, State state) {
    value left = state.registerA;
    value right = register.bind(state).get();
    value result = left.unsigned + right.unsigned + (withCarry && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            `State.registerA`->result.byte,
            `State.carry`->flagCarry(result),
            `State.parity`->flagParity(resultByte),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(left, right, resultByte),
            `State.zero`->flagZero(resultByte),
            `State.sign`->flagSign(resultByte),
            `State.programCounter`->state.programCounter + opcode.size
        },
        4
    ];
}

[State, Integer] emulateAndImmediate(State state) {
    value result = state.registerA.and(dataByte(state));
    
    return [
        state.with {
            `State.registerA`->result,
            `State.carry`->false,
            `State.parity`->flagParity(result),
            `State.zero`->flagZero(result),
            `State.sign`->flagSign(result),
            `State.programCounter`->state.programCounter + andImmediate.size
        },
        7
    ];
}

[State, Integer] emulateCallIf(Boolean(State) condition)
        (Opcode opcode, State state) {
    if (condition(state)) {
        value [high, low] = bytes(state.programCounter);
        value address = dataWord(state);
        
        return [
            state.with {
                `State.programCounter`->address,
                `State.stackPointer`->state.stackPointer - 2,
                state.stackPointer - 1->high,
                state.stackPointer - 2->low
            },
            17
        ];
    } else {
        return [
            state.with {
                `State.programCounter`->state.programCounter + opcode.size
            },
            11
        ];
    }
}

[State, Integer] emulateCompareImmediate(State state) {
    value left = state.registerA;
    value right = dataByte(state);
    value result = left.unsigned - right.unsigned;
    value resultByte = result.byte;
    
    return [
        state.with {
            `State.carry`->flagCarry(result),
            `State.parity`->flagParity(resultByte),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(left, right, result.byte),
            `State.zero`->flagZero(resultByte),
            `State.sign`->flagSign(resultByte),
            `State.programCounter`->state.programCounter + compareImmediate.size
        },
        7
    ];
}

[State, Integer] emulateDecrementRegister(ByteRegister register)
        (Opcode opcode, State state) {
    value val = register.bind(state).get().predecessor;
    
    return [
        state.with {
            register->val,
            `State.parity`->flagParity(val),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(state.registerB, 1.byte, val),
            `State.zero`->flagZero(val),
            `State.sign`->flagSign(val),
            `State.programCounter`->state.programCounter + opcode.size
        },
        5
    ];
}

[State, Integer] emulateDoubleAdd(ByteRegister highRegister, ByteRegister lowRegister)
        (Opcode opcode, State state) {
    value registerHL = word(state.registerH, state.registerL);
    value addend = word {
        high = highRegister.bind(state).get();
        low = lowRegister.bind(state).get();
    };
    value result = registerHL + addend;
    value [resultHigh, resultLow] = bytes(result);
    
    return [
        state.with {
            `State.registerH`->resultHigh,
            `State.registerL`->resultLow,
            `State.carry`->result.get(16),
            `State.programCounter`->state.programCounter + opcode.size
        },
        10
    ];
}

[State, Integer] emulateExchangeRegisters(State state) {
    return [
        state.with {
            `State.registerD`->state.registerH,
            `State.registerE`->state.registerL,
            `State.registerH`->state.registerD,
            `State.registerL`->state.registerE,
            `State.programCounter`->state.programCounter + exchangeRegisters.size
        },
        5
    ];
}

[State, Integer] emulateIncrementPair(ByteRegister highRegister, ByteRegister lowRegister)
        (Opcode opcode, State state) {
    value pair = word(highRegister.bind(state).get(), lowRegister.bind(state).get());
    value [high, low] = bytes(pair + 1);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low,
            `State.programCounter`->state.programCounter + opcode.size
        },
        5
    ];
}

[State, Integer] emulateIncrementRegister(ByteRegister register)
        (Opcode opcode, State state) {
    value initial = register.bind(state).get();
    value val = initial.successor;
    
    return [
        state.with {
            register->register.bind(state).get().successor,
            `State.parity`->flagParity(val),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(initial, 1.byte, val),
            `State.zero`->flagZero(val),
            `State.sign`->flagSign(val),
            `State.programCounter`->state.programCounter + opcode.size
        },
        5
    ];
}

[State, Integer] emulateJumpIf(Boolean(State) condition)
        (Opcode opcode, State state) {
    value programCounter = condition(state)
            then dataWord(state)
            else state.programCounter + opcode.size;
    
    return [
        state.with {
            `State.programCounter`->programCounter
        },
        10
    ];
}

[State, Integer] emulateLoadAccumulator(ByteRegister highRegister, ByteRegister lowRegister)
        (Opcode opcode, State state) {
    value address = word(highRegister.bind(state).get(), lowRegister.bind(state).get());
    
    return [
        state.with {
            `State.registerA`->(state.memory[address] else 0.byte),
            `State.programCounter`->state.programCounter + opcode.size
        },
        7
    ];
}

[State, Integer] emulateLoadAccumulatorDirect(State state) {
    value address = dataWord(state);
    
    return [
        state.with {
            `State.registerA`->(state.memory[address] else 0.byte),
            `State.programCounter`->state.programCounter + loadAccumulatorDirect.size
        },
        13
    ];
}

[State, Integer] emulateLoadPairImmediate(ByteRegister highRegister, ByteRegister lowRegister)
        (Opcode opcode, State state) {
    value [high, low] = dataBytes(state);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low,
            `State.programCounter`->state.programCounter + opcode.size
        },
        10
    ];
}

[State, Integer] emulateLoadPairImmediateStackPointer(State state) {
    return [
        state.with {
            `State.stackPointer`->dataWord(state),
            `State.programCounter`->state.programCounter + loadPairImmediateStackPointer.size
        },
        10
    ];
}

[State, Integer] emulateMoveImmediate(ByteRegister register)
        (Opcode opcode, State state) {
    return [
        state.with {
            register->dataByte(state),
            `State.programCounter`->state.programCounter + opcode.size
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
            `State.programCounter`->state.programCounter + moveImmediateMemory.size,
            address->dataByte(state)
        },
        10
    ];
}

[State, Integer] emulateMoveMemoryRegister(ByteRegister register)
        (Opcode opcode, State state) {
    value address = word(state.registerH, state.registerL);
    
    return [
        state.with {
            `State.programCounter`->state.programCounter + opcode.size,
            address->register.bind(state).get()
        },
        7
    ];
}

[State, Integer] emulateMoveRegisters(ByteRegister destinationRegister, ByteRegister sourceRegister)
        (Opcode opcode, State state) {
    return [
        state.with {
            destinationRegister->sourceRegister.bind(state).get(),
            `State.programCounter`->state.programCounter + opcode.size
        },
        5
    ];
}

[State, Integer] emulateMoveRegisterMemory(ByteRegister register)
        (Opcode opcode, State state) {
    value high = state.registerH;
    value low = state.registerL;
    value address = word(high, low);
    value val = state.memory[address];
    
    assert (exists val);
    
    return [
        state.with {
            register->val,
            `State.programCounter`->state.programCounter + opcode.size
        },
        7
    ];
}

[State, Integer] emulateNoop(State state) {
    return [
        state.with {
            `State.programCounter`->state.programCounter + noop.size
        },
        4
    ];
}

[State, Integer] emulateOrImmediate(State state) {
    value result = state.registerA.or(dataByte(state));
    
    return [
        state.with {
            `State.registerA`->result,
            `State.carry`->false,
            `State.parity`->flagParity(result),
            `State.zero`->flagZero(result),
            `State.sign`->flagSign(result),
            `State.programCounter`->state.programCounter + orImmediate.size
        },
        7
    ];
}

[State, Integer] emulateOutput(State state) {
    // TODO: Hook into system hardware.
    return [
        state.with {
            `State.programCounter`->state.programCounter + output.size
        },
        10
    ];
}

[State, Integer] emulatePop(ByteRegister highRegister, ByteRegister lowRegister)
        (Opcode opcode, State state) {
    value high = state.memory[state.stackPointer + 1];
    value low = state.memory[state.stackPointer];
    
    assert (exists high, exists low);
    
    return [
        state.with {
            highRegister->high,
            lowRegister->low,
            `State.stackPointer`->state.stackPointer + 2,
            `State.programCounter`->state.programCounter + opcode.size
        },
        10
    ];
}

[State, Integer] emulatePush(ByteRegister highAttribute, ByteRegister lowAttribute)
        (Opcode opcode, State state) {
    value high = highAttribute.bind(state).get();
    value low = lowAttribute.bind(state).get();
    
    return [
        state.with {
            `State.stackPointer`->state.stackPointer - 2,
            `State.programCounter`->state.programCounter + opcode.size,
            state.stackPointer - 1->high,
            state.stackPointer - 2->low
        },
        11
    ];
}

[State, Integer] emulateReturnIf(Boolean(State) condition, Integer returnCycles = 11)
        (Opcode opcode, State state) {
    if (condition(state)) {
        value address = word {
            high = state.memory[state.stackPointer + 1];
            low = state.memory[state.stackPointer];
        };
        value val = state.memory[address];
        
        assert (exists val);
        
        value returnOpcode = opcodes[val];
        
        assert (exists returnOpcode);
        
        return [
            state.with {
                `State.stackPointer`->state.stackPointer + 2,
                `State.programCounter`->address + returnOpcode.size
            },
            returnCycles // RET is 10, others are 11
        ];
    } else {
        return [
            state.with {
                `State.programCounter`->state.programCounter + opcode.size
            },
            5
        ];
    }
}

[State, Integer] emulateRotateAccumulatorRight(State state) {
    value carry = state.registerA.get(0);
    value val = state.registerA.rightLogicalShift(1).set(7, carry);
    
    return [
        state.with {
            `State.registerA`->val,
            `State.carry`->carry,
            `State.programCounter`->state.programCounter + rotateAccumulatorRight.size
        },
        4
    ];
}

[State, Integer] emulateStoreAccumulatorDirect(State state) {
    value address = dataWord(state);
    
    return [
        state.with {
            `State.programCounter`->state.programCounter + storeAccumulatorDirect.size,
            address->state.registerA
        },
        13
    ];
}

[State, Integer] emulateSubtractImmediate(Boolean withBorrow)(State state) {
    value left = state.registerA;
    value right = dataByte(state);
    value result = left.unsigned - right.unsigned - (withBorrow && state.carry then 1 else 0);
    value resultByte = result.byte;
    
    return [
        state.with {
            `State.registerA`->result.byte,
            `State.carry`->flagCarry(result),
            `State.parity`->flagParity(resultByte),
            `State.auxiliaryCarry`->flagAuxiliaryCarry(left, right, resultByte),
            `State.zero`->flagZero(resultByte),
            `State.sign`->flagSign(resultByte),
            `State.programCounter`->state.programCounter + addImmediate.size
        },
        7
    ];
}

[State, Integer] emulateXorImmediate(State state) {
    value result = state.registerA.xor(dataByte(state));
    
    return [
        state.with {
            `State.registerA`->result,
            `State.carry`->false,
            `State.parity`->flagParity(result),
            `State.zero`->flagZero(result),
            `State.sign`->flagSign(result),
            `State.programCounter`->state.programCounter + xorImmediate.size
        },
        7
    ];
}

[State, Integer] emulateXorRegister(ByteRegister register)(Opcode opcode, State state) {
    value result = state.registerA.xor(register.bind(state).get());
    
    return [
        state.with {
            `State.registerA`->result,
            `State.carry`->false,
            `State.parity`->flagParity(result),
            `State.auxiliaryCarry`->false,
            `State.zero`->flagZero(result),
            `State.sign`->flagSign(result),
            `State.programCounter`->state.programCounter + opcode.size
        },
        4
    ];
}
