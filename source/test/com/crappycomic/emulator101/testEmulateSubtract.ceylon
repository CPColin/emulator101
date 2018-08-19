import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State,
    emulate,
    flagParity,
    flagAuxiliaryCarry,
    flagCarry,
    flagZero,
    flagSign,
    ByteRegister
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateSubtractA(Byte registerValue) {
    value result = registerValue.unsigned - registerValue.unsigned;
    value resultByte = result.byte;
    value startState = testState {
        opcode = #97;
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

{[Byte, Boolean]*} testEmulateSubtractAWithBorrowParameters
        = testRegisterParameters.product(testBooleanParameters);

test
parameters(`value testEmulateSubtractAWithBorrowParameters`)
shared void testEmulateSubtractAWithBorrow(Byte registerValue, Boolean borrow) {
    value result = registerValue.unsigned - registerValue.unsigned - (borrow then 1 else 0);
    value resultByte = result.byte;
    value startState = testState {
        opcode = #9f;
        `State.registerA`->registerValue,
        `State.carry`->borrow
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
testEmulateSubtractImmediateParameters = {
    [#00, #00, #00, false, true, false, true, false],
    [#03, #02, #01, false, false, false, false, false],
    [#ff, #80, #7f, false, false, false, false, false],
    [#ff, #7e, #81, false, true, false, false, true],
    [#01, #02, #ff, true, true, true, false, true]
};

test
parameters(`value testEmulateSubtractImmediateParameters`)
shared void testEmulateSubtractImmediate(Integer registerA, Integer data, Integer result,
        Boolean expectedCarry, Boolean expectedParity, Boolean expectedAuxiliaryCarry,
        Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #d6;
        `State.registerA`->registerA.byte,
        `State.carry`->true, // Make sure carry bit doesn't interfere.
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
testEmulateSubtractImmediateWithBorrowParameters = {
    [#00, #00, false, #00, false, true, false, true, false],
    [#00, #00, true, #ff, true, true, true, false, true],
    [#03, #02, false, #01, false, false, false, false, false],
    [#03, #02, true, #00, false, true, false, true, false],
    [#ff, #80, false, #7f, false, false, false, false, false],
    [#03, #02, false, #01, false, false, false, false, false],
    [#ff, #7e, false, #81, false, true, false, false, true]
};

test
parameters(`value testEmulateSubtractImmediateWithBorrowParameters`)
shared void testEmulateSubtractImmediateWithBorrow(Integer registerA, Integer data, Boolean borrow,
        Integer result, Boolean expectedCarry, Boolean expectedParity,
        Boolean expectedAuxiliaryCarry, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #de;
        `State.registerA`->registerA.byte,
        `State.carry`->borrow,
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

void testEmulateSubtractRegister(Integer opcode, ByteRegister register, Byte registerA,
    Byte registerValue) {
    value result = registerA.unsigned - registerValue.unsigned;
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

{[Byte, Byte]*} testEmulateSubtractRegisterParameters
        = testRegisterParameters.product(testRegisterParameters);

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractB(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #90;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractC(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #91;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractD(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #92;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractE(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #93;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractH(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #94;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

test
parameters(`value testEmulateSubtractRegisterParameters`)
shared void testEmulateSubtractL(Byte registerA, Byte registerValue) {
    testEmulateSubtractRegister {
        opcode = #95;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
    };
}

{[Byte, Byte, Boolean]*} testEmulateSubtractRegisterWithBorrowParameters
        = secondProduct(testEmulateSubtractRegisterParameters, testBooleanParameters);

void testEmulateSubtractRegisterWithBorrow(Integer opcode, ByteRegister register, Byte registerA,
    Byte registerValue, Boolean borrow) {
    value result = registerA.unsigned - registerValue.unsigned - (borrow then 1 else 0);
    value resultByte = result.byte;
    value startState = testState {
        opcode = opcode;
        `State.registerA`->registerA,
        register->registerValue,
        `State.carry`->borrow
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
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractBWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #98;
        register = `State.registerB`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}

test
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractCWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #99;
        register = `State.registerC`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}

test
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractDWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #9a;
        register = `State.registerD`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}

test
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractEWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #9b;
        register = `State.registerE`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}

test
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractHWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #9c;
        register = `State.registerH`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}

test
parameters(`value testEmulateSubtractRegisterWithBorrowParameters`)
shared void testEmulateSubtractLWithBorrow(Byte registerA, Byte registerValue, Boolean borrow) {
    testEmulateSubtractRegisterWithBorrow {
        opcode = #9d;
        register = `State.registerL`;
        registerA = registerA;
        registerValue = registerValue;
        borrow = borrow;
    };
}
