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

"Runs the emulator on the provided input."
shared void runEmulator() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/invaders.h")
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.g"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.f"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.e")));
    value memory = Array<Byte>.ofSize(#10000, 0.byte);
    
    code.copyTo(memory);
    
    variable value state = State {
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
    };
    
    while (true) {
        disassemble(state.memory, state.programCounter);
        
        value result = emulate(state);
        
        state = result[0];
    }
}
