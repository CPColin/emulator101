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
