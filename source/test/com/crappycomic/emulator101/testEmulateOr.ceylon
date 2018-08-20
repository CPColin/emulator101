import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    emulate,
    flagParity,
    flagSign,
    flagZero,
    bytes
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateOrA(Byte registerValue) {
    value startState = testState {
        opcode = #b7;
        `State.registerA`->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = flagParity(registerValue);
        expectedZero = flagZero(registerValue);
        expectedSign = flagSign(registerValue);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateOrImmediateParameters = {
    [#00, #00, #00, true, true, false],
    [#00, #01, #01, false, false, false],
    [#01, #01, #01, false, false, false],
    [#01, #00, #01, false, false, false],
    [#07, #70, #77, true, false, false],
    [#8f, #f0, #ff, true, false, true]
};

test
parameters(`value testEmulateOrImmediateParameters`)
shared void testEmulateOrImmediate(Integer registerA, Integer data, Integer result,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #f6;
        `State.registerA`->registerA.byte,
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

void testEmulateOrRegister(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue) {
    value result = registerA.or(registerValue);
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA,
        register->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = flagParity(result);
        expectedZero = flagZero(result);
        expectedSign = flagSign(result);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Byte, Byte]*} testEmulateOrRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrB(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b0;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrC(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b1;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrD(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b2;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrE(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b3;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrH(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b4;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrL(Byte registerA, Byte registerValue) {
    testEmulateOrRegister {
        opcode = #b5;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateOrRegisterParameters`)
shared void testEmulateOrMemory(Byte registerValue, Byte memoryValue) {
    value result = registerValue.or(memoryValue);
    value address = #010a;
    value [high, low] = bytes(address);
    value startState = testState {
        opcode = #b6;
        `State.registerA`->registerValue,
        `State.registerH`->high,
        `State.registerL`->low,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = flagParity(result);
        expectedZero = flagZero(result);
        expectedSign = flagSign(result);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}
