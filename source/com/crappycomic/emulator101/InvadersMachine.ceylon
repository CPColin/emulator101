// TODO: Needs tests
class InvadersMachine satisfies Machine {
    InvadersCabinet cabinet;
    
    Byte shiftHigh;
    Byte shiftLow;
    Integer shiftOffset;
    
    shared new(
            InvadersCabinet cabinet,
            Byte shiftHigh = 0.byte,
            Byte shiftLow = 0.byte,
            Integer shiftOffset = 0) {
        this.cabinet = cabinet;
        this.shiftHigh = shiftHigh;
        this.shiftLow = shiftLow;
        this.shiftOffset = shiftOffset;
    }
    
    shared Machine with(
            Byte shiftHigh = this.shiftHigh,
            Byte shiftLow = this.shiftLow,
            Integer shiftOffset = this.shiftOffset) {
        return InvadersMachine {
            cabinet = cabinet;
            shiftHigh = shiftHigh;
            shiftLow = shiftLow;
            shiftOffset = shiftOffset;
        };
    }
    
    shared actual Byte input(Byte device) {
        if (device == 1.byte) {
            return 0.byte
                    .set(6, cabinet.player1Right)
                    .set(5, cabinet.player1Left)
                    .set(4, cabinet.player1Fire)
                    .set(2, cabinet.player1Start)
                    .set(1, cabinet.player2Start)
                    .set(0, cabinet.coin);
        } else if (device == 2.byte) {
            return 0.byte
                    .set(6, cabinet.player2Right)
                    .set(5, cabinet.player2Left)
                    .set(4, cabinet.player2Fire);
        } else if (device == 3.byte) {
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
