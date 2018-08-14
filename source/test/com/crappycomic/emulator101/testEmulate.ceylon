import ceylon.language.meta.model {
    Attribute
}
import ceylon.test {
    assertEquals,
    ignore,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State,
    bytes,
    emulate,
    word
}

// TODO: It would be nice to fuzz the program counter a bit, so we don't run the risk of
// accidentally relying on an instruction being at $0000.

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
        Byte registerA = #f0.byte, // Try a little fuzziness
        Byte registerB = #f1.byte,
        Byte registerC = #f2.byte,
        Byte registerD = #f3.byte,
        Byte registerE = #f4.byte,
        Byte registerH = #f5.byte,
        Byte registerL = #f6.byte,
        Boolean carry = true,
        Boolean parity = true,
        Boolean auxiliaryCarry = true,
        Boolean zero = true,
        Boolean sign = true,
        Integer stackPointer = #0100,
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
        assertEquals(endState.registerA, startState.registerA,
            "Register A should not have changed.");
    }
    
    if (!except.contains(`State.registerB`)) {
        assertEquals(endState.registerB, startState.registerB,
            "Register B should not have changed.");
    }
    
    if (!except.contains(`State.registerC`)) {
        assertEquals(endState.registerC, startState.registerC,
            "Register C should not have changed.");
    }
    
    if (!except.contains(`State.registerD`)) {
        assertEquals(endState.registerD, startState.registerD,
            "Register D should not have changed.");
    }
    
    if (!except.contains(`State.registerE`)) {
        assertEquals(endState.registerE, startState.registerE,
            "Register E should not have changed.");
    }
    
    if (!except.contains(`State.registerH`)) {
        assertEquals(endState.registerH, startState.registerH,
            "Register H should not have changed.");
    }
    
    if (!except.contains(`State.registerL`)) {
        assertEquals(endState.registerL, startState.registerL,
            "Register L should not have changed.");
    }
    
    if (!except.contains(`State.flags`)) {
        assertEquals(endState.flags, startState.flags,
            "Processor flags should not have changed.");
    }
    
    if (!except.contains(`State.stackPointer`)) {
        assertEquals(endState.stackPointer, startState.stackPointer,
            "Stack pointer should not have changed.");
    }
    
    if (!except.contains(`State.programCounter`)) {
        assertEquals(endState.programCounter, startState.programCounter,
            "Program counter should not have changed. (Really?)");
    }
    
    if (!except.contains(`State.memory`)) {
        assertEquals(endState.memory, startState.memory,
            "Memory should not have changed.");
    }
}

test
ignore
shared void testAllOpcodesTested() {
    // TODO: Switch on Opcode so we can't forget to add at leat one test for each one.
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

void assertLoadPairImmediate(State startState, Byte high, Byte low,
        Attribute<State, Byte> highAttribute, Attribute<State, Byte> lowAttribute) {
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        highAttribute, lowAttribute, `State.programCounter`);
    assertEquals(highAttribute.bind(endState).get(), high);
    assertEquals(lowAttribute.bind(endState).get(), low);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateLoadPairImmediateB() {
    value high = #33.byte;
    value low = #ff.byte;
    value memory = testMemory(#01, low, high);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerB`, `State.registerC`, `State.programCounter`);
    assertEquals(endState.registerB, high);
    assertEquals(endState.registerC, low);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateDecrementRegisterParameters = [
    [#01, #00, true, true, false],
    [#10, #0f, false, false, false],
    [#00, #ff, false, false, true],
    [#f1, #f0, true, false, true]
];

void assertDecrementRegister(State startState, Attribute<State, Byte> registerAttribute,
        Integer expectedRegister, Boolean expectedParity, Boolean expectedZero,
        Boolean expectedSign) {
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        registerAttribute, `State.flags`, `State.programCounter`);
    assertEquals(registerAttribute.bind(endState).get(), expectedRegister.byte);
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
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementB(Integer startB, Integer expectedB, Boolean expectedParity,
        Boolean expectedZero, Boolean expectedSign) {
    value memory = testMemory(#05);
    value startState = testState {
        memory = memory;
        registerB = startB.byte;
    };
    
    assertDecrementRegister {
        startState = startState;
        registerAttribute = `State.registerB`;
        expectedRegister = expectedB;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

void testEmulateMoveImmediateRegister(Integer opcode, Attribute<State, Byte> registerAttribute) {
    value data = #4f.byte;
    value memory = testMemory(opcode, data);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, registerAttribute, `State.programCounter`);
    assertEquals(registerAttribute.bind(endState).get(), data);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateMoveImmediateB() {
    testEmulateMoveImmediateRegister(#06, `State.registerB`);
}

{[Integer, Integer, Integer, Boolean]*} testEmulateDoubleAddBParameters = {
    [#0000, #0000, #0000, false],
    [#0123, #4567, #468a, false],
    [#abcd, #a000, #4bcd, true]
};

test
parameters(`value testEmulateDoubleAddBParameters`)
shared void testEmulateDoubleAddB(Integer hlValue, Integer bcValue, Integer expectedValue,
    Boolean expectedCarry) {
    value memory = testMemory(#09);
    value [registerH, registerL] = bytes(hlValue);
    value [registerB, registerC] = bytes(bcValue);
    value [expectedH, expectedL] = bytes(expectedValue);
    value startState = testState {
        memory = memory;
        registerB = registerB;
        registerC = registerC;
        registerH = registerH;
        registerL = registerL;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerH, expectedH);
    assertEquals(endState.registerL, expectedL);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Integer, Boolean]*} testEmulateDoubleAddDParameters = {
    [#0000, #0000, #0000, false],
    [#0123, #4567, #468a, false],
    [#abcd, #a000, #4bcd, true]
};

test
parameters(`value testEmulateDoubleAddDParameters`)
shared void testEmulateDoubleAddD(Integer hlValue, Integer deValue, Integer expectedValue,
    Boolean expectedCarry) {
    value memory = testMemory(#19);
    value [registerH, registerL] = bytes(hlValue);
    value [registerD, registerE] = bytes(deValue);
    value [expectedH, expectedL] = bytes(expectedValue);
    value startState = testState {
        memory = memory;
        registerD = registerD;
        registerE = registerE;
        registerH = registerH;
        registerL = registerL;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerH, expectedH);
    assertEquals(endState.registerL, expectedL);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Boolean]*} testEmulateDoubleAddHParameters = {
    [#0000, #0000, false],
    [#0123, #0246, false],
    [#abcd, #579a, true]
};

test
parameters(`value testEmulateDoubleAddHParameters`)
shared void testEmulateDoubleAddH(Integer startValue, Integer expectedValue,
        Boolean expectedCarry) {
    value memory = testMemory(#29);
    value [startH, startL] = bytes(startValue);
    value [expectedH, expectedL] = bytes(expectedValue);
    value startState = testState {
        memory = memory;
        registerH = startH;
        registerL = startL;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerH, expectedH);
    assertEquals(endState.registerL, expectedL);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementC(Integer startC, Integer expectedC, Boolean expectedParity,
        Boolean expectedZero, Boolean expectedSign) {
    value memory = testMemory(#0d);
    value startState = testState {
        memory = memory;
        registerC = startC.byte;
    };
    
    assertDecrementRegister {
        startState = startState;
        registerAttribute = `State.registerC`;
        expectedRegister = expectedC;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
shared void testEmulateMoveImmediateC() {
    testEmulateMoveImmediateRegister(#0e, `State.registerC`);
}

test
shared void testEmulateLoadPairImmediateD() {
    value high = #77.byte;
    value low = #88.byte;
    value memory = testMemory(#11, low, high);
    value startState = testState {
        memory = memory;
    };
    
    assertLoadPairImmediate(startState, high, low, `State.registerD`, `State.registerE`);
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
    
    assertLoadPairImmediate(startState, high, low, `State.registerH`, `State.registerL`);
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

void assertMoveRegisters(State startState, Byte data,
        Attribute<State, Byte> registerAttribute) {
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, registerAttribute, `State.programCounter`);
    assertEquals(registerAttribute.bind(endState).get(), data);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);

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
    
    assertMoveRegisters(startState, data, `State.registerA`);
}

test
shared void testEmulateMoveLA() {
    value data = #34.byte;
    value memory = testMemory(#6f);
    value startState = testState {
        memory = memory;
        registerA = data;
        registerL = #ff.byte;
    };
    
    assertMoveRegisters(startState, data, `State.registerL`);
}

void testEmulatePop(Integer opcode, Attribute<State, Byte> registerHigh,
        Attribute<State, Byte> registerLow) {
    value high = #aa.byte;
    value low = #bb.byte;
    value memory = testMemory(opcode);
    value startStackPointer = #0100;
    
    memory[startStackPointer] = low;
    memory[startStackPointer + 1] = high;
    
    value startState = testState {
        memory = memory;
        stackPointer = startStackPointer;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        registerHigh, registerLow, `State.stackPointer`, `State.programCounter`);
    assertEquals(registerHigh.bind(endState).get(), high);
    assertEquals(registerLow.bind(endState).get(), low);
    assertEquals(endState.stackPointer, startStackPointer + 2);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulatePopB() {
    testEmulatePop(#c1, `State.registerB`, `State.registerC`);
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

void assertPush(State startState, Byte high, Byte low) {
    value startStackPointer = startState.stackPointer;
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.memory`, `State.stackPointer`, `State.programCounter`);
    assertMemoriesEqual(startState, endState,
        startStackPointer - 1->high,
        startStackPointer - 2->low);
    assertEquals(endState.stackPointer, startStackPointer - 2);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 11);
}

test
shared void testEmulatePushB() {
    value high = #98.byte;
    value low = #76.byte;
    value memory = testMemory(#c5);
    value startState = testState {
        memory = memory;
        registerB = high;
        registerC = low;
        stackPointer = #0100;
    };
    
    assertPush(startState, high, low);
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

test
shared void testEmulatePopD() {
    testEmulatePop(#d1, `State.registerD`, `State.registerE`);
}

test
shared void testOutput() {
    value memory = testMemory(#d3);
    value startState = testState {
        memory = memory;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulatePushD() {
    value high = #12.byte;
    value low = #34.byte;
    value memory = testMemory(#d5);
    value startState = testState {
        memory = memory;
        registerD = high;
        registerE = low;
        stackPointer = #0100;
    };
    
    assertPush(startState, high, low);
}

test
shared void testEmulatePopH() {
    testEmulatePop(#e1, `State.registerH`, `State.registerL`);
}

test
shared void testEmulatePushH() {
    value high = #23.byte;
    value low = #45.byte;
    value memory = testMemory(#e5);
    value startState = testState {
        memory = memory;
        registerH = high;
        registerL = low;
        stackPointer = #0100;
    };
    
    assertPush(startState, high, low);
}

test
shared void testExchangeRegisters() {
    value [startH, startL] = bytes(#1234);
    value [startD, startE] = bytes(#5678);
    value memory = testMemory(#eb);
    value startState = testState {
        memory = memory;
        registerD = startD;
        registerE = startE;
        registerH = startH;
        registerL = startL;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.registerD`, `State.registerE`, `State.registerH`,
        `State.registerL`, `State.programCounter`);
    assertEquals(endState.registerD, startH);
    assertEquals(endState.registerE, startL);
    assertEquals(endState.registerH, startD);
    assertEquals(endState.registerL, startE);
    
    assertEquals(cycles, 5);
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
