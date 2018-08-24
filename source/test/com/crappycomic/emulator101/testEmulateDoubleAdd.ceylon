import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    bytes,
    emulate
}

{[Integer, Integer, Integer, Boolean]*} testEmulateDoubleAddParameters = {
    [#0000, #0000, #0000, false],
    [#0123, #4567, #468a, false],
    [#abcd, #a000, #4bcd, true]
};

void testEmulateDoubleAdd(Integer opcode, ByteRegister registerHigh, ByteRegister registerLow, 
        Integer hlValue, Integer registerValue, Integer expectedValue, Boolean expectedCarry) {
    value [registerH, registerL] = bytes(hlValue);
    value [registerValueHigh, registerValueLow] = bytes(registerValue);
    value [expectedHigh, expectedLow] = bytes(expectedValue);
    value startState = testState {
        opcode = opcode;
        `State.registerH`->registerH,
        `State.registerL`->registerL,
        registerHigh->registerValueHigh,
        registerLow->registerValueLow
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerH, expectedHigh);
    assertEquals(endState.registerL, expectedLow);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

test
parameters(`value testEmulateDoubleAddParameters`)
shared void testEmulateDoubleAddB(Integer hlValue, Integer bcValue, Integer expectedValue,
        Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #09;
        registerHigh = `State.registerB`;
        registerLow = `State.registerC`;
        hlValue = hlValue;
        registerValue = bcValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}

test
parameters(`value testEmulateDoubleAddParameters`)
shared void testEmulateDoubleAddD(Integer hlValue, Integer deValue, Integer expectedValue,
        Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #19;
        registerHigh = `State.registerD`;
        registerLow = `State.registerE`;
        hlValue = hlValue;
        registerValue = deValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
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
    testEmulateDoubleAdd {
        opcode = #29;
        registerHigh = `State.registerH`;
        registerLow = `State.registerL`;
        hlValue = startValue;
        registerValue = startValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}

test
parameters(`value testEmulateDoubleAddParameters`)
shared void testEmulateDoubleAddStackPointer(Integer hlValue, Integer stackPointerValue,
        Integer expectedValue, Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #39;
        registerHigh = `State.stackPointerHigh`;
        registerLow = `State.stackPointerLow`;
        hlValue = hlValue;
        registerValue = stackPointerValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}
