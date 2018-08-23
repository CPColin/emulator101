import ceylon.language.meta {
    classDeclaration
}

"An opcode that the Intel 8080 understands.
 
 The only data that belongs in this class is what's necessary for turning a stream of bytes into a
 stream of opcodes. Data relating to disassembly belongs in the disassembler and data relating to
 execution belongs in the emulator."
shared abstract class Opcode
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
        // 0f
        | loadPairImmediateD // 11
        | storeAccumulatorD // 12
        | incrementPairD // 13
        | incrementD // 14
        | decrementD // 15
        | moveImmediateD // 16
        // 17
        | doubleAddD // 19
        | loadAccumulatorD // 1a
        | decrementPairD // 1b
        | incrementE // 1c
        | decrementE // 1d
        | moveImmediateE // 1e
        // 1f
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
        // 2f
        | loadPairImmediateStackPointer // 31
        | storeAccumulatorDirect // 32
        // 33
        | incrementMemory // 34
        | decrementMemory // 35
        | moveImmediateMemory // 36
        | setCarry // 37
        // 39
        | loadAccumulatorDirect // 3a
        // 3b
        | incrementA // 3c
        | decrementA // 3d
        | moveImmediateA // 3e
        // 3f
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
        // c7
        | returnIfZero // c8
        | \ireturn // c9
        | jumpIfZero // ca
        | callIfZero // cc
        | call // cd
        | addImmediateWithCarry // ce
        // cf
        | returnIfNoCarry // d0
        | popD // d1
        | jumpIfNoCarry // d2
        | output // d3
        | callIfNoCarry // d4
        | pushD // d5
        | subtractImmediate // d6
        // d7
        | returnIfCarry // d8
        | jumpIfCarry // da
        | input // db
        | callIfCarry // dc
        | subtractImmediateWithBorrow // de
        // df
        | returnIfParityOdd // e0
        | popH // e1
        | jumpIfParityOdd // e2
        // e3
        | callIfParityOdd // e4
        | pushH // e5
        | andImmediate // e6
        // e7
        | returnIfParityEven // e8
        // e9
        | jumpIfParityEven // ea
        | exchangeRegisters // eb
        | callIfParityEven // ec
        | xorImmediate // ee
        // ef
        | returnIfPlus // f0
        | popStatus // f1
        | jumpIfPlus // f2
        | disableInterrupts // f3
        | callIfPlus // f4
        | pushStatus // f5
        | orImmediate // f6
        // f7
        | returnIfMinus // f8
        // f9
        | jumpIfMinus // fa
        | enableInterrupts // fb
        | callIfMinus // fc
        | compareImmediate // fe
        // ff
        {
    shared Byte byte;
    
    shared Integer size;
    
    shared new (Integer byte, Integer size = 1) {
        this.byte = byte.byte;
        this.size = size;
    }
    
    shared actual String string => classDeclaration(this).name;
}

object noop extends Opcode(#00) {}
object loadPairImmediateB extends Opcode(#01, 3) {}
object storeAccumulatorB extends Opcode(#02) {}
object incrementPairB extends Opcode(#03) {}
object incrementB extends Opcode(#04) {}
object decrementB extends Opcode(#05) {}
object moveImmediateB extends Opcode(#06, 2) {}
object rotateLeft extends Opcode(#07) {}
object doubleAddB extends Opcode(#09) {}
object loadAccumulatorB extends Opcode(#0a) {}
object decrementPairB extends Opcode(#0b) {}
object incrementC extends Opcode(#0c) {}
object decrementC extends Opcode(#0d) {}
object moveImmediateC extends Opcode(#0e, 2) {}
object rotateRight extends Opcode(#0f) {}
object loadPairImmediateD extends Opcode(#11, 3) {}
object storeAccumulatorD extends Opcode(#12) {}
object incrementPairD extends Opcode(#13) {}
object incrementD extends Opcode(#14) {}
object decrementD extends Opcode(#15) {}
object moveImmediateD extends Opcode(#16, 2) {}
object doubleAddD extends Opcode(#19) {}
object loadAccumulatorD extends Opcode(#1a) {}
object decrementPairD extends Opcode(#1b) {}
object incrementE extends Opcode(#1c) {}
object decrementE extends Opcode(#1d) {}
object moveImmediateE extends Opcode(#1e, 2) {}
object loadPairImmediateH extends Opcode(#21, 3) {}
object storeHLDirect extends Opcode(#22, 3) {}
object incrementPairH extends Opcode(#23) {}
object incrementH extends Opcode(#24) {}
object decrementH extends Opcode(#25) {}
object moveImmediateH extends Opcode(#26, 2) {}
object decimalAdjust extends Opcode(#27) {}
object doubleAddH extends Opcode(#29) {}
object loadHLDirect extends Opcode(#2a, 3) {}
object decrementPairH extends Opcode(#2b) {}
object incrementL extends Opcode(#2c) {}
object decrementL extends Opcode(#2d) {}
object moveImmediateL extends Opcode(#2e, 2) {}
object loadPairImmediateStackPointer extends Opcode(#31, 3) {}
object storeAccumulatorDirect extends Opcode(#32, 3) {}
object incrementMemory extends Opcode(#34) {}
object decrementMemory extends Opcode(#35) {}
object moveImmediateMemory extends Opcode(#36, 2) {}
object setCarry extends Opcode(#37) {}
object loadAccumulatorDirect extends Opcode(#3a, 3) {}
object incrementA extends Opcode(#3c) {}
object decrementA extends Opcode(#3d) {}
object moveImmediateA extends Opcode(#3e, 2) {}
object moveBB extends Opcode(#40) {}
object moveBC extends Opcode(#41) {}
object moveBD extends Opcode(#42) {}
object moveBE extends Opcode(#43) {}
object moveBH extends Opcode(#44) {}
object moveBL extends Opcode(#45) {}
object moveBMemory extends Opcode(#46) {}
object moveBA extends Opcode(#47) {}
object moveCB extends Opcode(#48) {}
object moveCC extends Opcode(#49) {}
object moveCD extends Opcode(#4a) {}
object moveCE extends Opcode(#4b) {}
object moveCH extends Opcode(#4c) {}
object moveCL extends Opcode(#4d) {}
object moveCMemory extends Opcode(#4e) {}
object moveCA extends Opcode(#4f) {}
object moveDB extends Opcode(#50) {}
object moveDC extends Opcode(#51) {}
object moveDD extends Opcode(#52) {}
object moveDE extends Opcode(#53) {}
object moveDH extends Opcode(#54) {}
object moveDL extends Opcode(#55) {}
object moveDMemory extends Opcode(#56) {}
object moveDA extends Opcode(#57) {}
object moveEB extends Opcode(#58) {}
object moveEC extends Opcode(#59) {}
object moveED extends Opcode(#5a) {}
object moveEE extends Opcode(#5b) {}
object moveEH extends Opcode(#5c) {}
object moveEL extends Opcode(#5d) {}
object moveEMemory extends Opcode(#5e) {}
object moveEA extends Opcode(#5f) {}
object moveHB extends Opcode(#60) {}
object moveHC extends Opcode(#61) {}
object moveHD extends Opcode(#62) {}
object moveHE extends Opcode(#63) {}
object moveHH extends Opcode(#64) {}
object moveHL extends Opcode(#65) {}
object moveHMemory extends Opcode(#66) {}
object moveHA extends Opcode(#67) {}
object moveLB extends Opcode(#68) {}
object moveLC extends Opcode(#69) {}
object moveLD extends Opcode(#6a) {}
object moveLE extends Opcode(#6b) {}
object moveLH extends Opcode(#6c) {}
object moveLL extends Opcode(#6d) {}
object moveLMemory extends Opcode(#6e) {}
object moveLA extends Opcode(#6f) {}
object moveMemoryB extends Opcode(#70) {}
object moveMemoryC extends Opcode(#71) {}
object moveMemoryD extends Opcode(#72) {}
object moveMemoryE extends Opcode(#73) {}
object moveMemoryH extends Opcode(#74) {}
object moveMemoryL extends Opcode(#75) {}
object halt extends Opcode(#76) {}
object moveMemoryA extends Opcode(#77) {}
object moveAB extends Opcode(#78) {}
object moveAC extends Opcode(#79) {}
object moveAD extends Opcode(#7a) {}
object moveAE extends Opcode(#7b) {}
object moveAH extends Opcode(#7c) {}
object moveAL extends Opcode(#7d) {}
object moveAMemory extends Opcode(#7e) {}
object moveAA extends Opcode(#7f) {}
object addB extends Opcode(#80) {}
object addC extends Opcode(#81) {}
object addD extends Opcode(#82) {}
object addE extends Opcode(#83) {}
object addH extends Opcode(#84) {}
object addL extends Opcode(#85) {}
object addMemory extends Opcode(#86) {}
object addA extends Opcode(#87) {}
object addBWithCarry extends Opcode(#88) {}
object addCWithCarry extends Opcode(#89) {}
object addDWithCarry extends Opcode(#8a) {}
object addEWithCarry extends Opcode(#8b) {}
object addHWithCarry extends Opcode(#8c) {}
object addLWithCarry extends Opcode(#8d) {}
object addMemoryWithCarry extends Opcode(#8e) {}
object addAWithCarry extends Opcode(#8f) {}
object subtractB extends Opcode(#90) {}
object subtractC extends Opcode(#91) {}
object subtractD extends Opcode(#92) {}
object subtractE extends Opcode(#93) {}
object subtractH extends Opcode(#94) {}
object subtractL extends Opcode(#95) {}
object subtractMemory extends Opcode(#96) {}
object subtractA extends Opcode(#97) {}
object subtractBWithBorrow extends Opcode(#98) {}
object subtractCWithBorrow extends Opcode(#99) {}
object subtractDWithBorrow extends Opcode(#9a) {}
object subtractEWithBorrow extends Opcode(#9b) {}
object subtractHWithBorrow extends Opcode(#9c) {}
object subtractLWithBorrow extends Opcode(#9d) {}
object subtractMemoryWithBorrow extends Opcode(#9e) {}
object subtractAWithBorrow extends Opcode(#9f) {}
object andB extends Opcode(#a0) {}
object andC extends Opcode(#a1) {}
object andD extends Opcode(#a2) {}
object andE extends Opcode(#a3) {}
object andH extends Opcode(#a4) {}
object andL extends Opcode(#a5) {}
object andMemory extends Opcode(#a6) {}
object andA extends Opcode(#a7) {}
object xorB extends Opcode(#a8) {}
object xorC extends Opcode(#a9) {}
object xorD extends Opcode(#aa) {}
object xorE extends Opcode(#ab) {}
object xorH extends Opcode(#ac) {}
object xorL extends Opcode(#ad) {}
object xorMemory extends Opcode(#ae) {}
object xorA extends Opcode(#af) {}
object orB extends Opcode(#b0) {}
object orC extends Opcode(#b1) {}
object orD extends Opcode(#b2) {}
object orE extends Opcode(#b3) {}
object orH extends Opcode(#b4) {}
object orL extends Opcode(#b5) {}
object orMemory extends Opcode(#b6) {}
object orA extends Opcode(#b7) {}
object compareB extends Opcode(#b8) {}
object compareC extends Opcode(#b9) {}
object compareD extends Opcode(#ba) {}
object compareE extends Opcode(#bb) {}
object compareH extends Opcode(#bc) {}
object compareL extends Opcode(#bd) {}
object compareMemory extends Opcode(#be) {}
object compareA extends Opcode(#bf) {}
object returnIfNotZero extends Opcode(#c0) {}
object popB extends Opcode(#c1) {}
object jumpIfNotZero extends Opcode(#c2, 3) {}
object jump extends Opcode(#c3, 3) {}
object callIfNotZero extends Opcode(#c4, 3) {}
object pushB extends Opcode(#c5) {}
object addImmediate extends Opcode(#c6, 2) {}
object returnIfZero extends Opcode(#c8) {}
object \ireturn extends Opcode(#c9) {}
object jumpIfZero extends Opcode(#ca, 3) {}
object callIfZero extends Opcode(#cc, 3) {}
object call extends Opcode(#cd, 3) {}
object addImmediateWithCarry extends Opcode(#ce, 2) {}
object returnIfNoCarry extends Opcode(#d0) {}
object popD extends Opcode(#d1) {}
object jumpIfNoCarry extends Opcode(#d2, 3) {}
object output extends Opcode(#d3, 2) {}
object callIfNoCarry extends Opcode(#d4, 3) {}
object pushD extends Opcode(#d5) {}
object subtractImmediate extends Opcode(#d6, 2) {}
object returnIfCarry extends Opcode(#d8) {}
object jumpIfCarry extends Opcode(#da, 3) {}
object input extends Opcode(#db, 2) {}
object callIfCarry extends Opcode(#dc, 3) {}
object subtractImmediateWithBorrow extends Opcode(#de, 2) {}
object returnIfParityOdd extends Opcode(#e0) {}
object popH extends Opcode(#e1) {}
object jumpIfParityOdd extends Opcode(#e2, 3) {}
object callIfParityOdd extends Opcode(#e4, 3) {}
object pushH extends Opcode(#e5) {}
object andImmediate extends Opcode(#e6, 2) {}
object returnIfParityEven extends Opcode(#e8) {}
object jumpIfParityEven extends Opcode(#ea, 3) {}
object exchangeRegisters extends Opcode(#eb) {}
object callIfParityEven extends Opcode(#ec, 3) {}
object xorImmediate extends Opcode(#ee, 2) {}
object returnIfPlus extends Opcode(#f0) {}
object popStatus extends Opcode(#f1) {}
object jumpIfPlus extends Opcode(#f2, 3) {}
object disableInterrupts extends Opcode(#f3) {}
object callIfPlus extends Opcode(#f4, 3) {}
object pushStatus extends Opcode(#f5) {}
object orImmediate extends Opcode(#f6, 2) {}
object returnIfMinus extends Opcode(#f8) {}
object jumpIfMinus extends Opcode(#fa, 3) {}
object enableInterrupts extends Opcode(#fb) {}
object callIfMinus extends Opcode(#fc, 3) {}
object compareImmediate extends Opcode(#fe, 2) {}

Map<Byte,Opcode> opcodes = map(`Opcode`.caseValues.collect((opcode) => opcode.byte->opcode));

// TODO: Test that asserts opcodes.size == `Opcode`.caseValues.size
