"An opcode that the Intel 8080 understands.
 
 The only data that belongs in this class is what's necessary for turning a stream of bytes into a
 stream of opcodes. Data relating to disassembly belongs in the disassembler and data relating to
 execution belongs in the emulator."
abstract class Opcode
        of noop // 00
        | loadPairImmediateB // 01
        | decrementB // 05
        | moveImmediateB // 06
        | rotateAccumulatorLeft // 07
        | moveImmediateC // 0e
        | loadPairImmediateD // 11
        | incrementPairD // 13
        | rotateAccumulatorRight // 0f
        | moveImmediateD // 16
        | doubleAddD // 19
        | loadAccumulatorD // 1a
        | loadPairImmediateH // 21
        | storeHLDirect // 22
        | incrementPairH // 23
        | moveImmediateH // 26
        | decimalAdjust // 27
        | doubleAddH // 29
        | loadHLDirect // 2a
        | decrementPairH // 2b
        | loadPairImmediateStackPointer // 31
        | storeA // 32
        | decrementMemory // 35
        | moveImmediateMemory // 36
        | loadAccumulatorDirect // 3a
        | incrementA // 3c
        | decrementA // 3d
        | moveImmediateA // 3e
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
        | andB // a0
        | andC // a1
        | andD // a2
        | andE // a3
        | andH // a4
        | andL // a5
        | andMemory // a6
        | andA // a7
        | xorA // af
        | returnIfNotZero // c0
        | popB // c1
        | jumpIfNotZero // c2
        | jump // c3
        | callIfNotZero // c4
        | pushB // c5
        | addImmediate // c6
        | returnIfZero // c8
        | \ireturn // c9
        | jumpIfZero // ca
        | callIfZero // cc
        | call // cd
        | popD // d1
        | jumpIfNoCarry // d2
        | output // d3
        | pushD // d5
        | jumpIfCarry // da
        | input // db
        | popH // e1
        | pushH // e5
        | andImmediate // e6
        | exchangeRegisters // eb
        | popStatus // f1
        | disableInterrupts // f3
        | pushStatus // f5
        | jumpIfMinus // fa
        | enableInterrupts // fb
        | compareImmediate // fe
        {
    shared Byte byte;
    
    shared Integer size;
    
    shared new (Integer byte, Integer size = 1) {
        this.byte = byte.byte;
        this.size = size;
    }
}

object noop extends Opcode(#00) {}
object loadPairImmediateB extends Opcode(#01, 3) {}
object decrementB extends Opcode(#05) {}
object moveImmediateB extends Opcode(#06, 2) {}
object rotateAccumulatorLeft extends Opcode(#07) {}
object moveImmediateC extends Opcode(#0e, 2) {}
object loadPairImmediateD extends Opcode(#11, 3) {}
object incrementPairD extends Opcode(#13) {}
object rotateAccumulatorRight extends Opcode(#0f) {}
object moveImmediateD extends Opcode(#16, 2) {}
object doubleAddD extends Opcode(#19) {}
object loadAccumulatorD extends Opcode(#1a) {}
object loadPairImmediateH extends Opcode(#21, 3) {}
object storeHLDirect extends Opcode(#22, 3) {}
object incrementPairH extends Opcode(#23) {}
object moveImmediateH extends Opcode(#26, 2) {}
object decimalAdjust extends Opcode(#27) {}
object doubleAddH extends Opcode(#29) {}
object loadHLDirect extends Opcode(#2a, 3) {}
object decrementPairH extends Opcode(#2b) {}
object loadPairImmediateStackPointer extends Opcode(#31, 3) {}
object storeA extends Opcode(#32, 3) {}
object decrementMemory extends Opcode(#35) {}
object moveImmediateMemory extends Opcode(#36, 2) {}
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
object andB extends Opcode(#a0) {}
object andC extends Opcode(#a1) {}
object andD extends Opcode(#a2) {}
object andE extends Opcode(#a3) {}
object andH extends Opcode(#a4) {}
object andL extends Opcode(#a5) {}
object andMemory extends Opcode(#a6) {}
object andA extends Opcode(#a7) {}
object xorA extends Opcode(#af) {}
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
object popD extends Opcode(#d1) {}
object jumpIfNoCarry extends Opcode(#d2, 3) {}
object output extends Opcode(#d3, 2) {}
object pushD extends Opcode(#d5) {}
object jumpIfCarry extends Opcode(#da, 3) {}
object input extends Opcode(#db, 2) {}
object popH extends Opcode(#e1) {}
object pushH extends Opcode(#e5) {}
object andImmediate extends Opcode(#e6, 2) {}
object exchangeRegisters extends Opcode(#eb) {}
object popStatus extends Opcode(#f1) {}
object disableInterrupts extends Opcode(#f3) {}
object pushStatus extends Opcode(#f5) {}
object jumpIfMinus extends Opcode(#fa, 3) {}
object enableInterrupts extends Opcode(#fb) {}
object compareImmediate extends Opcode(#fe, 2) {}

Map<Byte,Opcode> opcodes = map(`Opcode`.caseValues.collect((opcode) => opcode.byte->opcode));

// TODO: Test that asserts opcodes.size == `Opcode`.caseValues.size
