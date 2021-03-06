import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    bytes,
    emulate,
    word
}

void testEmulateStoreAccumulator(Integer opcode, ByteRegister registerHigh,
        ByteRegister registerLow) {
    value address = #0144;
    value [high, low] = bytes(address);
    value data = #65.byte;
    value startState = testState {
        opcode = opcode;
        `State.registerA`->data,
        registerHigh->high,
        registerLow->low
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.memory`, `State.programCounter`);
    assertMemoriesEqual(startState, endState, address->data);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateStoreAccumulatorB() {
    testEmulateStoreAccumulator(#02, `State.registerB`, `State.registerC`);
}

test
shared void testEmulateStoreAccumulatorD() {
    testEmulateStoreAccumulator(#12, `State.registerD`, `State.registerE`);
}

test
shared void testEmulateStoreAccumulatorDirect() {
    value high = #01.byte;
    value low = #ee.byte;
    value address = word(high, low);
    value data = #75.byte;
    value startState = testState {
        opcode = #32;
        `State.registerA`->data,
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.memory`, `State.programCounter`);
    assertMemoriesEqual(startState, endState, address->data);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 13);
}

test
shared void testEmulateStoreHLDirect() {
    value valHigh = #45.byte;
    value valLow = #67.byte;
    value addressHigh = #01.byte;
    value addressLow = #cb.byte;
    value address = word(addressHigh, addressLow);
    value startState = testState {
        opcode = #22;
        `State.registerH`->valHigh,
        `State.registerL`->valLow,
        testStateProgramCounter + 1->addressLow,
        testStateProgramCounter + 2->addressHigh
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.memory`, `State.programCounter`);
    assertMemoriesEqual(startState, endState, address->valLow, address + 1->valHigh);
    assertEquals(endState.programCounter, startState.programCounter + 3);
    
    assertEquals(cycles, 16);
}
