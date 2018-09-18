"Runs the CPU diagnostic code." // TODO: Move to test module?
shared void runCpuDiagnostic() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/cpudiag.bin"));
    value memory = Array<Byte>.ofSize(#1000, 0.byte);
    value initialProgramCounter = #0100;
    
    code.copyTo {
        destination = memory;
        destinationPosition = initialProgramCounter;
    };
    
    variable value state = initialState(memory).with {
        stateProgramCounter->initialProgramCounter,
        5->Opcode.\ireturn.byte // Return from system call
    };
    
    while (true) {
        disassemble(state.memory, state.programCounter);
        
        value [result, cycles] = emulate(state);
        
        state = result;
        
        if (state.programCounter < initialProgramCounter) {
            value programCounter = state.programCounter;
            
            if (programCounter == 0) {
                print("Exiting");
                
                break;
            } else if (programCounter == 5) {
                value systemCall = state.registerC;
                
                if (systemCall == 2.byte) {
                    process.write(state.registerE.unsigned.character.string);
                } else if (systemCall == 9.byte) {
                    value output = StringBuilder();
                    variable value address = word(state.registerD, state.registerE) + 3;
                    
                    while (exists data = state.memory[address]?.unsigned?.character, data != '$') {
                        output.appendCharacter(data);
                        address++;
                    }
                    
                    print(output.string);
                } else {
                    throw Exception("System call ``systemCall`` not implemented");
                }
            } else {
                throw Exception("Jump to system code at ``programCounter`` not implemented");
            }
        }
    }
}
