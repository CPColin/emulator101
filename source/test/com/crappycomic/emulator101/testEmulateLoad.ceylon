import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    emulate,
    word
}

test
shared void testEmulateLoadAccumulatorD() {
    value high = #01.byte;
    value low = #23.byte;
    value address = word(high, low);
    value val = #56.byte;
    value startState = testState {
        opcode = #1a;
        `State.registerA`->#78.byte,
        `State.registerD`->high,
        `State.registerE`->low,
        address->val
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, val);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateLoadAccumulatorDirect() {
    value high = #01.byte;
    value low = #34.byte;
    value address = word(high, low);
    value val = #5f.byte;
    value startState = testState {
        opcode = #3a;
        `State.registerA`->#78.byte,
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high,
        address->val
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, val);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 13);
}

test
shared void testEmulateLoadHLDirect() {
    value valHigh = #45.byte;
    value valLow = #67.byte;
    value addressHigh = #01.byte;
    value addressLow = #cb.byte;
    value address = word(addressHigh, addressLow);
    value startState = testState {
        opcode = #2a;
        testStateProgramCounter + 1->addressLow,
        testStateProgramCounter + 2->addressHigh,
        address->valLow,
        address + 1->valHigh
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.programCounter`);
    assertEquals(endState.registerH, valHigh);
    assertEquals(endState.registerL, valLow);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 16);
}

void testEmulateLoadPairImmediate(Integer opcode, ByteRegister registerHigh,
        ByteRegister registerLow) {
    value high = #33.byte;
    value low = #ff.byte;
    value startState = testState {
        opcode = opcode;
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        registerHigh, registerLow, `State.programCounter`);
    assertEquals(registerHigh.bind(endState).get(), high);
    assertEquals(registerLow.bind(endState).get(), low);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateLoadPairImmediateB() {
    testEmulateLoadPairImmediate(#01, `State.registerB`, `State.registerC`);
}

test
shared void testEmulateLoadPairImmediateD() {
    testEmulateLoadPairImmediate(#11, `State.registerD`, `State.registerE`);
}

test
shared void testEmulateLoadPairImmediateH() {
    testEmulateLoadPairImmediate(#21, `State.registerH`, `State.registerL`);
}

test
shared void testEmulateLoadPairImmediateStackPointer() {
    value high = #a6.byte;
    value low = #b7.byte;
    value data = word(high, low);
    value startState = testState {
        opcode = #31;
        testStateProgramCounter + 1-> low,
        testStateProgramCounter + 2-> high
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.stackPointer`, `State.programCounter`);
    assertEquals(endState.stackPointer, data);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 10);
}
