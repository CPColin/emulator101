import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    emulate,
    flagAuxiliaryCarry,
    flagParity,
    flagSign,
    flagZero,
    word
}

{[Integer, Integer, Boolean, Boolean, Boolean, Boolean]*} testEmulateIncrementRegisterParameters = {
    [#00, #01, false, false, false, false],
    [#01, #02, false, false, false, false],
    [#0f, #10, false, true, false, false],
    [#7f, #80, false, true, false, true],
    [#80, #81, true, false, false, true],
    [#ff, #00, true, true, true, false]
};

void testEmulateIncrementRegister(Integer opcode, ByteRegister register, Integer start,
        Integer expected, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = opcode;
        register->start.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, register, `State.flags`, `State.programCounter`);
    assertEquals(register.bind(endState).get(), expected.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementA(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #3c;
        register = `State.registerA`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementB(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #04;
        register = `State.registerB`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementC(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #0c;
        register = `State.registerC`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementD(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #14;
        register = `State.registerD`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementE(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #1c;
        register = `State.registerE`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementH(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #24;
        register = `State.registerH`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateIncrementRegisterParameters`)
shared void testEmulateIncrementL(Integer start, Integer expected, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    testEmulateIncrementRegister {
        opcode = #2c;
        register = `State.registerL`;
        start = start;
        expected = expected;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testRegisterParameters`) // Eh, close enough.
shared void testEmulateIncrementMemory(Byte memoryValue) {
    value high = #01.byte;
    value low = #89.byte;
    value address = word(high, low);
    value result = memoryValue.successor;
    value startState = testState {
        opcode = #34;
        `State.registerH`->high,
        `State.registerL`->low,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.memory`, `State.flags`, `State.programCounter`);
    assertMemoriesEqual(startState, endState, address->result);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = flagParity(result);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(memoryValue, 1.byte, result);
        expectedZero = flagZero(result);
        expectedSign = flagSign(result);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Integer, Integer]*} testEmulateIncrementPairParameters = {
    [#00, #00, #00, #01],
    [#00, #09, #00, #0a],
    [#12, #34, #12, #35],
    [#12, #ff, #13, #00],
    [#ff, #ff, #00, #00]
};

void testEmulateIncrementPair(Integer opcode, ByteRegister register1, ByteRegister register2,
        Integer start1, Integer start2, Integer expected1, Integer expected2) {
    value startState = testState {
        opcode = opcode;
        register1->start1.byte,
        register2->start2.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        register1, register2, `State.programCounter`);
    assertEquals(register1.bind(endState).get(), expected1.byte);
    assertEquals(register2.bind(endState).get(), expected2.byte);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairB(Integer start1, Integer start2,
        Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #03;
        register1 = `State.registerB`;
        register2 = `State.registerC`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairD(Integer start1, Integer start2,
        Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #13;
        register1 = `State.registerD`;
        register2 = `State.registerE`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairH(Integer start1, Integer start2,
        Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #23;
        register1 = `State.registerH`;
        register2 = `State.registerL`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}
