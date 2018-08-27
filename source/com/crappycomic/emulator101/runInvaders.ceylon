import java.util {
    Timer,
    TimerTask
}

"""Runs the "Invaders" code."""
shared void runInvaders() {
    value code = Array<Byte>(FileIterable("resource/com/crappycomic/emulator101/invaders.h")
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.g"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.f"))
            .chain(FileIterable("resource/com/crappycomic/emulator101/invaders.e")));
    value memory = Array<Byte>.ofSize(#10000, 0.byte);
    value machine = InvadersMachine();
    
    code.copyTo(memory);
    
    variable value state = initialState(memory);
    
    value frame = InvadersFrame();
    value panel = frame.panel;
    
    Timer(true).scheduleAtFixedRate(object extends TimerTask() {
        variable value which = false;
        
        shared actual void run() {
            Opcode opcode;
            
            if (which) {
                opcode = restart1;
            } else {
                opcode = restart2;
                panel.drawFrame(state);
            }
            
            interrupt.offer(Interrupt(opcode.byte));
            
            which = !which;
            
        }
    }, 2500, 10);
    
    while (true) {
        //disassemble(state.memory, state.programCounter, state.interrupt);
        
        value [result, cycles] = emulate(state, machine);
        
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
