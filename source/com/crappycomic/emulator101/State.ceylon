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
    
    static shared Array<Byte> pokeMemory(Array<Byte> memory, <Integer->Byte>* pokes) {
        value newMemory = Array<Byte>(memory);
        
        for (address->val in pokes) {
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
    shared Array<Byte> memory;
    
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
            Array<Byte> memory) {
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
    }
    
    shared Boolean carry => flags.get(flagBitCarry);
    shared Boolean parity => flags.get(flagBitParity);
    shared Boolean auxiliaryCarry => flags.get(flagBitAuxiliaryCarry);
    shared Boolean zero => flags.get(flagBitZero);
    shared Boolean sign => flags.get(flagBitSign);
    
    "Returns a copy of this object with the given fields set to new values."
    shared State with(
            Byte registerA = this.registerA,
            Byte registerB = this.registerB,
            Byte registerC = this.registerC,
            Byte registerD = this.registerD,
            Byte registerE = this.registerE,
            Byte registerH = this.registerH,
            Byte registerL = this.registerL,
            Boolean carry = this.carry,
            Boolean parity = this.parity,
            Boolean auxiliaryCarry = this.auxiliaryCarry,
            Boolean zero = this.zero,
            Boolean sign = this.sign,
            Integer stackPointer = this.stackPointer,
            Integer programCounter = this.programCounter,
            {<Integer->Byte>*} pokes = empty) {
        return State {
            registerA = registerA;
            registerB = registerB;
            registerC = registerC;
            registerD = registerD;
            registerE = registerE;
            registerH = registerH;
            registerL = registerL;
            flags = packFlags {
                carry = carry;
                parity = parity;
                auxiliaryCarry = auxiliaryCarry;
                zero = zero;
                sign = sign;
            };
            stackPointer = stackPointer;
            programCounter = programCounter;
            memory = if (!pokes.empty) then pokeMemory(memory, *pokes) else memory;
        };
    }
}
