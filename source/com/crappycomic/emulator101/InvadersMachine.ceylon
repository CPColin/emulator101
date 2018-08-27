// TODO: Has internal state, so should be part of State (after all!)
// also needs tests
class InvadersMachine() satisfies Machine {
    variable value shiftHigh = 0.byte;
    variable value shiftLow = 0.byte;
    variable value shiftOffset = 0;
    
    shared actual Byte input(Byte device) {
        if (device == 3.byte) {
            value shiftWord = word(shiftHigh, shiftLow);
            
            return shiftWord.rightLogicalShift(8 - shiftOffset).byte;
        } else {
            return 0.byte;
        }
    }
    
    shared actual void output(Byte device, Byte data) {
        if (device == 2.byte) {
            shiftOffset = data.unsigned.and(#07);
        } else if (device == 4.byte) {
            shiftLow = shiftHigh;
            shiftHigh = data;
        }
    }
    
}
