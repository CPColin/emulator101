"Returns the address the RST instruction should jump to, based on given [[index]]."
shared Integer restartAddress(Integer index) {
    return index * 8;
}

"Extracts and returns the index bits, bits 3-5, from the given [[opcode]]."
shared Integer restartIndex(Byte opcode) {
    return opcode.and($00111000.byte).rightLogicalShift(3).unsigned;
}

[State, Integer] emulateRestart(Opcode opcode, State state) {
    value [high, low] = bytes(state.programCounter);
    value address = restartAddress(restartIndex(opcode.byte));
    
    return [
        state.with {
            state.stackPointer->high,
            state.stackPointer - 1->low,
            `State.programCounter`->address,
            `State.stackPointer`->state.stackPointer - 2
        },
        11
    ];
}
