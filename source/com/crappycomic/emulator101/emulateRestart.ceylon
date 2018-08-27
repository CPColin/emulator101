"Returns the address the RST instruction should jump to, based on given [[index]]."
shared Integer restartAddress(Integer index) {
    return index * 8;
}

"Extracts and returns the index bits, bits 3-5, from the given [[opcode]]."
shared Integer restartIndex(Byte opcode) {
    return opcode.and($00111000.byte).rightLogicalShift(3).unsigned;
}

[State, Integer] emulateRestart(State state) {
    value [high, low] = bytes(state.returnAddress);
    value address = restartAddress(restartIndex(state.opcode.byte));
    
    return [
        state.with {
            state.stackPointer - 1->high,
            state.stackPointer - 2->low,
            stateProgramCounter->address,
            stateStackPointer->state.stackPointer - 2
        },
        11
    ];
}
