import ceylon.test {
    assertEquals,
    assertFalse,
    assertNull,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    Interrupt,
    State,
    bytes
}

test
shared void testStateDataByte() {
    value data = #36.byte;
    value state = testState {
        opcode = 0;
        testStateProgramCounter + 1->data
    };
    
    assertEquals(state.dataByte, data);
}

test
shared void testStateDataByteOutOfRange() {
    value state = testState {
        opcode = 0;
        `State.programCounter`->testStateMemorySize
    };
    
    assertEquals(state.dataByte, 0.byte);
}

test
shared void testStateDataBytes() {
    value high = #36.byte;
    value low = #df.byte;
    value state = testState {
        opcode = 0;
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    
    assertEquals(state.dataBytes, [high, low]);
}

test
shared void testStateDataBytesOutOfRange() {
    value state = testState {
        opcode = 0;
        `State.programCounter`->testStateMemorySize
    };
    
    assertEquals(state.dataBytes, [0.byte, 0.byte]);
}

test
shared void testStateDataWord() {
    value high = #36.byte;
    value low = #df.byte;
    value state = testState {
        opcode = 0;
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    
    assertEquals(state.dataWord, #36df);
}

test
shared void testStateDataWordOutOfRange() {
    value state = testState {
        opcode = 0;
        `State.programCounter`->testStateMemorySize
    };
    
    assertEquals(state.dataWord, 0);
}

test
shared void testStateOpcode() {
    value opcode = #4b;
    value state = testState {
        opcode = opcode;
    };
    
    assertEquals(state.opcode, opcode.byte);
}

test
shared void testStateOpcodeOutOfRange() {
    value state = testState {
        opcode = 0;
        `State.programCounter`->testStateMemorySize
    };
    
    assertNull(state.opcode);
}

{[Boolean, Boolean, Boolean, Boolean, Boolean, Integer]*} testStatePackFlagsParameters = {
    [false, false, false, false, false, $00000010],
    [false, false, false, false, true, $00000011],
    [false, false, false, true, false, $00000110],
    [false, false, false, true, true, $00000111],
    [false, false, true, false, false, $00010010],
    [false, false, true, false, true, $00010011],
    [false, false, true, true, false, $00010110],
    [false, false, true, true, true, $00010111],
    [false, true, false, false, false, $01000010],
    [false, true, false, false, true, $01000011],
    [false, true, false, true, false, $01000110],
    [false, true, false, true, true, $01000111],
    [false, true, true, false, false, $01010010],
    [false, true, true, false, true, $01010011],
    [false, true, true, true, false, $01010110],
    [false, true, true, true, true, $01010111],
    [true, false, false, false, false, $10000010],
    [true, false, false, false, true, $10000011],
    [true, false, false, true, false, $10000110],
    [true, false, false, true, true, $10000111],
    [true, false, true, false, false, $10010010],
    [true, false, true, false, true, $10010011],
    [true, false, true, true, false, $10010110],
    [true, false, true, true, true, $10010111],
    [true, true, false, false, false, $11000010],
    [true, true, false, false, true, $11000011],
    [true, true, false, true, false, $11000110],
    [true, true, false, true, true, $11000111],
    [true, true, true, false, false, $11010010],
    [true, true, true, false, true, $11010011],
    [true, true, true, true, false, $11010110],
    [true, true, true, true, true, $11010111]
};

test
parameters(`value testStatePackFlagsParameters`)
shared void testStatePackFlags(Boolean sign, Boolean zero, Boolean auxiliaryCarry, Boolean parity,
        Boolean carry, Integer expected) {
    assertEquals(State.packFlags {
        carry = carry;
        parity = parity;
        auxiliaryCarry = auxiliaryCarry;
        zero = zero;
        sign = sign;
    }, expected.byte);
}

test
shared void testStateWithInterrupt() {
    value opcode = #23.byte;
    value interrupt = Interrupt(opcode);
    value startState = testState {
        opcode = 0;
        `State.interruptsEnabled`->true,
        `State.stopped`->true
    };
    value endState = startState.withInterrupt(interrupt);
    
    assertStatesEqual(startState, endState,
        `State.interruptsEnabled`, `State.stopped`, `State.interrupt`);
    assertFalse(endState.interruptsEnabled);
    assertFalse(endState.stopped);
    assertEquals(endState.interrupt, interrupt);
}

test
shared void testStateWithoutInterrupt() {
    value opcode = #23.byte;
    value interrupt = Interrupt(opcode);
    value startState = testState {
        opcode = 0;
    }.withInterrupt(interrupt);
    
    assertEquals(startState.interrupt, interrupt);
    
    value endState = startState.with {};
    
    assertStatesEqual(startState, endState, `State.interrupt`);
    assertNull(endState.interrupt);
}

test
shared void testStateWithStackPointerBytes() {
    value val = #1234;
    value [high, low] = bytes(val);
    value startState = testState {
        opcode = 0;
        `State.stackPointer`->0
    };
    value endState = startState.with {
        `State.stackPointerHigh`->high,
        `State.stackPointerLow`->low
    };
    
    assertStatesEqual(startState, endState, `State.stackPointer`);
    assertEquals(endState.stackPointerHigh, high);
    assertEquals(endState.stackPointerLow, low);
    assertEquals(endState.stackPointer, val);
}

test
shared void testStateWithStackPointerWord() {
    value val = #1234;
    value [high, low] = bytes(val);
    value startState = testState {
        opcode = 0;
        `State.stackPointer`->0
    };
    value endState = startState.with {
        `State.stackPointer`->val
    };
    
    assertStatesEqual(startState, endState, `State.stackPointer`);
    assertEquals(endState.stackPointerHigh, high);
    assertEquals(endState.stackPointerLow, low);
    assertEquals(endState.stackPointer, val);
}

test
shared void testStateUpdateMemorySingle() {
    value size = 8;
    value fill = #ff.byte;
    value poke = 3;
    value val = #ad.byte;
    value memory = State.updateMemory(Array<Byte>.ofSize(size, fill), poke->val);
    
    for (address in 0:size) {
        if (address == poke) {
            assertEquals(memory[address], val);
        } else {
            assertEquals(memory[address], fill);
        }
    }
}

test
shared void testStateUpdateMemoryMultiple() {
    value size = 8;
    value fill = #ff.byte;
    value poke1 = 3;
    value val1 = #ad.byte;
    value poke2 = 7;
    value val2 = #99.byte;
    value memory = State.updateMemory(Array<Byte>.ofSize(size, fill), poke1->val1, poke2->val2);
    
    for (address in 0:size) {
        if (address == poke1) {
            assertEquals(memory[address], val1);
        } else if (address == poke2) {
            assertEquals(memory[address], val2);
        } else {
            assertEquals(memory[address], fill);
        }
    }
}
