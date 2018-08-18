import java.io {
    BufferedInputStream,
    FileInputStream
}

class FileIterable(String path) satisfies Iterable<Byte> {
    value stream = BufferedInputStream(FileInputStream(path));
    
    shared actual Iterator<Byte> iterator() => object satisfies Iterator<Byte> {
        shared actual Byte|Finished next() {
            value byte = stream.read();
            
            if (byte == -1) {
                stream.close();
                
                return finished;
            } else {
                return byte.byte;
            }
        }
    };
}

State initialState(Array<Byte> memory, Integer initialProgramCounter) => State {
        registerA = 0.byte;
        registerB = 0.byte;
        registerC = 0.byte;
        registerD = 0.byte;
        registerE = 0.byte;
        registerH = 0.byte;
        registerL = 0.byte;
        flags = State.packFlags(false, false, false, false, false);
        stackPointer = 0;
        programCounter = initialProgramCounter;
        memory = memory;
        interruptsEnabled = false;
    };

"Runs the disassembler on the provided input."
shared void runDisassembler() {
    value iterable = FileIterable("resource/com/crappycomic/emulator101/invaders.h")
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.g"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.f"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.e"));
    value bytes = iterable.sequence();
    variable value address = 0;
    
    while (address < bytes.size) {
        value size = disassemble(bytes, address);
        
        address += size;
    }
}

"Runs the CPU diagnostic code."
shared void runCpuDiagnostic() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/cpudiag.bin"));
    value memory = Array<Byte>.ofSize(#1000, 0.byte);
    value initialProgramCounter = #0100;
    
    code.copyTo {
        destination = memory;
        destinationPosition = initialProgramCounter;
    };
    
    variable value state = initialState(memory, initialProgramCounter);
    
    while (true) {
        disassemble(state.memory, state.programCounter);
        
        value result = emulate(state);
        
        state = result[0];
        
        if (state.programCounter < initialProgramCounter) {
            throw Exception("TODO");
        }
    }
}

"""Runs the "Invaders" code."""
shared void runInvaders() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/invaders.h")
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.g"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.f"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.e")));
    value memory = Array<Byte>.ofSize(#10000, 0.byte);
    
    code.copyTo(memory);
    
    variable value state = initialState(memory, 0);
    
    while (true) {
        disassemble(state.memory, state.programCounter);
        
        value result = emulate(state);
        
        state = result[0];
    }
}
