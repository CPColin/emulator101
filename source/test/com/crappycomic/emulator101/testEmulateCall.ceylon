import ceylon.test {
    assertEquals,
    assertNull,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    BitFlag,
    Interrupt,
    State,
    bytes,
    emulate,
    word
}

void testEmulateCallIf(Integer opcode, BitFlag flag, Boolean flagValue, Boolean(Boolean) taken,
        Boolean withInterrupt) {
    value addressHigh = #33.byte;
    value addressLow = #44.byte;
    value address = word(addressHigh, addressLow);
    value testState = package.testState {
        opcode = opcode;
        flag->flagValue,
        testStateProgramCounter + 1->addressLow,
        testStateProgramCounter + 2->addressHigh
    };
    State startState;
    Integer returnAddress;
    
    if (withInterrupt) {
        startState = testState.withInterrupt(Interrupt(opcode.byte));
        returnAddress = startState.programCounter;
    } else {
        startState = testState;
        returnAddress = startState.programCounter + 3;
    }
    
    value [returnAddressHigh, returnAddressLow] = bytes(returnAddress);
    value [endState, cycles] = emulate(startState);
    
    if (taken(flagValue)) {
        if (withInterrupt) {
            assertStatesEqual(startState, endState,
                `State.stackPointer`, `State.programCounter`, `State.memory`, `State.interrupt`);
            assertNull(endState.interrupt);
        } else {
            assertStatesEqual(startState, endState,
                `State.stackPointer`, `State.programCounter`, `State.memory`);
        }
        
        assertEquals(endState.stackPointer, startState.stackPointer - 2);
        assertEquals(endState.programCounter, address);
        assertMemoriesEqual(startState, endState,
            endState.stackPointer->returnAddressLow,
            endState.stackPointer + 1->returnAddressHigh);
        
        assertEquals(cycles, 17);
    } else {
        if (withInterrupt) {
            assertStatesEqual(startState, endState, `State.interrupt`);
            assertNull(endState.interrupt);
        } else {
            assertStatesEqual(startState, endState, `State.programCounter`);
            assertEquals(endState.programCounter, startState.programCounter + 3);
        }
        
        assertEquals(cycles, 11);
    }
}

{[BitFlag, Boolean, Boolean]*} testTakenWithInterruptParameters
        = secondProduct(testTakenParameters, testBooleanParameters);

test
parameters(`value testTakenWithInterruptParameters`)
shared void testEmulateCall(BitFlag flag, Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#cd, flag, flagValue, isAlwaysTaken, withInterrupt);
}

{[Boolean, Boolean]*} testBooleanWithInterruptParameters
        = testBooleanParameters.product(testBooleanParameters);

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfNotZero(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#c4, `State.zero`, flagValue, isNotTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfZero(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#cc, `State.zero`, flagValue, isTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfNoCarry(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#d4, `State.carry`, flagValue, isNotTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfCarry(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#dc, `State.carry`, flagValue, isTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfParityOdd(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#e4, `State.parity`, flagValue, isNotTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfParityEven(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#ec, `State.parity`, flagValue, isTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfPlus(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#f4, `State.sign`, flagValue, isNotTaken, withInterrupt);
}

test
parameters(`value testBooleanWithInterruptParameters`)
shared void testEmulateCallIfMinus(Boolean flagValue, Boolean withInterrupt) {
    testEmulateCallIf(#fc, `State.sign`, flagValue, isTaken, withInterrupt);
}
