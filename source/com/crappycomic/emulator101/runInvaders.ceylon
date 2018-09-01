import java.awt.event {
    KeyAdapter,
    KeyEvent
}
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
    value cabinet = InvadersCabinet();
    value machine = InvadersMachine(cabinet);
    
    code.copyTo(memory);
    
    "Clock divider for slower machines (my laptop) to get consistent emulation speed."
    value throttle = 3;
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
    
    frame.addKeyListener(object extends KeyAdapter() {
        shared actual void keyPressed(KeyEvent event) {
            value keyCode = event.keyCode;
            
            if (keyCode == KeyEvent.vk1) {
                cabinet.player1Start = true;
            } else if (keyCode == KeyEvent.vkLeft) {
                cabinet.player1Left = true;
            } else if (keyCode == KeyEvent.vkRight) {
                cabinet.player1Right = true;
            } else if (keyCode == KeyEvent.vkUp) {
                cabinet.player1Fire = true;
            } else if (keyCode == KeyEvent.vk2) {
                cabinet.player2Start = true;
            } else if (keyCode == KeyEvent.vkA) {
                cabinet.player2Left = true;
            } else if (keyCode == KeyEvent.vkS) {
                cabinet.player2Right = true;
            } else if (keyCode == KeyEvent.vkZ) {
                cabinet.player2Fire = true;
            } else if (keyCode == KeyEvent.vkC) {
                cabinet.coin = false;
            }
        }
        
        shared actual void keyReleased(KeyEvent event) {
            value keyCode = event.keyCode;
            
            if (keyCode == KeyEvent.vk1) {
                cabinet.player1Start = false;
            } else if (keyCode == KeyEvent.vkLeft) {
                cabinet.player1Left = false;
            } else if (keyCode == KeyEvent.vkRight) {
                cabinet.player1Right = false;
            } else if (keyCode == KeyEvent.vkUp) {
                cabinet.player1Fire = false;
            } else if (keyCode == KeyEvent.vk2) {
                cabinet.player2Start = false;
            } else if (keyCode == KeyEvent.vkA) {
                cabinet.player2Left = false;
            } else if (keyCode == KeyEvent.vkS) {
                cabinet.player2Right = false;
            } else if (keyCode == KeyEvent.vkZ) {
                cabinet.player2Fire = false;
            } else if (keyCode == KeyEvent.vkC) {
                cabinet.coin = true;
            }
        }
    });
    
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
