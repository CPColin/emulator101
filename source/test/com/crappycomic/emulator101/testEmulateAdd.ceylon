import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    ByteRegister,
    State,
    emulate,
    flagAuxiliaryCarry,
    flagCarry,
    flagParity,
    flagSign,
    flagZero,
    bytes
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateAddA(Byte registerValue) {
    value result = registerValue.unsigned + registerValue.unsigned;
    value resultByte = result.byte;
    value startState = testState {
        opcode = #87;
        `State.registerA`->registerValue,
        `State.carry`->true // Make sure carry flag doesn't get included
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerValue, registerValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Byte, Boolean]*} testEmulateAddAWithCarryParameters
        = testRegisterParameters.product(testBooleanParameters);

test
parameters(`value testEmulateAddAWithCarryParameters`)
shared void testEmulateAddAWithCarry(Byte registerValue, Boolean carry) {
    value result = registerValue.unsigned + registerValue.unsigned + (carry then 1 else 0);
    value resultByte = result.byte;
    value startState = testState {
        opcode = #8f;
        `State.registerA`->registerValue,
        `State.carry`->carry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerValue, registerValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean]*}
testEmulateAddImmediateParameters = {
    [#00, #00, #00, false, true, false, true, false],
    [#00, #01, #01, false, false, false, false, false],
    [#01, #00, #01, false, false, false, false, false],
    [#11, #22, #33, false, true, false, false, false],
    [#0f, #01, #10, false, false, true, false, false],
    [#7f, #01, #80, false, false, true, false, true],
    [#ff, #02, #01, true, false, true, false, false]
};

test
parameters(`value testEmulateAddImmediateParameters`)
shared void testEmulateAddImmediate(Integer registerA, Integer data, Integer result,
        Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #c6;
        `State.registerA`->registerA.byte,
        `State.carry`->true, // Make sure carry flag doesn't get included
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

{[Integer, Integer, Boolean, Integer, Boolean, Boolean, Boolean, Boolean, Boolean]*}
testEmulateAddImmediateWithCarryParameters = {
    [#00, #00, false, #00, false, true, false, true, false],
    [#00, #00, true, #01, false, false, false, false, false],
    [#00, #01, false, #01, false, false, false, false, false],
    [#00, #01, true, #02, false, false, false, false, false],
    [#01, #00, false, #01, false, false, false, false, false],
    [#01, #00, true, #02, false, false, false, false, false],
    [#11, #22, false, #33, false, true, false, false, false],
    [#11, #22, true, #34, false, false, false, false, false],
    [#0f, #01, false, #10, false, false, true, false, false],
    [#0f, #01, true, #11, false, true, true, false, false],
    [#7f, #01, false, #80, false, false, true, false, true],
    [#7f, #01, true, #81, false, true, true, false, true],
    [#ff, #02, false, #01, true, false, true, false, false],
    [#ff, #02, true, #02, true, false, true, false, false]
};

test
parameters(`value testEmulateAddImmediateWithCarryParameters`)
shared void testEmulateAddImmediateWithCarry(Integer registerA, Integer data, Boolean carry,
        Integer result, Boolean expectedCarry, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #ce;
        `State.registerA`->registerA.byte,
        `State.carry`->carry,
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, result.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

void testEmulateAddRegister(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue) {
    value result = registerA.unsigned + registerValue.unsigned;
    value resultByte = result.byte;
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA,
        register->registerValue,
        `State.carry`->true // Make sure carry flag doesn't get included
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerA, registerValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Byte, Byte]*} testEmulateAddRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddB(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #80;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddC(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #81;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddD(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #82;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddE(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #83;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddH(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #84;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddL(Byte registerA, Byte registerValue) {
    testEmulateAddRegister {
        opcode = #85;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateAddRegisterParameters`)
shared void testEmulateAddMemory(Byte registerValue, Byte memoryValue) {
    value result = registerValue.unsigned + memoryValue.unsigned;
    value resultByte = result.byte;
    value address = #010a;
    value [high, low] = bytes(address);
    value startState = testState {
        opcode = #86;
        `State.registerA`->registerValue,
        `State.registerH`->high,
        `State.registerL`->low,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerValue, memoryValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}

{[Byte, Byte, Boolean]*} testEmulateAddRegisterWithCarryParameters
        = secondProduct(testEmulateAddRegisterParameters, testBooleanParameters);

void testEmulateAddRegisterWithCarry(Integer opcode, ByteRegister register, Byte registerA,
        Byte registerValue, Boolean carry) {
    value result = registerA.unsigned + registerValue.unsigned + (carry then 1 else 0);
    value resultByte = result.byte;
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA,
        register->registerValue,
        `State.carry`->carry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerA, registerValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddBWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #88;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddCWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #89;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddDWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #8a;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddEWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #8b;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddHWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #8c;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddLWithCarry(Byte registerA, Byte registerValue, Boolean carry) {
    testEmulateAddRegisterWithCarry {
        opcode = #8d;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
        carry = carry;
    };
}

test
parameters(`value testEmulateAddRegisterWithCarryParameters`)
shared void testEmulateAddMemoryWithCarry(Byte registerValue, Byte memoryValue, Boolean carry) {
    value result = registerValue.unsigned + memoryValue.unsigned + (carry then 1 else 0);
    value resultByte = result.byte;
    value address = #010a;
    value [high, low] = bytes(address);
    value startState = testState {
        opcode = #8e;
        `State.registerA`->registerValue,
        `State.registerH`->high,
        `State.registerL`->low,
        `State.carry`->carry,
        address->memoryValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, resultByte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = flagCarry(result);
        expectedParity = flagParity(resultByte);
        expectedAuxiliaryCarry = flagAuxiliaryCarry(registerValue, memoryValue, resultByte);
        expectedZero = flagZero(resultByte);
        expectedSign = flagSign(resultByte);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 7);
}
