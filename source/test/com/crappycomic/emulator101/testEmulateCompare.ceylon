import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    bytes,
    emulate,
    flagCarry,
    flagParity,
    flagSign,
    flagZero
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateCompareA(Byte registerValue) {
    value startState = testState {
        opcode = #bf;
        `State.registerA`->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = true;
        expectedZero = true;
        expectedSign = false;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Boolean, Boolean, Boolean, Boolean]*} testEmulateCompareImmediateParameters = {
    [#00, #00, false, true, true, false],
    [#01, #00, false, false, false, false],
    [#00, #01, true, true, false, true],
    [#00, #02, true, false, false, true],
    [#a0, #a0, false, true, true, false],
    [#ff, #fe, false, false, false, false],
    [#ff, #01, false, false, false, true]
};

test
parameters(`value testEmulateCompareImmediateParameters`)
shared void testEmulateCompareImmediate(Integer registerA, Integer data, Boolean expectedCarry,
    Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #fe;
        `State.registerA`->registerA.byte,
        testStateProgramCounter + 1->data.byte
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

void testEmulateCompareRegister(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue) {
    value result = registerA.unsigned - registerValue.unsigned;
    value resultByte = result.byte;
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA,
        register->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Byte, Byte]*} testEmulateCompareRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareB(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #b8;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareC(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #b9;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareD(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #ba;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareE(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #bb;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareH(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #bc;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareL(Byte registerA, Byte registerValue) {
    testEmulateCompareRegister {
        opcode = #bd;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateCompareRegisterParameters`)
shared void testEmulateCompareMemory(Byte registerA, Byte memoryValue) {
    value result = registerA.unsigned - memoryValue.unsigned;
    value resultByte = result.byte;
    value address = #010a;
    value [high, low] = bytes(address);
    value startState = testState {
        opcode = #be;
        `State.registerA`->registerA,
        `State.registerH`->high,
        `State.registerL`->low,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}
