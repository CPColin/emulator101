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
            case (noop) ["NOP", null]
            case (loadPairImmediateB) ["LXI", "B,#"]
            case (decrementB) ["DCR", "B"]
            case (moveImmediateB) ["MVI", "B,#"]
            case (rotateAccumulatorLeft) ["RLC", null]
            case (moveImmediateC) ["MVI", "C,#"]
            case (loadPairImmediateD) ["LXI", "D,#"]
            case (incrementPairD) ["INX", "D"]
            case (rotateAccumulatorRight) ["RRC", null]
            case (moveImmediateD) ["MVI", "D,#"]
            case (doubleAddD) ["DAD", "D"]
            case (loadAccumulatorD) ["LDAX", "D"]
            case (loadPairImmediateH) ["LXI", "H,#"]
            case (storeHLDirect) ["SHLD", "$"]
            case (incrementPairH) ["INX", "H"]
            case (moveImmediateH) ["MVI", "H,#"]
            case (decimalAdjust) ["DAA", null]
            case (doubleAddH) ["DAD", "H"]
            case (loadHLDirect) ["LHLD", "$"]
            case (decrementPairH) ["DCX", "H"]
            case (loadPairImmediateStackPointer) ["LXI", "SP,#"]
            case (storeA) ["STA", "$"]
            case (decrementMemory) ["DCR", "M"]
            case (moveImmediateMemory) ["MVI", "M"]
            case (loadAccumulatorDirect) ["LDA", "$"]
            case (incrementA) ["INR", "A"]
            case (decrementA) ["DCR", "A"]
            case (moveImmediateA) ["MVI", "A,#"]
            case (moveBB) ["MOV", "B,B"]
            case (moveBC) ["MOV", "B,C"]
            case (moveBD) ["MOV", "B,D"]
            case (moveBE) ["MOV", "B,E"]
            case (moveBH) ["MOV", "B,H"]
            case (moveBL) ["MOV", "B,L"]
            case (moveBMemory) ["MOV", "B,M"]
            case (moveBA) ["MOV", "B,A"]
            case (moveCB) ["MOV", "C,B"]
            case (moveCC) ["MOV", "C,C"]
            case (moveCD) ["MOV", "C,D"]
            case (moveCE) ["MOV", "C,E"]
            case (moveCH) ["MOV", "C,H"]
            case (moveCL) ["MOV", "C,L"]
            case (moveCMemory) ["MOV", "C,M"]
            case (moveCA) ["MOV", "C,A"]
            case (moveDB) ["MOV", "D,B"]
            case (moveDC) ["MOV", "D,C"]
            case (moveDD) ["MOV", "D,D"]
            case (moveDE) ["MOV", "D,E"]
            case (moveDH) ["MOV", "D,H"]
            case (moveDL) ["MOV", "D,L"]
            case (moveDMemory) ["MOV", "D,M"]
            case (moveDA) ["MOV", "D,A"]
            case (moveEB) ["MOV", "E,B"]
            case (moveEC) ["MOV", "E,C"]
            case (moveED) ["MOV", "E,D"]
            case (moveEE) ["MOV", "E,E"]
            case (moveEH) ["MOV", "E,H"]
            case (moveEL) ["MOV", "E,L"]
            case (moveEMemory) ["MOV", "E,M"]
            case (moveEA) ["MOV", "E,A"]
            case (moveHB) ["MOV", "H,B"]
            case (moveHC) ["MOV", "H,C"]
            case (moveHD) ["MOV", "H,D"]
            case (moveHE) ["MOV", "H,E"]
            case (moveHH) ["MOV", "H,H"]
            case (moveHL) ["MOV", "H,L"]
            case (moveHMemory) ["MOV", "H,M"]
            case (moveHA) ["MOV", "H,A"]
            case (moveLB) ["MOV", "L,B"]
            case (moveLC) ["MOV", "L,C"]
            case (moveLD) ["MOV", "L,D"]
            case (moveLE) ["MOV", "L,E"]
            case (moveLH) ["MOV", "L,H"]
            case (moveLL) ["MOV", "L,L"]
            case (moveLMemory) ["MOV", "L,M"]
            case (moveLA) ["MOV", "L,A"]
            case (moveMemoryB) ["MOV", "M,B"]
            case (moveMemoryC) ["MOV", "M,C"]
            case (moveMemoryD) ["MOV", "M,D"]
            case (moveMemoryE) ["MOV", "M,E"]
            case (moveMemoryH) ["MOV", "M,H"]
            case (moveMemoryL) ["MOV", "M,L"]
            case (halt) ["HLT", null]
            case (moveMemoryA) ["MOV", "M,A"]
            case (moveAB) ["MOV", "A,B"]
            case (moveAC) ["MOV", "A,C"]
            case (moveAD) ["MOV", "A,D"]
            case (moveAE) ["MOV", "A,E"]
            case (moveAH) ["MOV", "A,H"]
            case (moveAL) ["MOV", "A,L"]
            case (moveAMemory) ["MOV", "A,M"]
            case (moveAA) ["MOV", "A,A"]
            case (andB) ["ANA", "B"]
            case (andC) ["ANA", "C"]
            case (andD) ["ANA", "D"]
            case (andE) ["ANA", "E"]
            case (andH) ["ANA", "H"]
            case (andL) ["ANA", "L"]
            case (andMemory) ["ANA", "M"]
            case (andA) ["ANA", "A"]
            case (xorA) ["XRA", "A"]
            case (returnIfNotZero) ["RNZ", null]
            case (popB) ["POP", "B"]
            case (jumpIfNotZero) ["JNZ", "$"]
            case (jump) ["JMP", "$"]
            case (callIfNotZero) ["CNZ", "$"]
            case (pushB) ["PUSH", "B"]
            case (addImmediate) ["ADI", "#"]
            case (returnIfZero) ["RZ", null]
            case (\ireturn) ["RET", null]
            case (jumpIfZero) ["JZ", "$"]
            case (callIfZero) ["CZ", "$"]
            case (call) ["CALL", "$"]
            case (popD) ["POP", "D"]
            case (jumpIfNoCarry) ["JNC", "$"]
            case (output) ["OUT", ""]
            case (pushD) ["PUSH", "D"]
            case (jumpIfCarry) ["JC", "$"]
            case (input) ["IN", "#"]
            case (popH) ["POP", "H"]
            case (pushH) ["PUSH", "H"]
            case (andImmediate) ["ANI", "#"]
            case (exchangeRegisters) ["XCHG", null]
            case (popStatus) ["POP", "PSW"]
            case (disableInterrupts) ["DI", null]
            case (pushStatus) ["PUSH", "PSW"]
            case (jumpIfMinus) ["JM", "$"]
            case (enableInterrupts) ["EI", null]
            case (compareImmediate) ["CPI", "#"];

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
