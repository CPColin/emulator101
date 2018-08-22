import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.emulator101 {
    State,
    emulate
}

test
shared void testEmulateDisableInterrupts() {
    value startState = testState {
        opcode = #f3;
        `State.interruptsEnabled`->true
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.interruptsEnabled`, `State.programCounter`);
    assertEquals(endState.interruptsEnabled, false);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
shared void testEmulateEnableInterrupts() {
    value startState = testState {
        opcode = #fb;
        `State.interruptsEnabled`->false
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.interruptsEnabled`, `State.programCounter`);
    assertEquals(endState.interruptsEnabled, true);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
shared void testEmulateHalt() {
    value startState = testState {
        opcode = #76;
        `State.stopped`->false
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.stopped`, `State.programCounter`);
    assertEquals(endState.stopped, true);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}
