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
    flagZero
}

test
shared void testEmulateXorA() {
    value startState = testState {
        opcode = #af;
        `State.registerA`->#c7.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, 0.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = false;
        expectedParity = true;
        expectedAuxiliaryCarry = false;
        expectedZero = true;
        expectedSign = false;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateXorImmediateParameters = {
    [#00, #00, #00, true, true, false],
    [#00, #01, #01, false, false, false],
    [#01, #01, #00, true, true, false],
    [#01, #00, #01, false, false, false],
    [#07, #70, #77, true, false, false],
    [#8f, #f0, #7f, false, false, false],
    [#33, #ff, #cc, true, false, true]
};

test
parameters(`value testEmulateXorImmediateParameters`)
shared void testEmulateXorImmediate(Integer registerA, Integer data, Integer result,
    Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #ee;
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

void testEmulateXorRegister(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue) {
    value result = registerA.xor(registerValue);
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

{[Byte, Byte]*} testEmulateXorRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorB(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #a8;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorC(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #a9;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorD(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #aa;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorE(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #ab;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorH(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #ac;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateXorRegisterParameters`)
shared void testEmulateXorL(Byte registerA, Byte registerValue) {
    testEmulateXorRegister {
        opcode = #ad;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}
