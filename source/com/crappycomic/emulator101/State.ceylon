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
            // TODO: Handle attempts to write to ROM.
            newMemory[address] = val;
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
            Boolean stopped) {
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
    }
    
    shared Boolean carry => flags.get(flagBitCarry);
    shared Boolean parity => flags.get(flagBitParity);
    shared Boolean auxiliaryCarry => flags.get(flagBitAuxiliaryCarry);
    shared Boolean zero => flags.get(flagBitZero);
    shared Boolean sign => flags.get(flagBitSign);
    
    shared Byte stackPointerHigh => stackPointer.rightLogicalShift(8).byte;
    shared Byte stackPointerLow => stackPointer.byte;
    
    "Returns a copy of this object with the given updates applied."
    shared State with(
            {BitFlagUpdate|ByteRegisterUpdate|IntegerRegisterUpdate|MemoryUpdate*} updates) {
        value bitFlagUpdates = map(updates.narrow<BitFlagUpdate>());
        value byteRegisterUpdates = map(updates.narrow<ByteRegisterUpdate>());
        value integerRegisterUpdates = map(updates.narrow<IntegerRegisterUpdate>());
        value memoryUpdates = updates.narrow<MemoryUpdate>();
        
        return State {
            registerA = byteRegisterUpdates[`State.registerA`] else registerA;
            registerB = byteRegisterUpdates[`State.registerB`] else registerB;
            registerC = byteRegisterUpdates[`State.registerC`] else registerC;
            registerD = byteRegisterUpdates[`State.registerD`] else registerD;
            registerE = byteRegisterUpdates[`State.registerE`] else registerE;
            registerH = byteRegisterUpdates[`State.registerH`] else registerH;
            registerL = byteRegisterUpdates[`State.registerL`] else registerL;
            flags = byteRegisterUpdates[`State.flags`] else packFlags {
                carry = bitFlagUpdates[`State.carry`] else carry;
                parity = bitFlagUpdates[`State.parity`] else parity;
                auxiliaryCarry = bitFlagUpdates[`State.auxiliaryCarry`] else auxiliaryCarry;
                zero = bitFlagUpdates[`State.zero`] else zero;
                sign = bitFlagUpdates[`State.sign`] else sign;
            };
            stackPointer = integerRegisterUpdates[`State.stackPointer`] else word {
                high = byteRegisterUpdates[`State.stackPointerHigh`] else stackPointerHigh;
                low = byteRegisterUpdates[`State.stackPointerLow`] else stackPointerLow;
            };
            programCounter = integerRegisterUpdates[`State.programCounter`] else programCounter;
            memory = if (!memoryUpdates.empty)
                    then updateMemory(memory, *memoryUpdates)
                    else memory;
            interruptsEnabled = bitFlagUpdates[`State.interruptsEnabled`] else interruptsEnabled;
            stopped = bitFlagUpdates[`State.stopped`] else stopped;
        };
    }
}
