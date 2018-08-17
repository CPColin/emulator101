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
    word
}
import ceylon.language.meta.declaration {
    FunctionDeclaration
}

Integer testStateProgramCounter = #120;

Integer testStateStackPointer = #100;

State testState(Integer opcode,
        {BitFlagUpdate|ByteRegisterUpdate|IntegerRegisterUpdate|MemoryUpdate*} updates)
    => State {
        registerA = #f0.byte;
        registerB = #f1.byte;
        registerC = #f2.byte;
        registerD = #f3.byte;
        registerE = #f4.byte;
        registerH = #f5.byte;
        registerL = #f6.byte;
        flags = State.packFlags {
            carry = true;
            parity = true;
            auxiliaryCarry = true;
            zero = true;
            sign = true;
        };
        stackPointer = testStateStackPointer;
        programCounter = testStateProgramCounter;
        memory = Array<Byte>.ofSize(#0200, #ff.byte);
    }.with {
        testStateProgramCounter->opcode.byte,
        *updates
    };

abstract class DoNotCheck() of doNotCheck {}

object doNotCheck extends DoNotCheck() {}

void assertFlags(
        State startState,
        State endState,
        Boolean expectedCarry = startState.carry,
        Boolean expectedParity = startState.parity,
        Boolean|DoNotCheck expectedAuxiliaryCarry = doNotCheck,
        Boolean expectedZero = startState.zero,
        Boolean expectedSign = startState.sign) {
    assertEquals(endState.carry, expectedCarry, "Unexpected carry flag");
    assertEquals(endState.parity, expectedParity, "Unexpected parity flag");
    assertEquals(endState.zero, expectedZero, "Unexpected zero flag");
    assertEquals(endState.sign, expectedSign, "Unexpected sign flag");
    
    if (is Boolean expectedAuxiliaryCarry) {
        assertEquals(endState.auxiliaryCarry, expectedAuxiliaryCarry,
            "Unexpected auxiliary carry flag");
    }
}

void assertMemoriesEqual(State startState, State endState, <Integer->Byte>* except) {
    value exceptMap = map(except);
    
    for (address in 0:startState.memory.size) {
        if (exists exceptVal = exceptMap[address]) {
            assertEquals(endState.memory[address], exceptVal,
                "Memory should have changed");
        } else {
            assertEquals(endState.memory[address], startState.memory[address],
                "Memory should not have changed");
        }
    }
}

"Asserts that all fields of the given states are equal, other than the given exceptions."
void assertStatesEqual(State startState, State endState, Attribute<State>* except) {
    if (!except.contains(`State.registerA`)) {
        assertEquals(endState.registerA, startState.registerA,
            "Register A should not have changed.");
    }
    
    if (!except.contains(`State.registerB`)) {
        assertEquals(endState.registerB, startState.registerB,
            "Register B should not have changed.");
    }
    
    if (!except.contains(`State.registerC`)) {
        assertEquals(endState.registerC, startState.registerC,
            "Register C should not have changed.");
    }
    
    if (!except.contains(`State.registerD`)) {
        assertEquals(endState.registerD, startState.registerD,
            "Register D should not have changed.");
    }
    
    if (!except.contains(`State.registerE`)) {
        assertEquals(endState.registerE, startState.registerE,
            "Register E should not have changed.");
    }
    
    if (!except.contains(`State.registerH`)) {
        assertEquals(endState.registerH, startState.registerH,
            "Register H should not have changed.");
    }
    
    if (!except.contains(`State.registerL`)) {
        assertEquals(endState.registerL, startState.registerL,
            "Register L should not have changed.");
    }
    
    if (!except.contains(`State.flags`)) {
        assertEquals(endState.flags, startState.flags,
            "Processor flags should not have changed.");
    }
    
    if (!except.contains(`State.stackPointer`)) {
        assertEquals(endState.stackPointer, startState.stackPointer,
            "Stack pointer should not have changed.");
    }
    
    if (!except.contains(`State.programCounter`)) {
        assertEquals(endState.programCounter, startState.programCounter,
            "Program counter should not have changed. (Really?)");
    }
    
    if (!except.contains(`State.memory`)) {
        assertEquals(endState.memory, startState.memory,
            "Memory should not have changed.");
    }
}

{Opcode*} verifyAllOpcodesTestedParameters = `Opcode`.caseValues;

Map<String, FunctionDeclaration> testFunctions = map {
    for (declaration in `package`.members<FunctionDeclaration>())
        if (declaration.name.startsWith("testEmulate"))
            declaration.name.lowercased -> declaration
};

test
parameters(`value verifyAllOpcodesTestedParameters`)
shared void verifyAllOpcodesTested(Opcode opcode) {
    value testFunction = testFunctions["testEmulate``opcode.string``".lowercased];
    
    assumeTrue(testFunction exists);
    
    assert (exists testFunction);
    
    assertTrue(testFunction.annotated<TestAnnotation>(), "Function is not annotated test");
    assertTrue(testFunction.annotated<SharedAnnotation>(), "Function is not shared");
    assertFalse(testFunction.annotated<IgnoreAnnotation>(), "Function is ignored");
}

{Boolean*} testBooleanParameters = `Boolean`.caseValues;

test
shared void testEmulateCall() {
    value addressHigh = #33.byte;
    value addressLow = #44.byte;
    value address = word(addressHigh, addressLow);
    value [startProgramCounterHigh, startProgramCounterLow] = bytes(testStateProgramCounter);
    value startState = testState {
        opcode = #cd;
        testStateProgramCounter + 1->addressLow,
        testStateProgramCounter + 2->addressHigh
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.stackPointer`, `State.programCounter`, `State.memory`);
    assertEquals(endState.stackPointer, startState.stackPointer - 2);
    assertEquals(endState.programCounter, address);
    assertMemoriesEqual(startState, endState,
        endState.stackPointer->startProgramCounterLow,
        endState.stackPointer + 1->startProgramCounterHigh);
    
    assertEquals(cycles, 17);
}

{[Integer, Integer, Boolean, Boolean, Boolean, Boolean]*} testEmulateCompareImmediateParameters = {
    [#00, #00, false, true, true, false],
    [#01, #00, false, false, false, false],
    [#00, #01, true, false, false, true],
    [#00, #02, true, true, false, true],
    [#a0, #a0, false, true, true, false],
    [#ff, #fe, false, false, false, false],
    [#ff, #01, false, true, false, true]
};

test
parameters(`value testEmulateCompareImmediateParameters`)
shared void testEmulateCompareImmediate(Integer registerA, Integer data, Boolean expectedCarry,
    Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    value startState = testState {
        opcode = #fe;
        `State.registerA`->registerA.byte,
        testStateProgramCounter + 1->data.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 7);
}

{[Integer, Integer, Boolean, Boolean, Boolean]*} testEmulateDecrementRegisterParameters = [
    [#01, #00, true, true, false],
    [#10, #0f, false, false, false],
    [#00, #ff, false, false, true],
    [#f1, #f0, true, false, true]
];

void testEmulateDecrementRegister(Integer opcode, ByteRegister register, Integer startRegister,
        Integer expectedRegister, Boolean expectedParity, Boolean expectedZero,
        Boolean expectedSign) {
    value startState = testState {
        opcode = opcode;
        register->startRegister.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, register, `State.flags`, `State.programCounter`);
    assertEquals(register.bind(endState).get(), expectedRegister.byte);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementA(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #3d;
        register = `State.registerA`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementB(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #05;
        register = `State.registerB`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementC(Integer startRegister, Integer expectedRegister,
    Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #0d;
        register = `State.registerC`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementD(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #15;
        register = `State.registerD`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementE(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #1d;
        register = `State.registerE`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementH(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #25;
        register = `State.registerH`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

test
parameters(`value testEmulateDecrementRegisterParameters`)
shared void testEmulateDecrementL(Integer startRegister, Integer expectedRegister,
        Boolean expectedParity, Boolean expectedZero, Boolean expectedSign) {
    testEmulateDecrementRegister {
        opcode = #2d;
        register = `State.registerL`;
        startRegister = startRegister;
        expectedRegister = expectedRegister;
        expectedParity = expectedParity;
        expectedZero = expectedZero;
        expectedSign = expectedSign;
    };
}

{[Integer, Integer, Integer, Boolean]*} testEmulateDoubleAddParameters = {
    [#0000, #0000, #0000, false],
    [#0123, #4567, #468a, false],
    [#abcd, #a000, #4bcd, true]
};

void testEmulateDoubleAdd(Integer opcode, ByteRegister registerHigh, ByteRegister registerLow, 
    Integer hlValue, Integer registerValue, Integer expectedValue, Boolean expectedCarry) {
    value [registerH, registerL] = bytes(hlValue);
    value [registerValueHigh, registerValueLow] = bytes(registerValue);
    value [expectedHigh, expectedLow] = bytes(expectedValue);
    value startState = testState {
        opcode = opcode;
        `State.registerH`->registerH,
        `State.registerL`->registerL,
        registerHigh->registerValueHigh,
        registerLow->registerValueLow
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerH, expectedHigh);
    assertEquals(endState.registerL, expectedLow);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

test
parameters(`value testEmulateDoubleAddParameters`)
shared void testEmulateDoubleAddB(Integer hlValue, Integer bcValue, Integer expectedValue,
        Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #09;
        registerHigh = `State.registerB`;
        registerLow = `State.registerC`;
        hlValue = hlValue;
        registerValue = bcValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}

test
parameters(`value testEmulateDoubleAddParameters`)
shared void testEmulateDoubleAddD(Integer hlValue, Integer deValue, Integer expectedValue,
        Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #19;
        registerHigh = `State.registerD`;
        registerLow = `State.registerE`;
        hlValue = hlValue;
        registerValue = deValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}

{[Integer, Integer, Boolean]*} testEmulateDoubleAddHParameters = {
    [#0000, #0000, false],
    [#0123, #0246, false],
    [#abcd, #579a, true]
};

test
parameters(`value testEmulateDoubleAddHParameters`)
shared void testEmulateDoubleAddH(Integer startValue, Integer expectedValue,
        Boolean expectedCarry) {
    testEmulateDoubleAdd {
        opcode = #29;
        registerHigh = `State.registerH`;
        registerLow = `State.registerL`;
        hlValue = startValue;
        registerValue = startValue;
        expectedValue = expectedValue;
        expectedCarry = expectedCarry;
    };
}

test
shared void testEmulateExchangeRegisters() {
    value [startH, startL] = bytes(#1234);
    value [startD, startE] = bytes(#5678);
    value startState = testState {
        opcode = #eb;
        `State.registerD`->startD,
        `State.registerE`->startE,
        `State.registerH`->startH,
        `State.registerL`->startL
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.registerD`, `State.registerE`, `State.registerH`,
        `State.registerL`, `State.programCounter`);
    assertEquals(endState.registerD, startH);
    assertEquals(endState.registerE, startL);
    assertEquals(endState.registerH, startD);
    assertEquals(endState.registerL, startE);
    
    assertEquals(cycles, 5);
}

{[Integer, Integer, Integer, Integer]*} testEmulateIncrementPairParameters = {
    [#00, #00, #00, #01],
    [#00, #09, #00, #0a],
    [#12, #34, #12, #35],
    [#12, #ff, #13, #00],
    [#ff, #ff, #00, #00]
};

void testEmulateIncrementPair(Integer opcode, ByteRegister register1, ByteRegister register2,
        Integer start1, Integer start2, Integer expected1, Integer expected2) {
    value startState = testState {
        opcode = opcode;
        register1->start1.byte,
        register2->start2.byte
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        register1, register2, `State.programCounter`);
    assertEquals(register1.bind(endState).get(), expected1.byte);
    assertEquals(register2.bind(endState).get(), expected2.byte);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairB(Integer start1, Integer start2,
        Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #03;
        register1 = `State.registerB`;
        register2 = `State.registerC`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairD(Integer start1, Integer start2,
        Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #13;
        register1 = `State.registerD`;
        register2 = `State.registerE`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}

test
parameters(`value testEmulateIncrementPairParameters`)
shared void testEmulateIncrementPairH(Integer start1, Integer start2,
    Integer expected1, Integer expected2) {
    testEmulateIncrementPair {
        opcode = #23;
        register1 = `State.registerH`;
        register2 = `State.registerL`;
        start1 = start1;
        start2 = start2;
        expected1 = expected1;
        expected2 = expected2;
    };
}

test
shared void testEmulateJump() {
    value high = #43.byte;
    value low = #21.byte;
    value address = word(high, low);
    value startState = testState {
        opcode = #c3;
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, address);
    
    assertEquals(cycles, 10);
}

void testEmulateJumpIfNot(Integer opcode, BitFlag flag, Boolean flagValue) {
    value high = #43.byte;
    value low = #21.byte;
    value address = word(high, low);
    value startState = testState {
        opcode = opcode;
        flag->flagValue,
        testStateProgramCounter + 1->low,
        testStateProgramCounter + 2->high
    };
    value [endState, cycles] = emulate(startState);
    value expectedProgramCounter = flagValue then startState.programCounter + 3 else address;
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, expectedProgramCounter);
    
    assertEquals(cycles, 10);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfNotZero(Boolean zero) {
    testEmulateJumpIfNot(#c2, `State.zero`, zero);
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

void testEmulateMoveImmediateRegister(Integer opcode, ByteRegister register) {
    value data = #4f.byte;
    value startState = testState {
        opcode = opcode;
        testStateProgramCounter + 1->data
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, register, `State.programCounter`);
    assertEquals(register.bind(endState).get(), data);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 5);
}

test
shared void testEmulateMoveImmediateA() {
    testEmulateMoveImmediateRegister(#3e, `State.registerA`);
}

test
shared void testEmulateMoveImmediateB() {
    testEmulateMoveImmediateRegister(#06, `State.registerB`);
}

test
shared void testEmulateMoveImmediateC() {
    testEmulateMoveImmediateRegister(#0e, `State.registerC`);
}

test
shared void testEmulateMoveImmediateD() {
    testEmulateMoveImmediateRegister(#16, `State.registerD`);
}

test
shared void testEmulateMoveImmediateE() {
    testEmulateMoveImmediateRegister(#1e, `State.registerE`);
}

test
shared void testEmulateMoveImmediateH() {
    testEmulateMoveImmediateRegister(#26, `State.registerH`);
}

test
shared void testEmulateMoveImmediateL() {
    testEmulateMoveImmediateRegister(#2e, `State.registerL`);
}

test
shared void testEmulateMoveImmediateMemory() {
    value high = #01.byte;
    value low = #45.byte;
    value address = word(high, low);
    value data = #77.byte;
    value startState = testState {
        opcode = #36;
        `State.registerH`->high,
        `State.registerL`->low,
        testStateProgramCounter + 1->data
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`, `State.memory`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    assertMemoriesEqual(startState, endState, address->data);
    
    assertEquals(cycles, 10);
}

void testEmulateMoveRegisters(Integer opcode, ByteRegister destinationRegister,
        ByteRegister sourceRegister) {
    value data = #23.byte;
    value startState = testState {
        opcode = opcode;
        sourceRegister->data
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, destinationRegister, `State.programCounter`);
    assertEquals(destinationRegister.bind(endState).get(), data);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 5);
}

void testEmulateMoveRegisterMemory(Integer opcode, ByteRegister register) {
    value data = #9b.byte;
    value address = #0123;
    value [high, low] = bytes(address);
    value startState = testState {
        opcode = opcode;
        `State.registerH`->high,
        `State.registerL`->low,
        address->data
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, register, `State.programCounter`);
    assertEquals(register.bind(endState).get(), data);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateMoveAA() {
    testEmulateMoveRegisters(#7f, `State.registerA`, `State.registerA`);
}

test
shared void testEmulateMoveAB() {
    testEmulateMoveRegisters(#78, `State.registerA`, `State.registerB`);
}

test
shared void testEmulateMoveAC() {
    testEmulateMoveRegisters(#79, `State.registerA`, `State.registerC`);
}

test
shared void testEmulateMoveAD() {
    testEmulateMoveRegisters(#7a, `State.registerA`, `State.registerD`);
}

test
shared void testEmulateMoveAE() {
    testEmulateMoveRegisters(#7b, `State.registerA`, `State.registerE`);
}

test
shared void testEmulateMoveAH() {
    testEmulateMoveRegisters(#7c, `State.registerA`, `State.registerH`);
}

test
shared void testEmulateMoveAL() {
    testEmulateMoveRegisters(#7d, `State.registerA`, `State.registerL`);
}

test
shared void testEmulateMoveAMemory() {
    testEmulateMoveRegisterMemory(#7e, `State.registerA`);
}

test
shared void testEmulateMoveBA() {
    testEmulateMoveRegisters(#47, `State.registerB`, `State.registerA`);
}

test
shared void testEmulateMoveBB() {
    testEmulateMoveRegisters(#40, `State.registerB`, `State.registerB`);
}

test
shared void testEmulateMoveBC() {
    testEmulateMoveRegisters(#41, `State.registerB`, `State.registerC`);
}

test
shared void testEmulateMoveBD() {
    testEmulateMoveRegisters(#42, `State.registerB`, `State.registerD`);
}

test
shared void testEmulateMoveBE() {
    testEmulateMoveRegisters(#43, `State.registerB`, `State.registerE`);
}

test
shared void testEmulateMoveBH() {
    testEmulateMoveRegisters(#44, `State.registerB`, `State.registerH`);
}

test
shared void testEmulateMoveBL() {
    testEmulateMoveRegisters(#45, `State.registerB`, `State.registerL`);
}

test
shared void testEmulateMoveBMemory() {
    testEmulateMoveRegisterMemory(#46, `State.registerB`);
}

test
shared void testEmulateMoveCA() {
    testEmulateMoveRegisters(#4f, `State.registerC`, `State.registerA`);
}

test
shared void testEmulateMoveCB() {
    testEmulateMoveRegisters(#48, `State.registerC`, `State.registerB`);
}

test
shared void testEmulateMoveCC() {
    testEmulateMoveRegisters(#49, `State.registerC`, `State.registerC`);
}

test
shared void testEmulateMoveCD() {
    testEmulateMoveRegisters(#4a, `State.registerC`, `State.registerD`);
}

test
shared void testEmulateMoveCE() {
    testEmulateMoveRegisters(#4b, `State.registerC`, `State.registerE`);
}

test
shared void testEmulateMoveCH() {
    testEmulateMoveRegisters(#4c, `State.registerC`, `State.registerH`);
}

test
shared void testEmulateMoveCL() {
    testEmulateMoveRegisters(#4d, `State.registerC`, `State.registerL`);
}

test
shared void testEmulateMoveCMemory() {
    testEmulateMoveRegisterMemory(#4e, `State.registerC`);
}

test
shared void testEmulateMoveDA() {
    testEmulateMoveRegisters(#57, `State.registerD`, `State.registerA`);
}

test
shared void testEmulateMoveDB() {
    testEmulateMoveRegisters(#50, `State.registerD`, `State.registerB`);
}

test
shared void testEmulateMoveDC() {
    testEmulateMoveRegisters(#51, `State.registerD`, `State.registerC`);
}

test
shared void testEmulateMoveDD() {
    testEmulateMoveRegisters(#52, `State.registerD`, `State.registerD`);
}

test
shared void testEmulateMoveDE() {
    testEmulateMoveRegisters(#53, `State.registerD`, `State.registerE`);
}

test
shared void testEmulateMoveDH() {
    testEmulateMoveRegisters(#54, `State.registerD`, `State.registerH`);
}

test
shared void testEmulateMoveDL() {
    testEmulateMoveRegisters(#55, `State.registerD`, `State.registerL`);
}

test
shared void testEmulateMoveDMemory() {
    testEmulateMoveRegisterMemory(#56, `State.registerD`);
}

test
shared void testEmulateMoveEA() {
    testEmulateMoveRegisters(#5f, `State.registerE`, `State.registerA`);
}

test
shared void testEmulateMoveEB() {
    testEmulateMoveRegisters(#58, `State.registerE`, `State.registerB`);
}

test
shared void testEmulateMoveEC() {
    testEmulateMoveRegisters(#59, `State.registerE`, `State.registerC`);
}

test
shared void testEmulateMoveED() {
    testEmulateMoveRegisters(#5a, `State.registerE`, `State.registerD`);
}

test
shared void testEmulateMoveEE() {
    testEmulateMoveRegisters(#5b, `State.registerE`, `State.registerE`);
}

test
shared void testEmulateMoveEH() {
    testEmulateMoveRegisters(#5c, `State.registerE`, `State.registerH`);
}

test
shared void testEmulateMoveEL() {
    testEmulateMoveRegisters(#5d, `State.registerE`, `State.registerL`);
}

test
shared void testEmulateMoveEMemory() {
    testEmulateMoveRegisterMemory(#5e, `State.registerE`);
}

test
shared void testEmulateMoveHA() {
    testEmulateMoveRegisters(#67, `State.registerH`, `State.registerA`);
}

test
shared void testEmulateMoveHB() {
    testEmulateMoveRegisters(#60, `State.registerH`, `State.registerB`);
}

test
shared void testEmulateMoveHC() {
    testEmulateMoveRegisters(#61, `State.registerH`, `State.registerC`);
}

test
shared void testEmulateMoveHD() {
    testEmulateMoveRegisters(#62, `State.registerH`, `State.registerD`);
}

test
shared void testEmulateMoveHE() {
    testEmulateMoveRegisters(#63, `State.registerH`, `State.registerE`);
}

test
shared void testEmulateMoveHH() {
    testEmulateMoveRegisters(#64, `State.registerH`, `State.registerH`);
}

test
shared void testEmulateMoveHL() {
    testEmulateMoveRegisters(#65, `State.registerH`, `State.registerL`);
}

test
shared void testEmulateMoveHMemory() {
    testEmulateMoveRegisterMemory(#66, `State.registerH`);
}

test
shared void testEmulateMoveLA() {
    testEmulateMoveRegisters(#6f, `State.registerL`, `State.registerA`);
}

test
shared void testEmulateMoveLB() {
    testEmulateMoveRegisters(#68, `State.registerL`, `State.registerB`);
}

test
shared void testEmulateMoveLC() {
    testEmulateMoveRegisters(#69, `State.registerL`, `State.registerC`);
}

test
shared void testEmulateMoveLD() {
    testEmulateMoveRegisters(#6a, `State.registerL`, `State.registerD`);
}

test
shared void testEmulateMoveLE() {
    testEmulateMoveRegisters(#6b, `State.registerL`, `State.registerE`);
}

test
shared void testEmulateMoveLH() {
    testEmulateMoveRegisters(#6c, `State.registerL`, `State.registerH`);
}

test
shared void testEmulateMoveLL() {
    testEmulateMoveRegisters(#6d, `State.registerL`, `State.registerL`);
}

test
shared void testEmulateMoveLMemory() {
    testEmulateMoveRegisterMemory(#6e, `State.registerL`);
}

void testEmulateMoveMemoryRegister(Integer opcode, ByteRegister register) {
    value high = #01.byte;
    value low = #23.byte;
    value address = word(high, low);
    value val = if (register == `State.registerH`) then high
        else if (register == `State.registerL`) then low
        else #33.byte;
    value startState = testState {
        opcode = opcode;
        register->val,
        `State.registerH`->high,
        `State.registerL`->low
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`, `State.memory`);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    assertMemoriesEqual(startState, endState, address->val);
    
    assertEquals(cycles, 7);
}

test
shared void testEmulateMoveMemoryA() {
    testEmulateMoveMemoryRegister(#77, `State.registerA`);
}

test
shared void testEmulateMoveMemoryB() {
    testEmulateMoveMemoryRegister(#70, `State.registerB`);
}

test
shared void testEmulateMoveMemoryC() {
    testEmulateMoveMemoryRegister(#71, `State.registerC`);
}

test
shared void testEmulateMoveMemoryD() {
    testEmulateMoveMemoryRegister(#72, `State.registerD`);
}

test
shared void testEmulateMoveMemoryE() {
    testEmulateMoveMemoryRegister(#73, `State.registerE`);
}

test
shared void testEmulateMoveMemoryH() {
    testEmulateMoveMemoryRegister(#74, `State.registerH`);
}

test
shared void testEmulateMoveMemoryL() {
    testEmulateMoveMemoryRegister(#75, `State.registerL`);
}

test
shared void testEmulateNoop() {
    value startState = testState {
        opcode = #00;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
shared void testOutput() {
    value startState = testState {
        opcode = #d3;
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 10);
}

void testEmulatePop(Integer opcode, ByteRegister registerHigh, ByteRegister registerLow) {
    value high = #aa.byte;
    value low = #bb.byte;
    value startState = testState {
        opcode = opcode;
        testStateStackPointer->low,
        testStateStackPointer + 1->high
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        registerHigh, registerLow, `State.stackPointer`, `State.programCounter`);
    assertEquals(registerHigh.bind(endState).get(), high);
    assertEquals(registerLow.bind(endState).get(), low);
    assertEquals(endState.stackPointer, startState.stackPointer + 2);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulatePopB() {
    testEmulatePop(#c1, `State.registerB`, `State.registerC`);
}

test
shared void testEmulatePopD() {
    testEmulatePop(#d1, `State.registerD`, `State.registerE`);
}

test
shared void testEmulatePopH() {
    testEmulatePop(#e1, `State.registerH`, `State.registerL`);
}

test
shared void testEmulatePopStatus() {
    testEmulatePop(#f1, `State.registerA`, `State.flags`);
}

void testEmulatePush(Integer opcode, ByteRegister registerHigh, ByteRegister registerLow) {
    value high = #98.byte;
    // This value can be put into the flags register, so we have to use something that fits.
    value low = #83.byte;
    value startState = testState {
        opcode = opcode;
        registerHigh->high,
        registerLow->low
    };
    value startStackPointer = startState.stackPointer;
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.memory`, `State.stackPointer`, `State.programCounter`);
    assertMemoriesEqual(startState, endState,
        startStackPointer - 1->high,
        startStackPointer - 2->low);
    assertEquals(endState.stackPointer, startStackPointer - 2);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 11);
}

test
shared void testEmulatePushB() {
    testEmulatePush {
        opcode = #c5;
        registerHigh = `State.registerB`;
        registerLow = `State.registerC`;
    };
}

test
shared void testEmulatePushD() {
    testEmulatePush {
        opcode = #d5;
        registerHigh = `State.registerD`;
        registerLow = `State.registerE`;
    };
}

test
shared void testEmulatePushH() {
    testEmulatePush {
        opcode = #e5;
        registerHigh = `State.registerH`;
        registerLow = `State.registerL`;
    };
}

test
shared void testEmulatePushStatus() {
    testEmulatePush {
        opcode = #f5;
        registerHigh = `State.registerA`;
        registerLow = `State.flags`;
    };
}

test
shared void testEmulateReturn() {
    value high = #01.byte;
    value low = #ab.byte;
    value address = word(high, low);
    value [testStateProgramCounterHigh, testStateProgramCounterLow]
            = bytes(testStateProgramCounter);
    value startState = testState {
        opcode = #c9;
        testStateStackPointer->low,
        testStateStackPointer + 1->high,
        // Simulate the CALL instruction that led us to the RET instruction.
        address->#cd.byte,
        address + 1->testStateProgramCounterLow,
        address + 2->testStateProgramCounterHigh
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.stackPointer`, `State.programCounter`);
    assertEquals(endState.stackPointer, startState.stackPointer + 2);
    assertEquals(endState.programCounter, address + 3);
    
    assertEquals(cycles, 10);
}

{[Integer, Integer, Boolean]*} testRotateAccumulatorRightParameters = {
    [#00, #00, false],
    [#01, #80, true],
    [#02, #01, false],
    [#fe, #7f, false],
    [#ff, #ff, true]
};

test
parameters(`value testRotateAccumulatorRightParameters`)
shared void testRotateAccumulatorRight(Integer initialValue, Integer expectedValue,
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
