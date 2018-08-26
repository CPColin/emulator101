import ceylon.test {
    assertEquals,
    assertNull,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    Interrupt,
    State,
    bytes,
    emulate,
    restartAddress,
    restartIndex
}

{[Integer, Integer]*} testRestartAddressParameters = {
    [0, #0000],
    [1, #0008],
    [2, #0010],
    [3, #0018],
    [4, #0020],
    [5, #0028],
    [6, #0030],
    [7, #0038]
};

test
parameters(`value testRestartAddressParameters`)
shared void testRestartAddress(Integer index, Integer expected) {
    assertEquals(restartAddress(index), expected);
}

{[Integer, Integer]*} testRestartIndexParameters = {
    [$11000111, 0],
    [$11001111, 1],
    [$11010111, 2],
    [$11011111, 3],
    [$11100111, 4],
    [$11101111, 5],
    [$11110111, 6],
    [$11111111, 7]
};

test
parameters(`value testRestartIndexParameters`)
shared void testRestartIndex(Integer opcode, Integer expected) {
    assertEquals(restartIndex(opcode.byte), expected);
}

void testEmulateRestart(Integer opcode, Boolean withInterrupt) {
    value testState = package.testState {
        opcode = opcode;
    };
    State startState;
    Integer returnAddress;
    
    if (withInterrupt) {
        startState = testState.withInterrupt(Interrupt(opcode.byte));
        returnAddress = startState.programCounter;
    } else {
        startState = testState;
        returnAddress = startState.programCounter + 1;
    }
    
    value [returnAddressHigh, returnAddressLow] = bytes(returnAddress);
    value [endState, cycles] = emulate(startState);
    
    if (withInterrupt) {
        assertStatesEqual(startState, endState,
            `State.memory`, `State.stackPointer`, `State.programCounter`, `State.interrupt`);
        assertNull(endState.interrupt);
    } else {
        assertStatesEqual(startState, endState,
            `State.memory`, `State.stackPointer`, `State.programCounter`);
    }
    
    assertMemoriesEqual(startState, endState,
        endState.stackPointer->returnAddressLow,
        endState.stackPointer + 1->returnAddressHigh);
    assertEquals(endState.stackPointer, startState.stackPointer - 2);
    assertEquals(endState.programCounter, restartAddress(restartIndex(opcode.byte)));
    
    assertEquals(cycles, 11);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart0(Boolean withInterrupt) {
    testEmulateRestart(#c7, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart1(Boolean withInterrupt) {
    testEmulateRestart(#cf, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart2(Boolean withInterrupt) {
    testEmulateRestart(#d7, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart3(Boolean withInterrupt) {
    testEmulateRestart(#df, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart4(Boolean withInterrupt) {
    testEmulateRestart(#e7, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart5(Boolean withInterrupt) {
    testEmulateRestart(#ef, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart6(Boolean withInterrupt) {
    testEmulateRestart(#f7, withInterrupt);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateRestart7(Boolean withInterrupt) {
    testEmulateRestart(#ff, withInterrupt);
}
