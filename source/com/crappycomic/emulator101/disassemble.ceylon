import java.lang {
    JInteger=Integer,
    JString=String
}

String format(Byte|Integer val, Integer width) {
    JInteger integer;
    
    if (is Byte val) {
        integer = JInteger(val.unsigned);
    } else {
        integer = JInteger(val);
    }
    
    return JString.format("%0``width``x", integer);
}

[String, String?] mnemonicAndArguments(Opcode opcode)
        => switch (opcode)
            case (addA) ["ADD", "A"]
            case (addB) ["ADD", "B"]
            case (addC) ["ADD", "C"]
            case (addD) ["ADD", "D"]
            case (addE) ["ADD", "E"]
            case (addH) ["ADD", "H"]
            case (addL) ["ADD", "L"]
            case (addMemory) ["ADD", "M"]
            case (addImmediate) ["ADI", "#"]
            case (addAWithCarry) ["ADC", "A"]
            case (addBWithCarry) ["ADC", "B"]
            case (addCWithCarry) ["ADC", "C"]
            case (addDWithCarry) ["ADC", "D"]
            case (addEWithCarry) ["ADC", "E"]
            case (addHWithCarry) ["ADC", "H"]
            case (addLWithCarry) ["ADC", "L"]
            case (addMemoryWithCarry) ["ADC", "M"]
            case (addImmediateWithCarry) ["ACI", "#"]
            case (andA) ["ANA", "A"]
            case (andB) ["ANA", "B"]
            case (andC) ["ANA", "C"]
            case (andD) ["ANA", "D"]
            case (andE) ["ANA", "E"]
            case (andH) ["ANA", "H"]
            case (andL) ["ANA", "L"]
            case (andMemory) ["ANA", "M"]
            case (andImmediate) ["ANI", "#"]
            case (call) ["CALL", "$"]
            case (callIfCarry) ["CC", "$"]
            case (callIfMinus) ["CM", "$"]
            case (callIfNoCarry) ["CNC", "$"]
            case (callIfNotZero) ["CNZ", "$"]
            case (callIfParityEven) ["CPE", "$"]
            case (callIfParityOdd) ["CPO", "$"]
            case (callIfPlus) ["CP", "$"]
            case (callIfZero) ["CZ", "$"]
            case (compareA) ["CMP", "A"]
            case (compareB) ["CMP", "B"]
            case (compareC) ["CMP", "C"]
            case (compareD) ["CMP", "D"]
            case (compareE) ["CMP", "E"]
            case (compareH) ["CMP", "H"]
            case (compareL) ["CMP", "L"]
            case (compareMemory) ["CMP", "M"]
            case (compareImmediate) ["CPI", "#"]
            case (decimalAdjust) ["DAA", null]
            case (decrementA) ["DCR", "A"]
            case (decrementB) ["DCR", "B"]
            case (decrementC) ["DCR", "C"]
            case (decrementD) ["DCR", "D"]
            case (decrementE) ["DCR", "E"]
            case (decrementH) ["DCR", "H"]
            case (decrementL) ["DCR", "L"]
            case (decrementMemory) ["DCR", "M"]
            case (decrementPairB) ["DCX", "B"]
            case (decrementPairD) ["DCX", "D"]
            case (decrementPairH) ["DCX", "H"]
            case (disableInterrupts) ["DI", null]
            case (doubleAddB) ["DAD", "B"]
            case (doubleAddD) ["DAD", "D"]
            case (doubleAddH) ["DAD", "H"]
            case (enableInterrupts) ["EI", null]
            case (exchangeRegisters) ["XCHG", null]
            case (halt) ["HLT", null]
            case (incrementA) ["INR", "A"]
            case (incrementB) ["INR", "B"]
            case (incrementC) ["INR", "C"]
            case (incrementD) ["INR", "D"]
            case (incrementE) ["INR", "E"]
            case (incrementH) ["INR", "H"]
            case (incrementL) ["INR", "L"]
            case (incrementMemory) ["INR", "M"]
            case (incrementPairB) ["INX", "B"]
            case (incrementPairD) ["INX", "D"]
            case (incrementPairH) ["INX", "H"]
            case (input) ["IN", "#"]
            case (jump) ["JMP", "$"]
            case (jumpIfCarry) ["JC", "$"]
            case (jumpIfMinus) ["JM", "$"]
            case (jumpIfNoCarry) ["JNC", "$"]
            case (jumpIfNotZero) ["JNZ", "$"]
            case (jumpIfParityEven) ["JPE", "$"]
            case (jumpIfParityOdd) ["JPO", "$"]
            case (jumpIfPlus) ["JP", "$"]
            case (jumpIfZero) ["JZ", "$"]
            case (loadAccumulatorB) ["LDAX", "B"]
            case (loadAccumulatorD) ["LDAX", "D"]
            case (loadAccumulatorDirect) ["LDA", "$"]
            case (loadHLDirect) ["LHLD", "$"]
            case (loadPairImmediateB) ["LXI", "B,#"]
            case (loadPairImmediateD) ["LXI", "D,#"]
            case (loadPairImmediateH) ["LXI", "H,#"]
            case (loadPairImmediateStackPointer) ["LXI", "SP,#"]
            case (moveImmediateA) ["MVI", "A,#"]
            case (moveImmediateB) ["MVI", "B,#"]
            case (moveImmediateC) ["MVI", "C,#"]
            case (moveImmediateD) ["MVI", "D,#"]
            case (moveImmediateE) ["MVI", "E,#"]
            case (moveImmediateH) ["MVI", "H,#"]
            case (moveImmediateL) ["MVI", "L,#"]
            case (moveImmediateMemory) ["MVI", "M,#"]
            case (moveAA) ["MOV", "A,A"]
            case (moveAB) ["MOV", "A,B"]
            case (moveAC) ["MOV", "A,C"]
            case (moveAD) ["MOV", "A,D"]
            case (moveAE) ["MOV", "A,E"]
            case (moveAH) ["MOV", "A,H"]
            case (moveAL) ["MOV", "A,L"]
            case (moveAMemory) ["MOV", "A,M"]
            case (moveBA) ["MOV", "B,A"]
            case (moveBB) ["MOV", "B,B"]
            case (moveBC) ["MOV", "B,C"]
            case (moveBD) ["MOV", "B,D"]
            case (moveBE) ["MOV", "B,E"]
            case (moveBH) ["MOV", "B,H"]
            case (moveBL) ["MOV", "B,L"]
            case (moveBMemory) ["MOV", "B,M"]
            case (moveCA) ["MOV", "C,A"]
            case (moveCB) ["MOV", "C,B"]
            case (moveCC) ["MOV", "C,C"]
            case (moveCD) ["MOV", "C,D"]
            case (moveCE) ["MOV", "C,E"]
            case (moveCH) ["MOV", "C,H"]
            case (moveCL) ["MOV", "C,L"]
            case (moveCMemory) ["MOV", "C,M"]
            case (moveDA) ["MOV", "D,A"]
            case (moveDB) ["MOV", "D,B"]
            case (moveDC) ["MOV", "D,C"]
            case (moveDD) ["MOV", "D,D"]
            case (moveDE) ["MOV", "D,E"]
            case (moveDH) ["MOV", "D,H"]
            case (moveDL) ["MOV", "D,L"]
            case (moveDMemory) ["MOV", "D,M"]
            case (moveEA) ["MOV", "E,A"]
            case (moveEB) ["MOV", "E,B"]
            case (moveEC) ["MOV", "E,C"]
            case (moveED) ["MOV", "E,D"]
            case (moveEE) ["MOV", "E,E"]
            case (moveEH) ["MOV", "E,H"]
            case (moveEL) ["MOV", "E,L"]
            case (moveEMemory) ["MOV", "E,M"]
            case (moveHA) ["MOV", "H,A"]
            case (moveHB) ["MOV", "H,B"]
            case (moveHC) ["MOV", "H,C"]
            case (moveHD) ["MOV", "H,D"]
            case (moveHE) ["MOV", "H,E"]
            case (moveHH) ["MOV", "H,H"]
            case (moveHL) ["MOV", "H,L"]
            case (moveHMemory) ["MOV", "H,M"]
            case (moveLA) ["MOV", "L,A"]
            case (moveLB) ["MOV", "L,B"]
            case (moveLC) ["MOV", "L,C"]
            case (moveLD) ["MOV", "L,D"]
            case (moveLE) ["MOV", "L,E"]
            case (moveLH) ["MOV", "L,H"]
            case (moveLL) ["MOV", "L,L"]
            case (moveLMemory) ["MOV", "L,M"]
            case (moveMemoryA) ["MOV", "M,A"]
            case (moveMemoryB) ["MOV", "M,B"]
            case (moveMemoryC) ["MOV", "M,C"]
            case (moveMemoryD) ["MOV", "M,D"]
            case (moveMemoryE) ["MOV", "M,E"]
            case (moveMemoryH) ["MOV", "M,H"]
            case (moveMemoryL) ["MOV", "M,L"]
            case (noop) ["NOP", null]
            case (orA) ["ORA", "A"]
            case (orB) ["ORA", "B"]
            case (orC) ["ORA", "C"]
            case (orD) ["ORA", "D"]
            case (orE) ["ORA", "E"]
            case (orH) ["ORA", "H"]
            case (orL) ["ORA", "L"]
            case (orMemory) ["ORA", "M"]
            case (orImmediate) ["ORI", "#"]
            case (rotateLeft) ["RLC", null]
            case (rotateRight) ["RRC", null]
            case (output) ["OUT", ""]
            case (popB) ["POP", "B"]
            case (popD) ["POP", "D"]
            case (popH) ["POP", "H"]
            case (popStatus) ["POP", "PSW"]
            case (pushB) ["PUSH", "B"]
            case (pushD) ["PUSH", "D"]
            case (pushH) ["PUSH", "H"]
            case (pushStatus) ["PUSH", "PSW"]
            case (\ireturn) ["RET", null]
            case (returnIfCarry) ["RC", null]
            case (returnIfMinus) ["RM", null]
            case (returnIfNoCarry) ["RNC", null]
            case (returnIfNotZero) ["RNZ", null]
            case (returnIfParityEven) ["RPE", null]
            case (returnIfParityOdd) ["RPO", null]
            case (returnIfPlus) ["RP", null]
            case (returnIfZero) ["RZ", null]
            case (setCarry) ["STC", null]
            case (storeAccumulatorB) ["STAX", "B"]
            case (storeAccumulatorD) ["STAX", "D"]
            case (storeAccumulatorDirect) ["STA", "$"]
            case (storeHLDirect) ["SHLD", "$"]
            case (subtractA) ["SUB", "A"]
            case (subtractB) ["SUB", "B"]
            case (subtractC) ["SUB", "C"]
            case (subtractD) ["SUB", "D"]
            case (subtractE) ["SUB", "E"]
            case (subtractH) ["SUB", "H"]
            case (subtractL) ["SUB", "L"]
            case (subtractMemory) ["SUB", "M"]
            case (subtractImmediate) ["SUI", "#"]
            case (subtractAWithBorrow) ["SBB", "A"]
            case (subtractBWithBorrow) ["SBB", "B"]
            case (subtractCWithBorrow) ["SBB", "C"]
            case (subtractDWithBorrow) ["SBB", "D"]
            case (subtractEWithBorrow) ["SBB", "E"]
            case (subtractHWithBorrow) ["SBB", "H"]
            case (subtractLWithBorrow) ["SBB", "L"]
            case (subtractMemoryWithBorrow) ["SBB", "M"]
            case (subtractImmediateWithBorrow) ["SBI", "#"]
            case (xorA) ["XRA", "A"]
            case (xorB) ["XRA", "B"]
            case (xorC) ["XRA", "C"]
            case (xorD) ["XRA", "D"]
            case (xorE) ["XRA", "E"]
            case (xorH) ["XRA", "H"]
            case (xorL) ["XRA", "L"]
            case (xorMemory) ["XRA", "M"]
            case (xorImmediate) ["XRI", "#"]
            ;

Opcode loadOpcode(Correspondence<Integer, Byte> bytes, Integer address) {
    value byte = bytes[address];
    
    assert (exists byte);
    
    value opcode = opcodes[byte];
    
    if (!exists opcode) {
        throw Exception("Unsupported opcode ``format(byte, 2)`` at address ``format(address, 4)``");
    }
    
    return opcode;
}

Integer disassemble(Correspondence<Integer, Byte> bytes, Integer address) {
    value opcode = loadOpcode(bytes, address);
    
    value output = StringBuilder();
    
    output.append(format(address, 4));
    
    value [mnemonic, arguments] = mnemonicAndArguments(opcode);
    
    output.append(" ``mnemonic``");
    
    if (exists arguments) {
        while (output.size < 12) {
            output.appendSpace();
        }
        
        output.append("``arguments``");
        
        if (opcode.size >= 2) {
            value argument1 = bytes[address + 1];
            
            assert (exists argument1);
            
            if (opcode.size == 3) {
                value argument2 = bytes[address + 2];
                
                assert (exists argument2);
                
                output.append(format(argument2, 2));
            }
            
            output.append(format(argument1, 2));
        }
    }
    
    print(output.string);
    
    return opcode.size;
}
