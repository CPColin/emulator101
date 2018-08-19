import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State,
    emulate,
    flagParity,
    flagSign,
    flagZero,
    ByteRegister
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateAndA(Byte registerValue) {
    value startState = testState {
        opcode = #a7;
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

{[Integer, Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateAndImmediateParameters = {
    [#00, #00, #00, true, true, false],
    [#01, #01, #01, false, false, false],
    [#01, #00, #00, true, true, false],
    [#77, #0f, #07, false, false, false],
    [#8f, #f0, #80, false, false, true]
};

test
parameters(`value testEmulateAndImmediateParameters`)
shared void testEmulateAndImmediate(Integer registerA, Integer data, Integer result,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #e6;
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

void testEmulateAndRegister(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue) {
    value result = registerA.and(registerValue);
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

{[Byte, Byte]*} testEmulateAndRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndB(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a0;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndC(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a1;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndD(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a2;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndE(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a3;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndH(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a4;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAndRegisterParameters`)
shared void testEmulateAndL(Byte registerA, Byte registerValue) {
    testEmulateAndRegister {
        opcode = #a5;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}
