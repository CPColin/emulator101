import ceylon.language.meta.declaration {
    FunctionDeclaration
}
import ceylon.language.meta.model {
    Attribute
}
import ceylon.test {
    assertEquals,
    assertFalse,
    assertTrue,
    assumeTrue,
    parameters,
    test
}
import ceylon.test.annotation {
    IgnoreAnnotation,
    TestAnnotation
}

import com.crappycomic.emulator101 {
    BitFlag,
    BitFlagUpdate,
    ByteRegister,
    ByteRegisterUpdate,
    IntegerRegisterUpdate,
    MemoryUpdate,
    Opcode,
    State,
    bytes,
    emulate,
    flagAuxiliaryCarry,
    flagCarry,
    flagParity,
    flagSign,
    flagZero,
    word
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
