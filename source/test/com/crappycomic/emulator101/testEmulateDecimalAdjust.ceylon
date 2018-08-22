import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State,
    emulate,
    flagParity,
    flagSign,
    flagZero
}

{[Byte, Boolean, Boolean]*} testEmulateDecimalAdjustParameters
        = tripleProduct(testRegisterParameters, testBooleanParameters, testBooleanParameters);

test
parameters(`value testEmulateDecimalAdjustParameters`)
shared void testEmulateDecimalAdjust(Byte registerValue, Boolean carry, Boolean auxiliaryCarry) {
    variable Byte expectedValue = registerValue;
    Boolean expectedAuxiliaryCarry;
    Boolean expectedCarry;
    
    if (auxiliaryCarry || expectedValue.and(#0f.byte).unsigned > #09) {
        expectedValue = expectedValue.neighbour(#06);
        expectedAuxiliaryCarry = true;
    } else {
        expectedAuxiliaryCarry = false;
    }
    
    if (carry || expectedValue.and(#f0.byte).unsigned > #90) {
        expectedValue = expectedValue.neighbour(#60);
        expectedCarry = true;
    } else {
        expectedCarry = carry;
    }
    
    value startState = testState {
        opcode = #27;
        `State.registerA`->registerValue,
        `State.carry`->carry,
        `State.auxiliaryCarry`->auxiliaryCarry
    };
    value [endState, cycles] = emulate(startState);
    
    assertStatesEqual(startState, endState,
        `State.registerA`, `State.flags`, `State.programCounter`);
    assertEquals(endState.registerA, expectedValue);
    assertFlags {
        startState = startState;
        endState = endState;
        expectedCarry = expectedCarry;
        expectedParity = flagParity(expectedValue);
        expectedAuxiliaryCarry = expectedAuxiliaryCarry;
        expectedZero = flagZero(expectedValue);
        expectedSign = flagSign(expectedValue);
    };
    assertEquals(endState.programCounter, startState.programCounter + 1);
    
    assertEquals(cycles, 4);
}
