import ceylon.language.meta {
    classDeclaration
}

"An opcode that the Intel 8080 understands.
 
 The only data that belongs in this class is what's necessary for turning a stream of bytes into a
 stream of opcodes. Data relating to disassembly belongs in the disassembler and data relating to
 execution belongs in the emulator."
shared class Opcode
        of noop // 00
        | loadPairImmediateB // 01
        | storeAccumulatorB // 02
        | incrementPairB // 03
        | incrementB // 04
        | decrementB // 05
        | moveImmediateB // 06
        | rotateLeft // 07
        | doubleAddB // 09
        | loadAccumulatorB // 0a
        | decrementPairB // 0b
        | incrementC // 0c
        | decrementC // 0d
        | moveImmediateC // 0e
        | rotateRight // 0f
        | loadPairImmediateD // 11
        | storeAccumulatorD // 12
        | incrementPairD // 13
        | incrementD // 14
        | decrementD // 15
        | moveImmediateD // 16
        | rotateLeftThroughCarry // 17
        | doubleAddD // 19
        | loadAccumulatorD // 1a
        | decrementPairD // 1b
        | incrementE // 1c
        | decrementE // 1d
        | moveImmediateE // 1e
        | rotateRightThroughCarry // 1f
        | loadPairImmediateH // 21
        | storeHLDirect // 22
        | incrementPairH // 23
        | incrementH // 24
        | decrementH // 25
        | moveImmediateH // 26
        | decimalAdjust // 27
        | doubleAddH // 29
        | loadHLDirect // 2a
        | decrementPairH // 2b
        | incrementL // 2c
        | decrementL // 2d
        | moveImmediateL // 2e
        | complementAccumulator // 2f
        | loadPairImmediateStackPointer // 31
        | storeAccumulatorDirect // 32
        | incrementPairStackPointer // 33
        | incrementMemory // 34
        | decrementMemory // 35
        | moveImmediateMemory // 36
        | setCarry // 37
        | doubleAddStackPointer // 39
        | loadAccumulatorDirect // 3a
        | decrementPairStackPointer // 3b
        | incrementA // 3c
        | decrementA // 3d
        | moveImmediateA // 3e
        | complementCarry // 3f
        | moveBB // 40
        | moveBC // 41
        | moveBD // 42
        | moveBE // 43
        | moveBH // 44
        | moveBL // 45
        | moveBMemory // 46
        | moveBA // 47
        | moveCB // 48
        | moveCC // 49
        | moveCD // 4a
        | moveCE // 4b
        | moveCH // 4c
        | moveCL // 4d
        | moveCMemory // 4e
        | moveCA // 4f
        | moveDB // 50
        | moveDC // 51
        | moveDD // 52
        | moveDE // 53
        | moveDH // 54
        | moveDL // 55
        | moveDMemory // 56
        | moveDA // 57
        | moveEB // 58
        | moveEC // 59
        | moveED // 5a
        | moveEE // 5b
        | moveEH // 5c
        | moveEL // 5d
        | moveEMemory // 5e
        | moveEA // 5f
        | moveHB // 60
        | moveHC // 61
        | moveHD // 62
        | moveHE // 63
        | moveHH // 64
        | moveHL // 65
        | moveHMemory // 66
        | moveHA // 67
        | moveLB // 68
        | moveLC // 69
        | moveLD // 6a
        | moveLE // 6b
        | moveLH // 6c
        | moveLL // 6d
        | moveLMemory // 6e
        | moveLA // 6f
        | moveMemoryB // 70
        | moveMemoryC // 71
        | moveMemoryD // 72
        | moveMemoryE // 73
        | moveMemoryH // 74
        | moveMemoryL // 75
        | halt // 76
        | moveMemoryA // 77
        | moveAB // 78
        | moveAC // 79
        | moveAD // 7a
        | moveAE // 7b
        | moveAH // 7c
        | moveAL // 7d
        | moveAMemory // 7e
        | moveAA // 7f
        | addB // 80
        | addC // 81
        | addD // 82
        | addE // 83
        | addH // 84
        | addL // 85
        | addMemory // 86
        | addA // 87
        | addBWithCarry // 88
        | addCWithCarry // 89
        | addDWithCarry // 8a
        | addEWithCarry // 8b
        | addHWithCarry // 8c
        | addLWithCarry // 8d
        | addMemoryWithCarry // 8e
        | addAWithCarry // 8f
        | subtractB // 90
        | subtractC // 91
        | subtractD // 92
        | subtractE // 93
        | subtractH // 94
        | subtractL // 95
        | subtractMemory // 96
        | subtractA // 97
        | subtractBWithBorrow // 98
        | subtractCWithBorrow // 99
        | subtractDWithBorrow // 9a
        | subtractEWithBorrow // 9b
        | subtractHWithBorrow // 9c
        | subtractLWithBorrow // 9d
        | subtractMemoryWithBorrow // 9e
        | subtractAWithBorrow // 9f
        | andB // a0
        | andC // a1
        | andD // a2
        | andE // a3
        | andH // a4
        | andL // a5
        | andMemory // a6
        | andA // a7
        | xorB // a8
        | xorC // a9
        | xorD // aa
        | xorE // ab
        | xorH // ac
        | xorL // ad
        | xorMemory // ae
        | xorA // af
        | orB // b0
        | orC // b1
        | orD // b2
        | orE // b3
        | orH // b4
        | orL // b5
        | orMemory // b6
        | orA // b7
        | compareB // b8
        | compareC // b9
        | compareD // ba
        | compareE // bb
        | compareH // bc
        | compareL // bd
        | compareMemory // be
        | compareA // bf
        | returnIfNotZero // c0
        | popB // c1
        | jumpIfNotZero // c2
        | jump // c3
        | callIfNotZero // c4
        | pushB // c5
        | addImmediate // c6
        | restart0 // c7
        | returnIfZero // c8
        | \ireturn // c9
        | jumpIfZero // ca
        | callIfZero // cc
        | call // cd
        | addImmediateWithCarry // ce
        | restart1 // cf
        | returnIfNoCarry // d0
        | popD // d1
        | jumpIfNoCarry // d2
        | output // d3
        | callIfNoCarry // d4
        | pushD // d5
        | subtractImmediate // d6
        | restart2 // d7
        | returnIfCarry // d8
        | jumpIfCarry // da
        | input // db
        | callIfCarry // dc
        | subtractImmediateWithBorrow // de
        | restart3 // df
        | returnIfParityOdd // e0
        | popH // e1
        | jumpIfParityOdd // e2
        | exchangeStack // e3
        | callIfParityOdd // e4
        | pushH // e5
        | andImmediate // e6
        | restart4 // e7
        | returnIfParityEven // e8
        | loadProgramCounter // e9
        | jumpIfParityEven // ea
        | exchangeRegisters // eb
        | callIfParityEven // ec
        | xorImmediate // ee
        | restart5 // ef
        | returnIfPlus // f0
        | popStatus // f1
        | jumpIfPlus // f2
        | disableInterrupts // f3
        | callIfPlus // f4
        | pushStatus // f5
        | orImmediate // f6
        | restart6 // f7
        | returnIfMinus // f8
        | loadStackPointer // f9
        | jumpIfMinus // fa
        | enableInterrupts // fb
        | callIfMinus // fc
        | compareImmediate // fe
        | restart7 // ff
        {
    shared Byte byte;
    
    shared Integer size;
    
    abstract new opcode(Integer byte, Integer size = 1) {
        this.byte = byte.byte;
        this.size = size;
    }
    
    shared new addA extends opcode(#87) {}
    shared new addB extends opcode(#80) {}
    shared new addC extends opcode(#81) {}
    shared new addD extends opcode(#82) {}
    shared new addE extends opcode(#83) {}
    shared new addH extends opcode(#84) {}
    shared new addL extends opcode(#85) {}
    shared new addImmediate extends opcode(#c6, 2) {}
    shared new addMemory extends opcode(#86) {}
    shared new addAWithCarry extends opcode(#8f) {}
    shared new addBWithCarry extends opcode(#88) {}
    shared new addCWithCarry extends opcode(#89) {}
    shared new addDWithCarry extends opcode(#8a) {}
    shared new addEWithCarry extends opcode(#8b) {}
    shared new addHWithCarry extends opcode(#8c) {}
    shared new addLWithCarry extends opcode(#8d) {}
    shared new addImmediateWithCarry extends opcode(#ce, 2) {}
    shared new addMemoryWithCarry extends opcode(#8e) {}
    shared new andA extends opcode(#a7) {}
    shared new andB extends opcode(#a0) {}
    shared new andC extends opcode(#a1) {}
    shared new andD extends opcode(#a2) {}
    shared new andE extends opcode(#a3) {}
    shared new andH extends opcode(#a4) {}
    shared new andL extends opcode(#a5) {}
    shared new andImmediate extends opcode(#e6, 2) {}
    shared new andMemory extends opcode(#a6) {}
    shared new call extends opcode(#cd, 3) {}
    shared new callIfCarry extends opcode(#dc, 3) {}
    shared new callIfMinus extends opcode(#fc, 3) {}
    shared new callIfNoCarry extends opcode(#d4, 3) {}
    shared new callIfNotZero extends opcode(#c4, 3) {}
    shared new callIfParityEven extends opcode(#ec, 3) {}
    shared new callIfParityOdd extends opcode(#e4, 3) {}
    shared new callIfPlus extends opcode(#f4, 3) {}
    shared new callIfZero extends opcode(#cc, 3) {}
    shared new compareA extends opcode(#bf) {}
    shared new compareB extends opcode(#b8) {}
    shared new compareC extends opcode(#b9) {}
    shared new compareD extends opcode(#ba) {}
    shared new compareE extends opcode(#bb) {}
    shared new compareH extends opcode(#bc) {}
    shared new compareL extends opcode(#bd) {}
    shared new compareImmediate extends opcode(#fe, 2) {}
    shared new compareMemory extends opcode(#be) {}
    shared new complementAccumulator extends opcode(#2f) {}
    shared new complementCarry extends opcode(#3f) {}
    shared new decimalAdjust extends opcode(#27) {}
    shared new decrementA extends opcode(#3d) {}
    shared new decrementB extends opcode(#05) {}
    shared new decrementC extends opcode(#0d) {}
    shared new decrementD extends opcode(#15) {}
    shared new decrementE extends opcode(#1d) {}
    shared new decrementH extends opcode(#25) {}
    shared new decrementL extends opcode(#2d) {}
    shared new decrementMemory extends opcode(#35) {}
    shared new decrementPairB extends opcode(#0b) {}
    shared new decrementPairD extends opcode(#1b) {}
    shared new decrementPairH extends opcode(#2b) {}
    shared new decrementPairStackPointer extends opcode(#3b) {}
    shared new disableInterrupts extends opcode(#f3) {}
    shared new doubleAddB extends opcode(#09) {}
    shared new doubleAddD extends opcode(#19) {}
    shared new doubleAddH extends opcode(#29) {}
    shared new doubleAddStackPointer extends opcode(#39) {}
    shared new enableInterrupts extends opcode(#fb) {}
    shared new exchangeRegisters extends opcode(#eb) {}
    shared new exchangeStack extends opcode(#e3) {}
    shared new halt extends opcode(#76) {}
    shared new incrementA extends opcode(#3c) {}
    shared new incrementB extends opcode(#04) {}
    shared new incrementC extends opcode(#0c) {}
    shared new incrementD extends opcode(#14) {}
    shared new incrementE extends opcode(#1c) {}
    shared new incrementH extends opcode(#24) {}
    shared new incrementL extends opcode(#2c) {}
    shared new incrementMemory extends opcode(#34) {}
    shared new incrementPairB extends opcode(#03) {}
    shared new incrementPairD extends opcode(#13) {}
    shared new incrementPairH extends opcode(#23) {}
    shared new incrementPairStackPointer extends opcode(#33) {}
    shared new input extends opcode(#db, 2) {}
    shared new jump extends opcode(#c3, 3) {}
    shared new jumpIfCarry extends opcode(#da, 3) {}
    shared new jumpIfNoCarry extends opcode(#d2, 3) {}
    shared new jumpIfNotZero extends opcode(#c2, 3) {}
    shared new jumpIfMinus extends opcode(#fa, 3) {}
    shared new jumpIfParityEven extends opcode(#ea, 3) {}
    shared new jumpIfParityOdd extends opcode(#e2, 3) {}
    shared new jumpIfPlus extends opcode(#f2, 3) {}
    shared new jumpIfZero extends opcode(#ca, 3) {}
    shared new loadAccumulatorB extends opcode(#0a) {}
    shared new loadAccumulatorD extends opcode(#1a) {}
    shared new loadAccumulatorDirect extends opcode(#3a, 3) {}
    shared new loadHLDirect extends opcode(#2a, 3) {}
    shared new loadPairImmediateB extends opcode(#01, 3) {}
    shared new loadPairImmediateD extends opcode(#11, 3) {}
    shared new loadPairImmediateH extends opcode(#21, 3) {}
    shared new loadPairImmediateStackPointer extends opcode(#31, 3) {}
    shared new loadProgramCounter extends opcode(#e9) {}
    shared new loadStackPointer extends opcode(#f9) {}
    shared new moveAA extends opcode(#7f) {}
    shared new moveAB extends opcode(#78) {}
    shared new moveAC extends opcode(#79) {}
    shared new moveAD extends opcode(#7a) {}
    shared new moveAE extends opcode(#7b) {}
    shared new moveAH extends opcode(#7c) {}
    shared new moveAL extends opcode(#7d) {}
    shared new moveAMemory extends opcode(#7e) {}
    shared new moveBA extends opcode(#47) {}
    shared new moveBB extends opcode(#40) {}
    shared new moveBC extends opcode(#41) {}
    shared new moveBD extends opcode(#42) {}
    shared new moveBE extends opcode(#43) {}
    shared new moveBH extends opcode(#44) {}
    shared new moveBL extends opcode(#45) {}
    shared new moveBMemory extends opcode(#46) {}
    shared new moveCA extends opcode(#4f) {}
    shared new moveCB extends opcode(#48) {}
    shared new moveCC extends opcode(#49) {}
    shared new moveCD extends opcode(#4a) {}
    shared new moveCE extends opcode(#4b) {}
    shared new moveCH extends opcode(#4c) {}
    shared new moveCL extends opcode(#4d) {}
    shared new moveCMemory extends opcode(#4e) {}
    shared new moveDA extends opcode(#57) {}
    shared new moveDB extends opcode(#50) {}
    shared new moveDC extends opcode(#51) {}
    shared new moveDD extends opcode(#52) {}
    shared new moveDE extends opcode(#53) {}
    shared new moveDH extends opcode(#54) {}
    shared new moveDL extends opcode(#55) {}
    shared new moveDMemory extends opcode(#56) {}
    shared new moveEA extends opcode(#5f) {}
    shared new moveEB extends opcode(#58) {}
    shared new moveEC extends opcode(#59) {}
    shared new moveED extends opcode(#5a) {}
    shared new moveEE extends opcode(#5b) {}
    shared new moveEH extends opcode(#5c) {}
    shared new moveEL extends opcode(#5d) {}
    shared new moveEMemory extends opcode(#5e) {}
    shared new moveHA extends opcode(#67) {}
    shared new moveHB extends opcode(#60) {}
    shared new moveHC extends opcode(#61) {}
    shared new moveHD extends opcode(#62) {}
    shared new moveHE extends opcode(#63) {}
    shared new moveHH extends opcode(#64) {}
    shared new moveHL extends opcode(#65) {}
    shared new moveHMemory extends opcode(#66) {}
    shared new moveLA extends opcode(#6f) {}
    shared new moveLB extends opcode(#68) {}
    shared new moveLC extends opcode(#69) {}
    shared new moveLD extends opcode(#6a) {}
    shared new moveLE extends opcode(#6b) {}
    shared new moveLH extends opcode(#6c) {}
    shared new moveLL extends opcode(#6d) {}
    shared new moveLMemory extends opcode(#6e) {}
    shared new moveImmediateA extends opcode(#3e, 2) {}
    shared new moveImmediateB extends opcode(#06, 2) {}
    shared new moveImmediateC extends opcode(#0e, 2) {}
    shared new moveImmediateD extends opcode(#16, 2) {}
    shared new moveImmediateE extends opcode(#1e, 2) {}
    shared new moveImmediateH extends opcode(#26, 2) {}
    shared new moveImmediateL extends opcode(#2e, 2) {}
    shared new moveImmediateMemory extends opcode(#36, 2) {}
    shared new moveMemoryA extends opcode(#77) {}
    shared new moveMemoryB extends opcode(#70) {}
    shared new moveMemoryC extends opcode(#71) {}
    shared new moveMemoryD extends opcode(#72) {}
    shared new moveMemoryE extends opcode(#73) {}
    shared new moveMemoryH extends opcode(#74) {}
    shared new moveMemoryL extends opcode(#75) {}
    shared new noop extends opcode(#00) {}
    shared new orA extends opcode(#b7) {}
    shared new orB extends opcode(#b0) {}
    shared new orC extends opcode(#b1) {}
    shared new orD extends opcode(#b2) {}
    shared new orE extends opcode(#b3) {}
    shared new orH extends opcode(#b4) {}
    shared new orL extends opcode(#b5) {}
    shared new orImmediate extends opcode(#f6, 2) {}
    shared new orMemory extends opcode(#b6) {}
    shared new output extends opcode(#d3, 2) {}
    shared new popB extends opcode(#c1) {}
    shared new popD extends opcode(#d1) {}
    shared new popH extends opcode(#e1) {}
    shared new popStatus extends opcode(#f1) {}
    shared new pushB extends opcode(#c5) {}
    shared new pushD extends opcode(#d5) {}
    shared new pushH extends opcode(#e5) {}
    shared new pushStatus extends opcode(#f5) {}
    shared new restart0 extends opcode(#c7) {}
    shared new restart1 extends opcode(#cf) {}
    shared new restart2 extends opcode(#d7) {}
    shared new restart3 extends opcode(#df) {}
    shared new restart4 extends opcode(#e7) {}
    shared new restart5 extends opcode(#ef) {}
    shared new restart6 extends opcode(#f7) {}
    shared new restart7 extends opcode(#ff) {}
    shared new \ireturn extends opcode(#c9) {}
    shared new returnIfCarry extends opcode(#d8) {}
    shared new returnIfMinus extends opcode(#f8) {}
    shared new returnIfNoCarry extends opcode(#d0) {}
    shared new returnIfNotZero extends opcode(#c0) {}
    shared new returnIfParityEven extends opcode(#e8) {}
    shared new returnIfParityOdd extends opcode(#e0) {}
    shared new returnIfPlus extends opcode(#f0) {}
    shared new returnIfZero extends opcode(#c8) {}
    shared new rotateLeft extends opcode(#07) {}
    shared new rotateLeftThroughCarry extends opcode(#17) {}
    shared new rotateRight extends opcode(#0f) {}
    shared new rotateRightThroughCarry extends opcode(#1f) {}
    shared new setCarry extends opcode(#37) {}
    shared new storeAccumulatorB extends opcode(#02) {}
    shared new storeAccumulatorD extends opcode(#12) {}
    shared new storeAccumulatorDirect extends opcode(#32, 3) {}
    shared new storeHLDirect extends opcode(#22, 3) {}
    shared new subtractA extends opcode(#97) {}
    shared new subtractB extends opcode(#90) {}
    shared new subtractC extends opcode(#91) {}
    shared new subtractD extends opcode(#92) {}
    shared new subtractE extends opcode(#93) {}
    shared new subtractH extends opcode(#94) {}
    shared new subtractL extends opcode(#95) {}
    shared new subtractImmediate extends opcode(#d6, 2) {}
    shared new subtractMemory extends opcode(#96) {}
    shared new subtractAWithBorrow extends opcode(#9f) {}
    shared new subtractBWithBorrow extends opcode(#98) {}
    shared new subtractCWithBorrow extends opcode(#99) {}
    shared new subtractDWithBorrow extends opcode(#9a) {}
    shared new subtractEWithBorrow extends opcode(#9b) {}
    shared new subtractHWithBorrow extends opcode(#9c) {}
    shared new subtractLWithBorrow extends opcode(#9d) {}
    shared new subtractImmediateWithBorrow extends opcode(#de, 2) {}
    shared new subtractMemoryWithBorrow extends opcode(#9e) {}
    shared new xorA extends opcode(#af) {}
    shared new xorB extends opcode(#a8) {}
    shared new xorC extends opcode(#a9) {}
    shared new xorD extends opcode(#aa) {}
    shared new xorE extends opcode(#ab) {}
    shared new xorH extends opcode(#ac) {}
    shared new xorL extends opcode(#ad) {}
    shared new xorImmediate extends opcode(#ee, 2) {}
    shared new xorMemory extends opcode(#ae) {}
    
    shared actual String string => classDeclaration(this).name;
}

shared Map<Byte,Opcode> opcodes = map(`Opcode`.caseValues.collect((opcode) => opcode.byte->opcode));
