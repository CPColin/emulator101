// TODO: Needs tests
class InvadersMachine satisfies Machine {
    Byte shiftHigh;
    Byte shiftLow;
    Integer shiftOffset;
    
    shared new(
            Byte shiftHigh = 0.byte,
            Byte shiftLow = 0.byte,
            Integer shiftOffset = 0) {
        this.shiftHigh = shiftHigh;
        this.shiftLow = shiftLow;
        this.shiftOffset = shiftOffset;
    }
    
    shared Machine with(
            Byte shiftHigh = this.shiftHigh,
            Byte shiftLow = this.shiftLow,
            Integer shiftOffset = this.shiftOffset) {
        return InvadersMachine {
            shiftHigh = shiftHigh;
            shiftLow = shiftLow;
            shiftOffset = shiftOffset;
        };
    }
    
    shared actual Byte input(Byte device) {
        if (device == 3.byte) {
            value shiftWord = word(shiftHigh, shiftLow);
            
            return shiftWord.rightLogicalShift(8 - shiftOffset).byte;
        } else {
            return 0.byte;
        }
    }
    
    shared actual Machine output(Byte device, Byte data) {
        if (device == 2.byte) {
            return with {
                shiftOffset = data.unsigned.and(#07);
            };
        } else if (device == 4.byte) {
            return with {
                shiftLow = shiftHigh;
                shiftHigh = data;
            };
        } else {
            return this;
        }
    }
    
}
