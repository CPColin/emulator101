import ceylon.language.meta.model {
    Attribute
}
import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State,
    emulate,
    word
}

Integer memorySize = #200;

Array<Byte> testMemory(Byte|Integer* bytes) {
    value memory = Array<Byte>.ofSize(memorySize, #ff.byte);
    
    for (address->val in bytes.indexed) {
        memory[address] = if (is Integer val) then val.byte else val;
    }
    
    return memory;
}

State testState(
    Array<Byte> memory,
    Byte registerA = 0.byte,
    Byte registerB = 0.byte,
    Byte registerC = 0.byte,
    Byte registerD = 0.byte,
    Byte registerE = 0.byte,
    Byte registerH = 0.byte,
    Byte registerL = 0.byte,
    Boolean carry = false,
    Boolean parity = false,
    Boolean auxiliaryCarry = false,
    Boolean zero = false,
    Boolean sign = false,
    Integer stackPointer = 0,
    Integer programCounter = 0) => State {
    registerA = registerA;
    registerB = registerB;
    registerC = registerC;
    registerD = registerD;
    registerE = registerE;
    registerH = registerH;
    registerL = registerL;
    flags = State.packFlags {
        carry = carry;
        parity = parity;
        auxiliaryCarry = auxiliaryCarry;
        zero = zero;
        sign = sign;
    };
    stackPointer = stackPointer;
    programCounter = programCounter;
    memory = memory;
};

abstract class DoNotCheck() of doNotCheck {}

object doNotCheck extends DoNotCheck() {}

void assertFlags(
        State startState,
        State endState,
        Boolean expectedCarry = startState.carry,
        Boolean expectedParity = startState.parity,
        Boolean|DoNotCheck expectedAuxiliaryCarry = doNotCheck,
        Boolean expectedZero = startState.zero,
        Boolean expectedSign = startState.sign) {
    assertEquals(endState.carry, expectedCarry);
    assertEquals(endState.parity, expectedParity);
    assertEquals(endState.zero, expectedZero);
    assertEquals(endState.sign, expectedSign);
    
    if (is Boolean expectedAuxiliaryCarry) {
        assertEquals(endState.auxiliaryCarry, expectedAuxiliaryCarry);
    }
}

void assertMemoriesEqual(State startState, State endState, <Integer->Byte>* except) {
    value exceptMap = map(except);
    
    for (address in 0:startState.memory.size) {
        if (exists exceptVal = exceptMap[address]) {
            assertEquals(endState.memory[address], exceptVal);
        } else {
            assertEquals(endState.memory[address], startState.memory[address]);
        }
    }
}

"Asserts that all fields of the given states are equal, other than the given exceptions."
void assertStatesEqual(State startState, State endState, Attribute<State>* except) {
    if (!except.contains(`State.registerA`)) {
        assertEquals(endState.registerA, startState.registerA);
    }
    
    if (!except.contains(`State.registerB`)) {
        assertEquals(endState.registerB, startState.registerB);
    }
    
    if (!except.contains(`State.registerC`)) {
        assertEquals(endState.registerC, startState.registerC);
    }
    
    if (!except.contains(`State.registerD`)) {
        assertEquals(endState.registerD, startState.registerD);
    }
    
    if (!except.contains(`State.registerE`)) {
        assertEquals(endState.registerE, startState.registerE);
    }
    
    if (!except.contains(`State.registerH`)) {
        assertEquals(endState.registerH, startState.registerH);
    }
    
    if (!except.contains(`State.registerL`)) {
        assertEquals(endState.registerL, startState.registerL);
    }
    
    if (!except.contains(`State.flags`)) {
        assertEquals(endState.flags, startState.flags);
    }
    
    if (!except.contains(`State.stackPointer`)) {
        assertEquals(endState.stackPointer, startState.stackPointer);
    }
    
    if (!except.contains(`State.programCounter`)) {
        assertEquals(endState.programCounter, startState.programCounter);
    }
    
    if (!except.contains(`State.memory`)) {
        assertEquals(endState.memory, startState.memory);
    }
}

test
shared void testEmulateNoop() {
    value startState = testState {
        memory = testMemory(#00);
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateDecrementBParameters = [
    [#01, #00, true, true, false],
    [#10, #0f, false, false, false],
    [#00, #ff, false, false, true],
    [#f1, #f0, true, false, true]
];

test
parameters(`value testEmulateDecrementBParameters`)
shared void testEmulateDecrementB(Integer startB, Integer expectedB, Boolean expectedParity,
        Boolean expectedZero, Boolean expectedSign) {
    value memory = testMemory(#05);
    value startState = testState {
        memory = memory;
        registerB = startB.byte;
        carry = true;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerB`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerB, expectedB.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateMoveImmediateB() {
    value data = #4f.byte;
    value memory = testMemory(#06, data);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.registerB`, `State.programCounter`);
    assertEquals(endState.registerB, data);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateLoadPairImmediateD() {
    value high = #77.byte;
    value low = #88.byte;
    value memory = testMemory(#11, low, high);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerD`, `State.registerE`, `State.programCounter`);
    assertEquals(endState.registerD, high);
    assertEquals(endState.registerE, low);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Integer, Integer]*} testEmulateIncrementPairDParameters = {
    [#00, #00, #00, #01],
    [#00, #09, #00, #0a],
    [#12, #34, #12, #35],
    [#12, #ff, #13, #00],
    [#ff, #ff, #00, #00]
};

test
parameters(`value testEmulateIncrementPairDParameters`)
shared void testEmulateIncrementPairD(Integer startD, Integer startE,
    Integer expectedD, Integer expectedE) {
    value memory = testMemory(#13);
    value startState = testState {
        memory = memory;
        registerD = startD.byte;
        registerE = startE.byte;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerD`, `State.registerE`, `State.programCounter`);
    assertEquals(endState.registerD, expectedD.byte);
    assertEquals(endState.registerE, expectedE.byte);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateLoadAccumulatorD() {
    value high = #01.byte;
    value low = #23.byte;
    value address = word(high, low);
    value val = #56.byte;
    value memory = testMemory(#1a);
    
    memory[address] = val;
    
    value startState = testState {
        memory = memory;
        registerA = #78.byte;
        registerD = high;
        registerE = low;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, val);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateLoadPairImmediateH() {
    value high = #22.byte;
    value low = #ee.byte;
    value memory = testMemory(#21, low, high);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.programCounter`);
    assertEquals(endState.registerH, high);
    assertEquals(endState.registerL, low);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Integer, Integer]*} testEmulateIncrementPairHParameters = {
    [#00, #00, #00, #01],
    [#00, #09, #00, #0a],
    [#12, #34, #12, #35],
    [#12, #ff, #13, #00],
    [#ff, #ff, #00, #00]
};

test
parameters(`value testEmulateIncrementPairHParameters`)
shared void testEmulateIncrementPairH(Integer startH, Integer startL,
        Integer expectedH, Integer expectedL) {
    value memory = testMemory(#23);
    value startState = testState {
        memory = memory;
        registerH = startH.byte;
        registerL = startL.byte;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.programCounter`);
    assertEquals(endState.registerH, expectedH.byte);
    assertEquals(endState.registerL, expectedL.byte);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateLoadPairImmediateStackPointer() {
    value high = #a6.byte;
    value low = #b7.byte;
    value data = word(high, low);
    value memory = testMemory(#31, low, high);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.stackPointer`, `State.programCounter`);
    assertEquals(endState.stackPointer, data);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateMoveImmediateMemory() {
    value high = #01.byte;
    value low = #45.byte;
    value address = word(high, low);
    value data = #77.byte;
    value memory = testMemory(#36, data);
    value startState = testState {
        memory = memory;
        registerH = high;
        registerL = low;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`, `State.memory`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    assertMemoriesEqual(startState, endState, address->data);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateMoveMemoryA() {
    value high = #01.byte;
    value low = #23.byte;
    value address = word(high, low);
    value val = #33.byte;
    value memory = testMemory(#77);
    value startState = testState {
        memory = memory;
        registerA = val;
        registerH = high;
        registerL = low;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`, `State.memory`);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    assertMemoriesEqual(startState, endState, address->val);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateMoveAH() {
    value data = #23.byte;
    value memory = testMemory(#7c);
    value startState = testState {
        memory = memory;
        registerA = #ff.byte;
        registerH = data;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, data);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

{Boolean*} testEmulateJumpIfNotZeroParameters = `Boolean`.caseValues;

test
parameters(`value testEmulateJumpIfNotZeroParameters`)
shared void testEmulateJumpIfNotZero(Boolean zero) {
    value high = #32.byte;
    value low = #10.byte;
    value address = word(high, low);
    value memory = testMemory(#c2, low, high);
    value startState = testState {
        memory = memory;
        zero = zero;
    };
    value expectedProgramCounter = zero then startState.programCounter + 3 else address;
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, expectedProgramCounter);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateJump() {
    value high = #43.byte;
    value low = #21.byte;
    value address = word(high, low);
    value memory = testMemory(#c3, low, high);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, address);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateReturn() {
    value high = #01.byte;
    value low = #ab.byte;
    value address = word(high, low);
    value startStackPointer = #01cd;
    value memory = testMemory(#c9);
    
    memory[startStackPointer] = low;
    memory[startStackPointer + 1] = high;
    // Simulate the CALL instruction that led us to the RET instruction.
    memory[address] = #cd.byte;
    memory[address + 1] = 0.byte;
    memory[address + 2] = 0.byte;
    
    value startState = testState {
        memory = memory;
        stackPointer = startStackPointer;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.stackPointer`, `State.programCounter`);
    assertEquals(endState.stackPointer, startStackPointer + 2);
    assertEquals(endState.programCounter, address + 3);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateCall() {
    value addressHigh = #33.byte;
    value addressLow = #44.byte;
    value address = word(addressHigh, addressLow);
    value startProgramCounterHigh = #01.byte;
    value startProgramCounterLow = #23.byte;
    value startProgramCounter = word(startProgramCounterHigh, startProgramCounterLow);
    value memory = Array<Byte>.ofSize(#0800, 0.byte);
    
    memory[startProgramCounter] = #cd.byte;
    memory[startProgramCounter + 1] = addressLow;
    memory[startProgramCounter + 2] = addressHigh;
    
    value startState = testState {
        memory = memory;
        stackPointer = memory.size;
        programCounter = startProgramCounter;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.stackPointer`, `State.programCounter`, `State.memory`);
    assertEquals(endState.stackPointer, startState.stackPointer - 2);
    assertEquals(endState.programCounter, address);
    assertMemoriesEqual(startState, endState,
        endState.stackPointer->startProgramCounterLow,
        endState.stackPointer + 1->startProgramCounterHigh);
    
    assertEquals(cycles, 17);
}

{[Integer, Integer, Boolean, Boolean, Boolean, Boolean]*} testEmulateCompareImmediateParameters = {
    [#00, #00, false, true, true, false]
};

test
parameters(`value testEmulateCompareImmediateParameters`)
shared void testEmulateCompareImmediate(Integer registerA, Integer data, Boolean expectedCarry,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value memory = testMemory(#fe, data);
    value startState = testState {
        memory = memory;
        registerA = registerA.byte;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}
