import ceylon.test {
    assertEquals,
    assertTrue,
    fail,
    test
}

import com.crappycomic.emulator101 {
    Machine,
    State,
    emulate
}

test
shared void testEmulateInput() {
    value device = #03.byte;
    value data = #40.byte;
    value expected = device.or(data);
    
    object machine satisfies Machine {
        shared actual Byte input(Byte device) => device.or(data);
        
        shared actual void output(Byte device, Byte data) {
            fail("Machine.output should not have been called.");
        }
    }
    
    value startState = testState {
        opcode = #db;
        testStateProgramCounter + 1->device
    };
    value [endState, cycles] = emulate(startState, machine);
    
    assertStatesEqual(startState, endState, `State.registerA`, `State.programCounter`);
    assertEquals(endState.registerA, expected);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateInputNull() {
    value device = #03.byte;
    value startState = testState {
        opcode = #db;
        testStateProgramCounter + 1->device
    };
    value [endState, cycles] = emulate(startState, null);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateOutput() {
    value device = #a7.byte;
    value data = #cb.byte;
    variable value outputCalled = false;
    
    object machine satisfies Machine {
        shared actual Byte input(Byte device) {
            fail("Machine.input should not have been called.");
            
            return 0.byte;
        }
        
        shared actual void output(Byte outputDevice, Byte outputData) {
            outputCalled = true;
            assertEquals(outputDevice, device);
            assertEquals(outputData, data);
        }
    }
    
    value startState = testState {
        opcode = #d3;
        `State.registerA`->data,
        testStateProgramCounter + 1->device
    };
    value [endState, cycles] = emulate(startState, machine);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    assertTrue(outputCalled);
    
    assertEquals(cycles, 10);
}

test
shared void testEmulateOutputNull() {
    value device = #a7.byte;
    value data = #cb.byte;
    value startState = testState {
        opcode = #d3;
        `State.registerA`->data,
        testStateProgramCounter + 1->device
    };
    value [endState, cycles] = emulate(startState, null);
    
    assertStatesEqual(startState, endState, `State.programCounter`);
    assertEquals(endState.programCounter, startState.programCounter + 2);
    
    assertEquals(cycles, 10);
}
