[State, Integer] emulateInput(State state) {
    return [
        state.with {
            stateRegisterA->state.machine.input(state.dataByte)
        },
        10
    ];
}

[State, Integer] emulateOutput(State state) {
    value machine = state.machine.output(state.dataByte, state.registerA);
    
    return [
        state.with {
            stateMachine->machine
        },
        10
    ];
}
