import java.io {
    BufferedInputStream,
    FileInputStream
}
import java.util {
    Timer,
    TimerTask
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

State initialState(Array<Byte> memory) => State {
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
        `State.programCounter`->initialProgramCounter,
        5->\ireturn.byte // Return from system call
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

"""Runs the "Invaders" code."""
shared void runInvaders() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/invaders.h")
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.g"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.f"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.e")));
    value memory = Array<Byte>.ofSize(#10000, 0.byte);
    
    code.copyTo(memory);
    
    variable value state = initialState(memory);
    
    Timer(true).scheduleAtFixedRate(object extends TimerTask() {
        variable value which = false;
        
        shared actual void run() {
            Opcode opcode;
            
            if (which) {
                opcode = restart1;
            } else {
                opcode = restart2;
            }
            
            interrupt.offer(Interrupt(opcode.byte));
            which = !which;
        }
    }, 5000, 1000);
    
    while (true) {
        disassemble(state.memory, state.programCounter, state.interrupt);
        
        value [result, cycles] = emulate(state);
        
        state = result;
        
        if (state.interruptsEnabled) {
            Interrupt? interrupt;
            
            if (state.stopped) {
                print("Processor stopped. Waiting for interrupt.");
                
                interrupt = package.interrupt.take();
            } else {
                interrupt = package.interrupt.poll();
            }
            
            if (exists interrupt) {
                state = state.withInterrupt(interrupt);
            }
        } else {
            if (state.stopped) {
                print("Processor stopped with interrupts disabled. Exiting.");
                
                break;
            } else {
                package.interrupt.clear();
            }
        }
    }
}
