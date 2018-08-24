import ceylon.test {
    assertEquals,
    parameters,
    test
}
import com.crappycomic.emulator101 {
    State,
    emulate
}

{[Integer, Integer, Boolean]*} testRotateLeftParameters = {
    [#00, #00, false],
    [#01, #02, false],
    [#80, #01, true],
    [#7f, #fe, false],
    [#ff, #ff, true]
};

test
parameters(`value testRotateLeftParameters`)
shared void testEmulateRotateLeft(Integer initialValue, Integer expectedValue,
        Boolean expectedCarry) {
    value startState = testState {
        opcode = #07;
        `State.registerA`->initialValue.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, expectedValue.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Boolean, Integer, Boolean]*} testRotateLeftThroughCarryParameters = {
    [#00, false, #00, false],
    [#00, true, #01, false],
    [#01, false, #02, false],
    [#01, true, #03, false],
    [#80, false, #00, true],
    [#80, true, #01, true],
    [#7f, false, #fe, false],
    [#7f, true, #ff, false],
    [#ff, false, #fe, true],
    [#ff, true, #ff, true]
};

test
parameters(`value testRotateLeftThroughCarryParameters`)
shared void testEmulateRotateLeftThroughCarry(Integer initialValue, Boolean carry,
        Integer expectedValue, Boolean expectedCarry) {
    value startState = testState {
        opcode = #17;
        `State.registerA`->initialValue.byte,
        `State.carry`->carry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, expectedValue.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Boolean]*} testRotateRightParameters = {
    [#00, #00, false],
    [#01, #80, true],
    [#02, #01, false],
    [#fe, #7f, false],
    [#ff, #ff, true]
};

test
parameters(`value testRotateRightParameters`)
shared void testEmulateRotateRight(Integer initialValue, Integer expectedValue,
        Boolean expectedCarry) {
    value startState = testState {
        opcode = #0f;
        `State.registerA`->initialValue.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, expectedValue.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Boolean, Integer, Boolean]*} testRotateRightThroughCarryParameters = {
    [#00, false, #00, false],
    [#00, true, #80, false],
    [#01, false, #00, true],
    [#01, true, #80, true],
    [#80, false, #40, false],
    [#80, true, #c0, false],
    [#7f, false, #3f, true],
    [#7f, true, #bf, true],
    [#ff, false, #7f, true],
    [#ff, true, #ff, true]
};

test
parameters(`value testRotateRightThroughCarryParameters`)
shared void testEmulateRotateRightThroughCarry(Integer initialValue, Boolean carry,
        Integer expectedValue, Boolean expectedCarry) {
    value startState = testState {
        opcode = #1f;
        `State.registerA`->initialValue.byte,
        `State.carry`->carry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, expectedValue.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}
