import ceylon.language.meta.model {
    Attribute
}

alias RegisterGet => Attribute<State, Byte>;

"Emulates execution of the next instruction, given the current [[state]] of the CPU and memory.
 Returns the new state and the number of cycles the instruction took."
shared [State, Integer] emulate(State state) {
    value val = state.memory[state.programCounter];
    
    assert (exists val);
    
    value opcode = opcodes[val];
    
    assert (exists opcode);
    
    value emulator = switch (opcode)
        case (noop) emulateNoop
        case (loadPairImmediateB) emulateLoadPairImmediateB
        case (decrementB) emulateDecrementB
        case (moveImmediateB) emulateMoveImmediateB
        case (rotateAccumulatorLeft) nothing
        case (doubleAddB) emulateDoubleAdd(`State.registerB`, `State.registerC`)
        case (decrementC) emulateDecrementC
        case (moveImmediateC) emulateMoveImmediateC
        case (rotateAccumulatorRight) nothing
        case (loadPairImmediateD) emulateLoadPairImmediateD
        case (incrementPairD) emulateIncrementPairD
        case (moveImmediateD) nothing
        case (doubleAddD) emulateDoubleAdd(`State.registerD`, `State.registerE`)
        case (loadAccumulatorD) emulateLoadAccumulatorD
        case (loadPairImmediateH) emulateLoadPairImmediateH
        case (storeHLDirect) nothing
        case (incrementPairH) emulateIncrementPairH
        case (moveImmediateH) emulateMoveImmediateH
        case (decimalAdjust) nothing
        case (doubleAddH) emulateDoubleAdd(`State.registerH`, `State.registerL`)
        case (loadHLDirect) nothing
        case (decrementPairH) nothing
        case (loadPairImmediateStackPointer) emulateLoadPairImmediateStackPointer
        case (storeA) nothing
        case (decrementMemory) nothing
        case (moveImmediateMemory) emulateMoveImmediateMemory
        case (loadAccumulatorDirect) nothing
        case (incrementA) nothing
        case (decrementA) nothing
        case (moveImmediateA) nothing
        case (moveBB) nothing
        case (moveBC) nothing
        case (moveBD) nothing
        case (moveBE) nothing
        case (moveBH) nothing
        case (moveBL) nothing
        case (moveBMemory) nothing
        case (moveBA) nothing
        case (moveCB) nothing
        case (moveCC) nothing
        case (moveCD) nothing
        case (moveCE) nothing
        case (moveCH) nothing
        case (moveCL) nothing
        case (moveCMemory) nothing
        case (moveCA) nothing
        case (moveDB) nothing
        case (moveDC) nothing
        case (moveDD) nothing
        case (moveDE) nothing
        case (moveDH) nothing
        case (moveDL) nothing
        case (moveDMemory) nothing
        case (moveDA) nothing
        case (moveEB) nothing
        case (moveEC) nothing
        case (moveED) nothing
        case (moveEE) nothing
        case (moveEH) nothing
        case (moveEL) nothing
        case (moveEMemory) nothing
        case (moveEA) nothing
        case (moveHB) nothing
        case (moveHC) nothing
        case (moveHD) nothing
        case (moveHE) nothing
        case (moveHH) nothing
        case (moveHL) nothing
        case (moveHMemory) nothing
        case (moveHA) nothing
        case (moveLB) nothing
        case (moveLC) nothing
        case (moveLD) nothing
        case (moveLE) nothing
        case (moveLH) nothing
        case (moveLL) nothing
        case (moveLMemory) nothing
        case (moveLA) emulateMoveLRegister(`State.registerA`)
        case (moveMemoryB) nothing
        case (moveMemoryC) nothing
        case (moveMemoryD) nothing
        case (moveMemoryE) nothing
        case (moveMemoryH) nothing
        case (moveMemoryL) nothing
        case (halt) nothing
        case (moveMemoryA) emulateMoveMemoryA
        case (moveAB) nothing
        case (moveAC) nothing
        case (moveAD) nothing
        case (moveAE) nothing
        case (moveAH) emulateMoveAH
        case (moveAL) nothing
        case (moveAMemory) nothing
        case (moveAA) nothing
        case (andB) nothing
        case (andC) nothing
        case (andD) nothing
        case (andE) nothing
        case (andH) nothing
        case (andL) nothing
        case (andMemory) nothing
        case (andA) nothing
        case (xorA) nothing
        case (returnIfNotZero) nothing
        case (popB) emulatePopB
        case (jumpIfNotZero) emulateJumpIfNotZero
        case (jump) emulateJump
        case (callIfNotZero) nothing
        case (pushB) emulatePush(`State.registerB`, `State.registerC`)
        case (addImmediate) nothing
        case (returnIfZero) nothing
        case (\ireturn) emulateReturn
        case (jumpIfZero) nothing
        case (callIfZero) nothing
        case (call) emulateCall
        case (popD) emulatePopD
        case (jumpIfNoCarry) nothing
        case (output) emulateOutput
        case (pushD) emulatePush(`State.registerD`, `State.registerE`)
        case (jumpIfCarry) nothing
        case (input) nothing
        case (popH) emulatePopH
        case (pushH) emulatePush(`State.registerH`, `State.registerL`)
        case (andImmediate) nothing
        case (exchangeRegisters) emulateExchangeRegisters
        case (popStatus) nothing
        case (disableInterrupts) nothing
        case (pushStatus) nothing
        case (jumpIfMinus) nothing
        case (enableInterrupts) nothing
        case (compareImmediate) emulateCompareImmediate;
    
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

shared Boolean flagParity(Byte val) => !val.get(0);

shared Boolean flagSign(Byte val) => val.get(7);

shared Boolean flagZero(Byte val) => val.zero;

[State, Integer] emulateNoop(State state) {
    return [
        state.with {
            programCounter = state.programCounter + noop.size;
        },
        4
    ];
}

[State, Integer] emulateLoadPairImmediateB(State state) {
    value [high, low] = dataBytes(state);
    
    return [
        state.with {
            registerB = high;
            registerC = low;
            programCounter = state.programCounter + loadPairImmediateB.size;
        },
        10
    ];
}

[State, Integer] emulateDecrementB(State state) {
    value val = state.registerB.predecessor;
    
    return [
        state.with {
            registerB = val;
            parity = flagParity(val);
            auxiliaryCarry = flagAuxiliaryCarry(state.registerB, 1.byte, val);
            zero = flagZero(val);
            sign = flagSign(val);
            programCounter = state.programCounter + decrementB.size;
        },
        5
    ];
}

[State, Integer] emulateMoveImmediateB(State state) {
    return [
        state.with {
            registerB = dataByte(state);
            programCounter = state.programCounter + moveImmediateB.size;
        },
        5
    ];
}

[State, Integer] emulateDoubleAdd(RegisterGet highAttribute, RegisterGet lowAttribute)
        (Opcode opcode, State state) {
    value registerHL = word(state.registerH, state.registerL);
    value addend = word {
        high = highAttribute.bind(state).get();
        low = lowAttribute.bind(state).get();
    };
    value result = registerHL + addend;
    value [resultHigh, resultLow] = bytes(result);
    
    return [
        state.with {
            registerH = resultHigh;
            registerL = resultLow;
            carry = result.get(16);
            programCounter = state.programCounter + opcode.size;
        },
        10
    ];
}

[State, Integer] emulateDecrementC(State state) {
    value val = state.registerC.predecessor;
    
    return [
        state.with {
            registerC = val;
            parity = flagParity(val);
            auxiliaryCarry = flagAuxiliaryCarry(state.registerC, 1.byte, val);
            zero = flagZero(val);
            sign = flagSign(val);
            programCounter = state.programCounter + decrementB.size;
        },
        5
    ];
}

[State, Integer] emulateMoveImmediateC(State state) {
    return [
        state.with {
            registerC = dataByte(state);
            programCounter = state.programCounter + moveImmediateC.size;
        },
        5
    ];
}

[State, Integer] emulateLoadPairImmediateD(State state) {
    value [high, low] = dataBytes(state);
    
    return [
        state.with {
            registerD = high;
            registerE = low;
            programCounter = state.programCounter + loadPairImmediateD.size;
        },
        10
    ];
}

[State, Integer] emulateIncrementPairD(State state) {
    value pairD = word(state.registerD, state.registerE);
    value [high, low] = bytes(pairD + 1);
    
    return [
        state.with {
            registerD = high;
            registerE = low;
            programCounter = state.programCounter + incrementPairD.size;
        },
        5
    ];
}

[State, Integer] emulateLoadAccumulatorD(State state) {
    value address = word(state.registerD, state.registerE);
    
    return [
        state.with {
            registerA = state.memory[address] else 0.byte;
            programCounter = state.programCounter + loadAccumulatorD.size;
        },
        7
    ];
}

[State, Integer] emulateLoadPairImmediateH(State state) {
    value [high, low] = dataBytes(state);
    
    return [
        state.with {
            registerH = high;
            registerL = low;
            programCounter = state.programCounter + loadPairImmediateD.size;
        },
        10
    ];
}

[State, Integer] emulateIncrementPairH(State state) {
    value pairH = word(state.registerH, state.registerL);
    value [high, low] = bytes(pairH + 1);
    
    return [
        state.with {
            registerH = high;
            registerL = low;
            programCounter = state.programCounter + incrementPairH.size;
        },
        5
    ];
}

[State, Integer] emulateMoveImmediateH(State state) {
    return [
        state.with {
            registerH = dataByte(state);
            programCounter = state.programCounter + moveImmediateH.size;
        },
        5
    ];
}

[State, Integer] emulateLoadPairImmediateStackPointer(State state) {
    return [
        state.with {
            stackPointer = dataWord(state);
            programCounter = state.programCounter + loadPairImmediateStackPointer.size;
        },
        10
    ];
}

[State, Integer] emulateMoveImmediateMemory(State state) {
    value high = state.registerH;
    value low = state.registerL;
    value address = word(high, low);
    
    return [
        state.with {
            programCounter = state.programCounter + moveImmediateMemory.size;
            address->dataByte(state)
        },
        10
    ];
}

[State, Integer] emulateMoveLRegister(RegisterGet registerAttribute)
        (Opcode opcode, State state) {
    return [
        state.with {
            registerL = registerAttribute.bind(state).get();
            programCounter = state.programCounter + opcode.size;
        },
        5
    ];
}

[State, Integer] emulateMoveMemoryA(State state) {
    value address = word(state.registerH, state.registerL);
    
    return [
        state.with {
            programCounter = state.programCounter + moveMemoryA.size;
            address->state.registerA
        },
        7
    ];
}

[State, Integer] emulateMoveAH(State state) {
    return [
        state.with {
            registerA = state.registerH;
            programCounter = state.programCounter + moveAH.size;
        },
        5
    ];
}

[State, Integer] emulatePopB(State state) {
    value high = state.memory[state.stackPointer + 1];
    value low = state.memory[state.stackPointer];
    
    assert (exists high, exists low);
    
    return [
        state.with {
            registerB = high;
            registerC = low;
            stackPointer = state.stackPointer + 2;
            programCounter = state.programCounter + popB.size;
        },
        10
    ];
}

[State, Integer] emulateJumpIfNotZero(State state) {
    value address = state.zero then state.programCounter + jumpIfNotZero.size else dataWord(state);
    
    return [
        state.with {
            programCounter = address;
        },
        10
    ];
}

[State, Integer] emulateJump(State state) {
    return [
        state.with {
            programCounter = dataWord(state);
        },
        10
    ];
}

[State, Integer] emulateReturn(State state) {
    value address = word {
        high = state.memory[state.stackPointer + 1];
        low = state.memory[state.stackPointer];
    };
    value val = state.memory[address];
    
    assert (exists val);
    
    value opcode = opcodes[val];
    
    assert (exists opcode);
    
    return [
        state.with {
            stackPointer = state.stackPointer + 2;
            programCounter = address + opcode.size;
        },
        10
    ];
}

[State, Integer] emulateCall(State state) {
    value [high, low] = bytes(state.programCounter);
    value address = dataWord(state);
    
    return [
        state.with {
            programCounter = address;
            stackPointer = state.stackPointer - 2;
            state.stackPointer - 1->high,
            state.stackPointer - 2->low
        },
        17
    ];
}

[State, Integer] emulatePopD(State state) {
    value high = state.memory[state.stackPointer + 1];
    value low = state.memory[state.stackPointer];
    
    assert (exists high, exists low);
    
    return [
        state.with {
            registerD = high;
            registerE = low;
            stackPointer = state.stackPointer + 2;
            programCounter = state.programCounter + popD.size;
        },
        10
    ];
}

[State, Integer] emulateOutput(State state) {
    // TODO: Hook into system hardware.
    return [
        state.with {
            programCounter = state.programCounter + output.size;
        },
        10
    ];
}

[State, Integer] emulatePush(RegisterGet highAttribute, RegisterGet lowAttribute)
        (Opcode opcode, State state) {
    value high = highAttribute.bind(state).get();
    value low = lowAttribute.bind(state).get();
    
    return [
        state.with {
            stackPointer = state.stackPointer - 2;
            programCounter = state.programCounter + opcode.size;
            state.stackPointer - 1->high,
            state.stackPointer - 2->low
        },
        11
    ];
}

[State, Integer] emulatePopH(State state) {
    value high = state.memory[state.stackPointer + 1];
    value low = state.memory[state.stackPointer];
    
    assert (exists high, exists low);
    
    return [
        state.with {
            registerH = high;
            registerL = low;
            stackPointer = state.stackPointer + 2;
            programCounter = state.programCounter + popH.size;
        },
        10
    ];
}

[State, Integer] emulateExchangeRegisters(State state) {
    return [
        state.with {
            registerD = state.registerH;
            registerE = state.registerL;
            registerH = state.registerD;
            registerL = state.registerE;
            programCounter = state.programCounter + exchangeRegisters.size;
        },
        5
    ];
}

[State, Integer] emulateCompareImmediate(State state) {
    value left = state.registerA;
    value right = dataByte(state);
    value result = left.unsigned - right.unsigned;
    value resultByte = result.byte;
    
    return [
        state.with {
            carry = flagCarry(result);
            parity = flagParity(resultByte);
            auxiliaryCarry = flagAuxiliaryCarry(left, right, result.byte);
            zero = flagZero(resultByte);
            sign = flagSign(resultByte);
            programCounter = state.programCounter + compareImmediate.size;
        },
        7
    ];
}
