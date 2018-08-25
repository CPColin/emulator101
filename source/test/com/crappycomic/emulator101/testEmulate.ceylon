import ceylon.language.meta.model {
    Attribute
}
import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    BitFlag,
    BitFlagUpdate,
    ByteRegister,
    ByteRegisterUpdate,
    IntegerRegisterUpdate,
    MemoryUpdate,
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

Boolean isAlwaysTaken(Boolean flagValue) => true;

Boolean isTaken(Boolean flagValue) => flagValue;

Boolean isNotTaken(Boolean flagValue) => !flagValue;

{[BitFlag, Boolean]*} testTakenParameters = {
    [`State.carry`, false],
    [`State.carry`, true],
    [`State.parity`, false],
    [`State.parity`, true],
    [`State.auxiliaryCarry`, false],
    [`State.auxiliaryCarry`, true],
    [`State.zero`, false],
    [`State.zero`, true],
    [`State.sign`, false],
    [`State.sign`, true]
};

Integer testStateMemorySize = #0200;

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
        memory = Array<Byte>.ofSize(testStateMemorySize, #ff.byte);
        interruptsEnabled = false;
        stopped = false;
    }.with {
        testStateProgramCounter->opcode.byte, // TODO: could cause a bug if stack pointer is updated
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
    
    if (!except.containsAny(
            {`State.stackPointer`, `State.stackPointerHigh`, `State.stackPointerLow`})) {
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
    
    if (!except.contains(`State.interruptsEnabled`)) {
        assertEquals(endState.interruptsEnabled, startState.interruptsEnabled,
            "Interrupts Enabled flag should not have changed.");
    }
    
    if (!except.contains(`State.stopped`)) {
        assertEquals(endState.stopped, startState.stopped,
            "Stopped flag should not have changed.");
    }
}

void testEmulateCallIf(Integer opcode, BitFlag flag, Boolean flagValue, Boolean(Boolean) taken) {
    value addressHigh = #33.byte;
    value addressLow = #44.byte;
    value address = word(addressHigh, addressLow);
    value [startProgramCounterHigh, startProgramCounterLow] = bytes(testStateProgramCounter);
    value startState = testState {
        opcode = opcode;
        flag->flagValue,
        testStateProgramCounter + 1->addressLow,
        testStateProgramCounter + 2->addressHigh
    };
    value [endState, cycles] = emulate(startState);
    
    if (taken(flagValue)) {
        assertStatesEqual(startState, endState,
            `State.stackPointer`, `State.programCounter`, `State.memory`);
        assertEquals(endState.stackPointer, startState.stackPointer - 2);
        assertEquals(endState.programCounter, address);
        assertMemoriesEqual(startState, endState,
            endState.stackPointer->startProgramCounterLow,
            endState.stackPointer + 1->startProgramCounterHigh);
        
        assertEquals(cycles, 17);
    } else {
        assertStatesEqual(startState, endState, `State.programCounter`);
        assertEquals(endState.programCounter, startState.programCounter + 3);
        
        assertEquals(cycles, 11);
    }
}

test
parameters(`value testTakenParameters`)
shared void testEmulateCall(BitFlag flag, Boolean flagValue) {
    testEmulateCallIf(#cd, flag, flagValue, isAlwaysTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfNotZero(Boolean flagValue) {
    testEmulateCallIf(#c4, `State.zero`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfZero(Boolean flagValue) {
    testEmulateCallIf(#cc, `State.zero`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfNoCarry(Boolean flagValue) {
    testEmulateCallIf(#d4, `State.carry`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfCarry(Boolean flagValue) {
    testEmulateCallIf(#dc, `State.carry`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfParityOdd(Boolean flagValue) {
    testEmulateCallIf(#e4, `State.parity`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfParityEven(Boolean flagValue) {
    testEmulateCallIf(#ec, `State.parity`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfPlus(Boolean flagValue) {
    testEmulateCallIf(#f4, `State.sign`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateCallIfMinus(Boolean flagValue) {
    testEmulateCallIf(#fc, `State.sign`, flagValue, isTaken);
}

test
parameters(`value testRegisterParameters`)
shared void testEmulateComplementAccumulator(Byte registerValue) {
    value startState = testState {
        opcode = #2f;
        `State.registerA`->registerValue
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, registerValue.not);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateComplementCarry(Boolean carry) {
    value startState = testState {
        opcode = #3f;
        `State.carry`->carry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = !carry;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
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

test
shared void testEmulateExchangeStack() {
    value address = #0156;
    value hlData = #7654;
    value [hlHigh, hlLow] = bytes(hlData);
    value stackData = #face;
    value [stackHigh, stackLow] = bytes(stackData);
    value startState = testState {
        opcode = #e3;
        `State.stackPointer`->address,
        `State.registerH`->hlHigh,
        `State.registerL`->hlLow,
        address->stackLow,
        address + 1->stackHigh
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerH`, `State.registerL`, `State.memory`, `State.programCounter`);
    assertEquals(endState.registerH, stackHigh);
    assertEquals(endState.registerL, stackLow);
    assertEquals(endState.memory[address + 1], hlHigh);
    assertEquals(endState.memory[address], hlLow);
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 18);
}

void testEmulateJumpIf(Integer opcode, BitFlag flag, Boolean flagValue, Boolean(Boolean) taken) {
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
    value expectedProgramCounter = taken(flagValue) then address else startState.programCounter + 3;
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, expectedProgramCounter);
    
    assertEquals(cycles, 10);
}

test
parameters(`value testTakenParameters`)
shared void testEmulateJump(BitFlag flag, Boolean flagValue) {
    testEmulateJumpIf(#c3, flag, flagValue, isAlwaysTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfNotZero(Boolean flagValue) {
    testEmulateJumpIf(#c2, `State.zero`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfZero(Boolean flagValue) {
    testEmulateJumpIf(#ca, `State.zero`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfNoCarry(Boolean flagValue) {
    testEmulateJumpIf(#d2, `State.carry`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfCarry(Boolean flagValue) {
    testEmulateJumpIf(#da, `State.carry`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfParityOdd(Boolean flagValue) {
    testEmulateJumpIf(#e2, `State.parity`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfParityEven(Boolean flagValue) {
    testEmulateJumpIf(#ea, `State.parity`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfPlus(Boolean flagValue) {
    testEmulateJumpIf(#f2, `State.sign`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateJumpIfMinus(Boolean flagValue) {
    testEmulateJumpIf(#fa, `State.sign`, flagValue, isTaken);
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

void testEmulateReturnIf(Integer opcode, BitFlag flag, Boolean flagValue, Boolean(Boolean) taken,
        Integer takenCycles = 11) {
    value high = #01.byte;
    value low = #ab.byte;
    value address = word(high, low);
    value [testStateProgramCounterHigh, testStateProgramCounterLow]
            = bytes(testStateProgramCounter);
    value startState = testState {
        opcode = opcode;
        flag->flagValue,
        testStateStackPointer->low,
        testStateStackPointer + 1->high,
        // Simulate the CALL instruction that led us to the RET instruction.
        address->#cd.byte,
        address + 1->testStateProgramCounterLow,
        address + 2->testStateProgramCounterHigh
    };
    value [endState, cycles] = emulate(startState);
    
    if (taken(flagValue)) {
        assertStatesEqual(startState, endState, `State.stackPointer`, `State.programCounter`);
        assertEquals(endState.stackPointer, startState.stackPointer + 2);
        assertEquals(endState.programCounter, address + 3);
        
        assertEquals(cycles, takenCycles);
    } else {
        assertStatesEqual(startState, endState, `State.programCounter`);
        assertEquals(endState.programCounter, startState.programCounter + 1);
        
        assertEquals(cycles, 5);
    }
}

test
parameters(`value testTakenParameters`)
shared void testEmulateReturn(BitFlag flag, Boolean flagValue) {
    testEmulateReturnIf(#c9, flag, flagValue, isAlwaysTaken, 10);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfNotZero(Boolean flagValue) {
    testEmulateReturnIf(#c0, `State.zero`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfZero(Boolean flagValue) {
    testEmulateReturnIf(#c8, `State.zero`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfNoCarry(Boolean flagValue) {
    testEmulateReturnIf(#d0, `State.carry`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfCarry(Boolean flagValue) {
    testEmulateReturnIf(#d8, `State.carry`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfParityOdd(Boolean flagValue) {
    testEmulateReturnIf(#e0, `State.parity`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfParityEven(Boolean flagValue) {
    testEmulateReturnIf(#e8, `State.parity`, flagValue, isTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfPlus(Boolean flagValue) {
    testEmulateReturnIf(#f0, `State.sign`, flagValue, isNotTaken);
}

test
parameters(`value testBooleanParameters`)
shared void testEmulateReturnIfMinus(Boolean flagValue) {
    testEmulateReturnIf(#f8, `State.sign`, flagValue, isTaken);
}

test
shared void testEmulateSetCarry() {
    value startState = testState {
        opcode = #37;
        `State.carry`->false
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState, `State.flags`, `State.programCounter`);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = true;
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}

{[Boolean, Boolean, Boolean, Boolean]*} testFlagAuxiliaryCarryParameters = {
    [false, false, false, false],
    [false, false, true, true],
    [false, true, false, true],
    [false, true, true, false],
    [true, false, false, true],
    [true, false, true, false],
    [true, true, false, false],
    [true, true, true, true]
};

test
parameters(`value testFlagAuxiliaryCarryParameters`)
shared void testFlagAuxiliaryCarry(Boolean leftBit, Boolean rightBit, Boolean resultBit,
        Boolean expected) {
    value left = 0.byte.set(4, leftBit);
    value right = 0.byte.set(4, rightBit);
    value result = 0.byte.set(4, resultBit);
    
    assertEquals(flagAuxiliaryCarry(left, right, result), expected);
}

test
parameters(`value testBooleanParameters`)
shared void testFlagCarry(Boolean bit) {
    value val = bit then #100 else #0ff;
    
    assertEquals(flagCarry(val), bit);
}

test
parameters(`value testByteParameters`)
shared void testFlagParity(Byte byte) {
    value bitCount = {
        for (bit in 0:8)
            byte.get(bit)
    }.count(identity);
    
    assertEquals(flagParity(byte), bitCount % 2 == 0);
}

test
parameters(`value testByteParameters`)
shared void testFlagSign(Byte byte) {
    assertEquals(flagSign(byte), byte.signed < 0);
}

test
parameters(`value testByteParameters`)
shared void testFlagZero(Byte byte) {
    assertEquals(flagZero(byte), byte.zero);
}
