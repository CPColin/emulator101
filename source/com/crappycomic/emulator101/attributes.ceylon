shared ByteRegister stateRegisterA = `State.registerA`;
shared ByteRegister stateRegisterB = `State.registerB`;
shared ByteRegister stateRegisterC = `State.registerC`;
shared ByteRegister stateRegisterD = `State.registerD`;
shared ByteRegister stateRegisterE = `State.registerE`;
shared ByteRegister stateRegisterH = `State.registerH`;
shared ByteRegister stateRegisterL = `State.registerL`;

shared ByteRegister stateFlags = `State.flags`;
shared BitFlag stateCarry = `State.carry`;
shared BitFlag stateParity = `State.parity`;
shared BitFlag stateAuxiliaryCarry = `State.auxiliaryCarry`;
shared BitFlag stateZero = `State.zero`;
shared BitFlag stateSign = `State.sign`;

shared IntegerRegister stateStackPointer = `State.stackPointer`;
shared ByteRegister stateStackPointerHigh = `State.stackPointerHigh`;
shared ByteRegister stateStackPointerLow = `State.stackPointerLow`;

shared IntegerRegister stateProgramCounter = `State.programCounter`;

shared BitFlag stateStopped = `State.stopped`;
shared BitFlag stateInterruptsEnabled = `State.interruptsEnabled`;

shared MachineAttribute stateMachine = `State.machine`;
