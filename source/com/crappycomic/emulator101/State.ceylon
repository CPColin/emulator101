import java.util {
    ArrayList
}
"The state of the Intel 8080 CPU and its attached memory."
shared class State {
    static Integer flagBitCarry = 0;
    static Integer flagBitUnusedHigh = 1;
    static Integer flagBitParity = 2;
    static Integer flagBitAuxiliaryCarry = 4;
    static Integer flagBitZero = 6;
    static Integer flagBitSign = 7;
    
    "Packs the given flags into a byte as the 8080 CPU would do it."
    static shared Byte packFlags(
            Boolean carry,
            Boolean parity,
            Boolean auxiliaryCarry,
            Boolean zero,
            Boolean sign) {
        return (carry then 1 else 0).byte.leftLogicalShift(flagBitCarry)
            .or(1.byte.leftLogicalShift(flagBitUnusedHigh))
            .or((parity then 1 else 0).byte.leftLogicalShift(flagBitParity))
            .or((auxiliaryCarry then 1 else 0).byte.leftLogicalShift(flagBitAuxiliaryCarry))
            .or((zero then 1 else 0).byte.leftLogicalShift(flagBitZero))
            .or((sign then 1 else 0).byte.leftLogicalShift(flagBitSign));
    }
    
    static shared Memory updateMemory(Memory memory, MemoryUpdate* memoryUpdates) {
        value newMemory = Array<Byte>(memory);
        
        for (address->val in memoryUpdates) {
            if (address >= 0 && address < memory.size) {
                // TODO: Handle attempts to write to ROM.
                newMemory[address] = val;
            }
        }
        
        return newMemory;
    }
    
    shared Byte registerA;
    shared Byte registerB;
    shared Byte registerC;
    shared Byte registerD;
    shared Byte registerE;
    shared Byte registerH;
    shared Byte registerL;
    shared Byte flags;
    shared Integer stackPointer;
    shared Integer programCounter;
    shared Memory memory;
    shared Boolean interruptsEnabled;
    shared Boolean stopped;
    shared Interrupt? interrupt;
    shared Machine machine;
    
    shared new (
            Byte registerA,
            Byte registerB,
            Byte registerC,
            Byte registerD,
            Byte registerE,
            Byte registerH,
            Byte registerL,
            Byte flags,
            Integer stackPointer,
            Integer programCounter,
            Memory memory,
            Boolean interruptsEnabled,
            Boolean stopped,
            Interrupt? interrupt,
            Machine machine) {
        this.registerA = registerA;
        this.registerB = registerB;
        this.registerC = registerC;
        this.registerD = registerD;
        this.registerE = registerE;
        this.registerH = registerH;
        this.registerL = registerL;
        this.flags = flags;
        this.stackPointer = stackPointer;
        this.programCounter = programCounter;
        this.memory = memory;
        this.interruptsEnabled = interruptsEnabled;
        this.stopped = stopped;
        this.interrupt = interrupt;
        this.machine = machine;
    }
    
    shared Boolean carry => flags.get(flagBitCarry);
    shared Boolean parity => flags.get(flagBitParity);
    shared Boolean auxiliaryCarry => flags.get(flagBitAuxiliaryCarry);
    shared Boolean zero => flags.get(flagBitZero);
    shared Boolean sign => flags.get(flagBitSign);
    
    shared Byte stackPointerHigh => stackPointer.rightLogicalShift(8).byte;
    shared Byte stackPointerLow => stackPointer.byte;
    
    shared Opcode opcode {
        value val = interrupt?.opcode else memory[programCounter];
        
        assert (exists val);
        
        value opcode = opcodes[val];
        
        assert (exists opcode);
        
        return opcode;
    }
    
    shared Byte dataByte => interrupt?.dataByte else memory[programCounter + 1] else 0.byte;
    shared Byte[2] dataBytes
            => interrupt?.dataBytes else (
                if (exists high = memory[programCounter + 2],
                    exists low = memory[programCounter + 1])
                then [high, low]
                else [0.byte, 0.byte]);
    shared Integer dataWord
            => interrupt?.dataWord else (
                let ([high, low] = dataBytes)
                    word(high, low));
    
    "The address that should be returned to once a CALL or RST subroutine finishes. This address
     equals the current program counter, when processing an interrupt, and equals the address of the
     subsequent operation, when not processing an interrupt."
    shared Integer returnAddress
            => if (interrupt exists)
                then programCounter
                else programCounter + opcode.size;
    
    "Returns a copy of this object with the given updates applied."
    shared State with(
            {BitFlagUpdate
                |ByteRegisterUpdate
                |IntegerRegisterUpdate
                |MachineUpdate
                |MemoryUpdate*} updates) {
        variable Byte? registerA = null;
        variable Byte? registerB = null;
        variable Byte? registerC = null;
        variable Byte? registerD = null;
        variable Byte? registerE = null;
        variable Byte? registerH = null;
        variable Byte? registerL = null;
        variable Byte? flags = null;
        variable Boolean? carry = null;
        variable Boolean? parity = null;
        variable Boolean? auxiliaryCarry = null;
        variable Boolean? zero = null;
        variable Boolean? sign = null;
        variable Integer? stackPointer = null;
        variable Byte? stackPointerHigh = null;
        variable Byte? stackPointerLow = null;
        variable Integer? programCounter = null;
        value memoryUpdates = ArrayList<Integer->Byte>();
        variable Boolean? interruptsEnabled = null;
        variable Boolean? stopped = null;
        variable Machine? machine = null;
        
        for (key->val in updates) {
            switch (val)
            case (is Boolean) {
                if (key == stateCarry) {
                    carry = val;
                } else if (key == stateParity) {
                    parity = val;
                } else if (key == stateAuxiliaryCarry) {
                    auxiliaryCarry = val;
                } else if (key == stateZero) {
                    zero = val;
                } else if (key == stateSign) {
                    sign = val;
                } else if (key == stateInterruptsEnabled) {
                    interruptsEnabled = val;
                } else if (key == stateStopped) {
                    stopped = val;
                }
            }
            case (is Byte) {
                if (key == stateRegisterA) {
                    registerA = val;
                } else if (key == stateRegisterB) {
                    registerB = val;
                } else if (key == stateRegisterC) {
                    registerC = val;
                } else if (key == stateRegisterD) {
                    registerD = val;
                } else if (key == stateRegisterE) {
                    registerE = val;
                } else if (key == stateRegisterH) {
                    registerH = val;
                } else if (key == stateRegisterL) {
                    registerL = val;
                } else if (key == stateFlags) {
                    flags = val;
                } else if (key == stateStackPointerHigh) {
                    stackPointerHigh = val;
                } else if (key == stateStackPointerLow) {
                    stackPointerLow = val;
                } else if (is Integer key) {
                    memoryUpdates.add(key->val);
                }
            }
            case (is Integer) {
                if (key == stateStackPointer) {
                    stackPointer = val;
                } else if (key == stateProgramCounter) {
                    programCounter = val;
                }
            }
            case (is Machine?) {
                if (key == stateMachine) {
                    machine = val;
                }
            }
        }
        
        return State {
            registerA = registerA else this.registerA;
            registerB = registerB else this.registerB;
            registerC = registerC else this.registerC;
            registerD = registerD else this.registerD;
            registerE = registerE else this.registerE;
            registerH = registerH else this.registerH;
            registerL = registerL else this.registerL;
            flags = flags else packFlags {
                carry = carry else this.carry;
                parity = parity else this.parity;
                auxiliaryCarry = auxiliaryCarry else this.auxiliaryCarry;
                zero = zero else this.zero;
                sign = sign else this.sign;
            };
            stackPointer = stackPointer else word {
                high = stackPointerHigh else this.stackPointerHigh;
                low = stackPointerLow else this.stackPointerLow;
            };
            programCounter = programCounter
                else (if (exists interrupt)
                    then this.programCounter
                    else this.programCounter + opcode.size);
            memory = if (!memoryUpdates.empty)
                then updateMemory(this.memory, *memoryUpdates)
                else this.memory;
            interruptsEnabled = interruptsEnabled else this.interruptsEnabled;
            stopped = stopped else this.stopped;
            interrupt = null;
            machine = machine else this.machine;
        };
        
        //value bitFlagUpdates = map(updates.narrow<BitFlagUpdate>());
        //value byteRegisterUpdates = map(updates.narrow<ByteRegisterUpdate>());
        //value integerRegisterUpdates = map(updates.narrow<IntegerRegisterUpdate>());
        //value memoryUpdates = updates.narrow<MemoryUpdate>();
        //
        //value programCounter = integerRegisterUpdates[stateProgramCounter]
        //    else (if (exists interrupt)
        //        then this.programCounter
        //        else this.programCounter + opcode.size);
        //
        //return State {
        //    registerA = byteRegisterUpdates[stateRegisterA] else registerA;
        //    registerB = byteRegisterUpdates[stateRegisterB] else registerB;
        //    registerC = byteRegisterUpdates[stateRegisterC] else registerC;
        //    registerD = byteRegisterUpdates[stateRegisterD] else registerD;
        //    registerE = byteRegisterUpdates[stateRegisterE] else registerE;
        //    registerH = byteRegisterUpdates[stateRegisterH] else registerH;
        //    registerL = byteRegisterUpdates[stateRegisterL] else registerL;
        //    flags = byteRegisterUpdates[stateFlags] else packFlags {
        //        carry = bitFlagUpdates[stateCarry] else carry;
        //        parity = bitFlagUpdates[stateParity] else parity;
        //        auxiliaryCarry = bitFlagUpdates[stateAuxiliaryCarry] else auxiliaryCarry;
        //        zero = bitFlagUpdates[stateZero] else zero;
        //        sign = bitFlagUpdates[stateSign] else sign;
        //    };
        //    stackPointer = integerRegisterUpdates[stateStackPointer] else word {
        //        high = byteRegisterUpdates[stateStackPointerHigh] else stackPointerHigh;
        //        low = byteRegisterUpdates[stateStackPointerLow] else stackPointerLow;
        //    };
        //    programCounter = programCounter;
        //    memory = if (!memoryUpdates.empty)
        //            then updateMemory(memory, *memoryUpdates)
        //            else memory;
        //    interruptsEnabled = bitFlagUpdates[stateInterruptsEnabled] else interruptsEnabled;
        //    stopped = bitFlagUpdates[stateStopped] else stopped;
        //    interrupt = null;
        //    machine = machine;
        //};
    }
    
    "Returns a copy of this object with the given [[interrupt]] ready to execute."
    shared State withInterrupt(Interrupt interrupt) {
        return State {
            registerA = registerA;
            registerB = registerB;
            registerC = registerC;
            registerD = registerD;
            registerE = registerE;
            registerH = registerH;
            registerL = registerL;
            flags = flags;
            stackPointer = stackPointer;
            programCounter = programCounter;
            memory = memory;
            interruptsEnabled = false;
            stopped = false;
            interrupt = interrupt;
            machine = machine;
        };
    }
}
