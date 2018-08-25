import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
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

void testEmulateRestart(Integer opcode) {
    value startState = testState {
        opcode = opcode;
    };
    value [programCounterHigh, programCounterLow]
            = bytes(startState.programCounter);
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.memory`, `State.stackPointer`, `State.programCounter`);
    assertMemoriesEqual(startState, endState,
        endState.stackPointer + 1->programCounterLow,
        endState.stackPointer + 2->programCounterHigh);
    assertEquals(endState.stackPointer, startState.stackPointer - 2);
    assertEquals(endState.programCounter, restartAddress(restartIndex(opcode.byte)));
    
    assertEquals(cycles, 11);
}

test
shared void testEmulateRestart0() {
    testEmulateRestart(#c7);
}

test
shared void testEmulateRestart1() {
    testEmulateRestart(#cf);
}

test
shared void testEmulateRestart2() {
    testEmulateRestart(#d7);
}

test
shared void testEmulateRestart3() {
    testEmulateRestart(#df);
}

test
shared void testEmulateRestart4() {
    testEmulateRestart(#e7);
}

test
shared void testEmulateRestart5() {
    testEmulateRestart(#ef);
}

test
shared void testEmulateRestart6() {
    testEmulateRestart(#f7);
}

test
shared void testEmulateRestart7() {
    testEmulateRestart(#ff);
}
