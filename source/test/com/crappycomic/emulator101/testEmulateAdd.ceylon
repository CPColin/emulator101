import ceylon.test {
    assertEquals,
    parameters,
    test
}
import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    emulate
}

{[Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean]*}
testEmulateAddImmediateParameters = {
    [#00, #00, #00, false, true, false, true, false],
    [#00, #01, #01, false, false, false, false, false],
    [#01, #00, #01, false, false, false, false, false],
    [#11, #22, #33, false, true, false, false, false],
    [#0f, #01, #10, false, false, true, false, false],
    [#7f, #01, #80, false, false, true, false, true],
    [#ff, #02, #01, true, false, true, false, false]
};

test
parameters(`value testEmulateAddImmediateParameters`)
shared void testEmulateAddImmediate(Integer registerA, Integer data, Integer result,
        Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #c6;
        `State.registerA`->registerA.byte,
        `State.carry`->true, // Make sure carry flag doesn't get included
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

{[Integer, Integer, Boolean, Integer, Boolean, Boolean, Boolean, Boolean, Boolean]*}
testEmulateAddImmediateWithCarryParameters = {
    [#00, #00, false, #00, false, true, false, true, false],
    [#00, #00, true, #01, false, false, false, false, false],
    [#00, #01, false, #01, false, false, false, false, false],
    [#00, #01, true, #02, false, false, false, false, false],
    [#01, #00, false, #01, false, false, false, false, false],
    [#01, #00, true, #02, false, false, false, false, false],
    [#11, #22, false, #33, false, true, false, false, false],
    [#11, #22, true, #34, false, false, false, false, false],
    [#0f, #01, false, #10, false, false, true, false, false],
    [#0f, #01, true, #11, false, true, true, false, false],
    [#7f, #01, false, #80, false, false, true, false, true],
    [#7f, #01, true, #81, false, true, true, false, true],
    [#ff, #02, false, #01, true, false, true, false, false],
    [#ff, #02, true, #02, true, false, true, false, false]
};

test
parameters(`value testEmulateAddImmediateWithCarryParameters`)
shared void testEmulateAddImmediateWithCarry(Integer registerA, Integer data, Boolean carry,
        Integer result, Boolean expectedCarry, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #ce;
        `State.registerA`->registerA.byte,
        `State.carry`->carry,
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

{[Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean]*}
testEmulateAddRegisterParameters = {
    [#00, #00, #00, false, true, false, true, false],
    [#00, #01, #01, false, false, false, false, false],
    [#01, #00, #01, false, false, false, false, false],
    [#11, #22, #33, false, true, false, false, false],
    [#0f, #01, #10, false, false, true, false, false],
    [#7f, #01, #80, false, false, true, false, true],
    [#ff, #02, #01, true, false, true, false, false]
};

void testEmulateAddRegister(Integer opcode, ByteRegister register, Integer registerA,
        Integer registerValue, Integer result, Boolean expectedCarry, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA.byte,
        register->registerValue.byte,
        `State.carry`->true // Make sure carry flag doesn't get included
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddB(Integer registerA, Integer registerValue, Integer result,
        Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #80;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddC(Integer registerA, Integer registerValue, Integer result,
    Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
    Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #81;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddD(Integer registerA, Integer registerValue, Integer result,
    Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
    Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #82;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddE(Integer registerA, Integer registerValue, Integer result,
    Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
    Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #83;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddH(Integer registerA, Integer registerValue, Integer result,
    Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
    Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #84;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddL(Integer registerA, Integer registerValue, Integer result,
        Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    testEmulateAddRegister {
        opcode = #85;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
        result = result;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}
