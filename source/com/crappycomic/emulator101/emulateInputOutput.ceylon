[State, Integer] emulateInput(State state, Machine? machine) {
    return [
        state.with {
            `State.registerA`->(machine?.input(state.dataByte) else state.registerA)
        },
        10
    ];
}

[State, Integer] emulateOutput(State state, Machine? machine) {
    if (exists machine) {
        machine.output(state.dataByte, state.registerA);
    }
    
    return [
        state.with {},
        10
    ];
}
