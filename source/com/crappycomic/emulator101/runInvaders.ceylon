import java.lang {
    System,
    Thread
}
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
    
    "Clock divider for slower machines (my laptop) to get consistent emulation speed."
    value throttle = 1;
    value cyclesPerSecond = 2_000_000 / throttle;
    value framesPerSecond = 60 / throttle;
    value interruptsPerSecond = framesPerSecond * 2;
    value millisecondsPerSecond = 1_000;
    value millisecondsPerInterrupt = millisecondsPerSecond / interruptsPerSecond;
    value cyclesPerInterrupt = cyclesPerSecond / interruptsPerSecond;
    
    variable value state = initialState(memory, machine);
    variable value totalCycles = 0;
    variable value lastInterrupt = System.currentTimeMillis();
    
    value frame = InvadersFrame();
    value panel = frame.panel;
    value timer = Timer(true);
    
    timer.scheduleAtFixedRate(object extends TimerTask() {
        variable Opcode nextInterrupt = restart1;
        
        shared actual void run() {
            interrupt.offer(Interrupt(nextInterrupt.byte));
            
            if (nextInterrupt == restart1) {
                nextInterrupt = restart2;
            } else {
                nextInterrupt = restart1;
                panel.drawFrame(state);
            }
        }
    }, 1000, millisecondsPerInterrupt);
    
    while (true) {
        //disassemble(state.memory, state.programCounter, state.interrupt);
        
        value [result, cycles] = emulate(state);
        
        state = result;
        totalCycles += cycles;
        
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
        
        if (totalCycles >= cyclesPerInterrupt) {
            value sleep = System.currentTimeMillis() - lastInterrupt - millisecondsPerInterrupt;
            
            if (sleep > 0) {
                Thread.sleep(sleep);
            }
            
            totalCycles = 0;
            lastInterrupt = System.currentTimeMillis();
        }
    }
}
