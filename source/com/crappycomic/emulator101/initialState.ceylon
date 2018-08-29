State initialState(Array<Byte> memory, Machine machine = noopMachine) => State {
    registerA = 0.byte;
    registerB = 0.byte;
    registerC = 0.byte;
    registerD = 0.byte;
    registerE = 0.byte;
    registerH = 0.byte;
    registerL = 0.byte;
    flags = State.packFlags(false, false, false, false, false);
    stackPointer = 0;
    programCounter = 0;
    memory = memory;
    interruptsEnabled = false;
    stopped = false;
    interrupt = null;
    machine = machine;
};
