[State, Integer] emulateInput(State state, Machine? machine) {
    return [
        state.with {
            `State.registerA`->(machine?.input(dataByte(state)) else state.registerA),
            `State.programCounter`->state.programCounter + input.size
        },
        10
    ];
}

[State, Integer] emulateOutput(State state, Machine? machine) {
    if (exists machine) {
        machine.output(dataByte(state), state.registerA);
    }
    
    return [
        state.with {
            `State.programCounter`->state.programCounter + output.size
        },
        10
    ];
}
