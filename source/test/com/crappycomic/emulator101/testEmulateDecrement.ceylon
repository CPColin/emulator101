import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    bytes,
    emulate,
    flagAuxiliaryCarry,
    flagParity,
    flagSign,
    flagZero,
    word
}

void testEmulateDecrementRegister(Integer opcode, ByteRegister register, Byte registerValue) {
    value result = registerValue.predecessor;
    value startState = testState {
        opcode = opcode;
        register->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, register, `State.flags`, `State.programCounter`);
    assertEquals(register.bind(endState).get(), result);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = flagParity(result);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerValue, -1.byte, result);
        expectedZero = flagZero(result);
        expectedSign = flagSign(result);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementA(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #3d;
        register = `State.registerA`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementB(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #05;
        register = `State.registerB`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementC(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #0d;
        register = `State.registerC`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementD(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #15;
        register = `State.registerD`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementE(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #1d;
        register = `State.registerE`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementH(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #25;
        register = `State.registerH`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateDecrementL(Byte registerValue) {
    testEmulateDecrementRegister {
        opcode = #2d;
        register = `State.registerL`;
        registerValue = registerValue;
    };
}

test
parameters(`value testRegisterParameters`) // Eh, close enough.
shared void testEmulateDecrementMemory(Byte memoryValue) {
    value high = #01.byte;
    value low = #89.byte;
    value address = word(high, low);
    value result = memoryValue.predecessor;
    value startState = testState {
        opcode = #35;
        `State.registerH`->high,
        `State.registerL`->low,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.memory`, `State.flags`, `State.programCounter`);
    assertMemoriesEqual(startState, endState, address->result);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = flagParity(result);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(memoryValue, -1.byte, result);
        expectedZero = flagZero(result);
        expectedSign = flagSign(result);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

{[Byte, Byte]*} testEmulateDecrementPairParameters
        = testRegisterParameters.product(testRegisterParameters);

void testEmulateDecrementPair(Integer opcode, ByteRegister registerHigh, ByteRegister registerLow,
        Byte high, Byte low) {
    value [expectedHigh, expectedLow] = bytes(word(high, low) - 1);
    value startState = testState {
        opcode = opcode;
        registerHigh->high,
        registerLow->low
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, registerHigh, registerLow, `State.programCounter`);
    assertEquals(registerHigh.bind(endState).get(), expectedHigh);
    assertEquals(registerLow.bind(endState).get(), expectedLow);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testEmulateDecrementPairParameters`)
shared void testEmulateDecrementPairB(Byte high, Byte low) {
    testEmulateDecrementPair(#0b, `State.registerB`, `State.registerC`, high, low);
}

test
parameters(`value testEmulateDecrementPairParameters`)
shared void testEmulateDecrementPairD(Byte high, Byte low) {
    testEmulateDecrementPair(#1b, `State.registerD`, `State.registerE`, high, low);
}

test
parameters(`value testEmulateDecrementPairParameters`)
shared void testEmulateDecrementPairH(Byte high, Byte low) {
    testEmulateDecrementPair(#2b, `State.registerH`, `State.registerL`, high, low);
}

test
parameters(`value testEmulateDecrementPairParameters`)
shared void testEmulateDecrementPairStackPointer(Byte high, Byte low) {
    testEmulateDecrementPair(#3b, `State.stackPointerHigh`, `State.stackPointerLow`, high, low);
}
