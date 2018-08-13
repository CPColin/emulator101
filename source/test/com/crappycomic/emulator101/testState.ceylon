import ceylon.test {
    assertEquals,
    parameters,
    test
}

import com.crappycomic.emulator101 {
    State
}

{[Boolean, Boolean, Boolean, Boolean, Boolean, Integer]*} testPackFlagsParameters = {
    [false, false, false, false, false, $00000010],
    [false, false, false, false, true, $00000011],
    [false, false, false, true, false, $00000110],
    [false, false, false, true, true, $00000111],
    [false, false, true, false, false, $00010010],
    [false, false, true, false, true, $00010011],
    [false, false, true, true, false, $00010110],
    [false, false, true, true, true, $00010111],
    [false, true, false, false, false, $01000010],
    [false, true, false, false, true, $01000011],
    [false, true, false, true, false, $01000110],
    [false, true, false, true, true, $01000111],
    [false, true, true, false, false, $01010010],
    [false, true, true, false, true, $01010011],
    [false, true, true, true, false, $01010110],
    [false, true, true, true, true, $01010111],
    [true, false, false, false, false, $10000010],
    [true, false, false, false, true, $10000011],
    [true, false, false, true, false, $10000110],
    [true, false, false, true, true, $10000111],
    [true, false, true, false, false, $10010010],
    [true, false, true, false, true, $10010011],
    [true, false, true, true, false, $10010110],
    [true, false, true, true, true, $10010111],
    [true, true, false, false, false, $11000010],
    [true, true, false, false, true, $11000011],
    [true, true, false, true, false, $11000110],
    [true, true, false, true, true, $11000111],
    [true, true, true, false, false, $11010010],
    [true, true, true, false, true, $11010011],
    [true, true, true, true, false, $11010110],
    [true, true, true, true, true, $11010111]
};

test
parameters(`value testPackFlagsParameters`)
shared void testPackFlags(Boolean sign, Boolean zero, Boolean auxiliaryCarry, Boolean parity,
        Boolean carry, Integer expected) {
    assertEquals(State.packFlags {
        carry = carry;
        parity = parity;
        auxiliaryCarry = auxiliaryCarry;
        zero = zero;
        sign = sign;
    }, expected.byte);
}

test
shared void testPokeMemorySingle() {
    value size = 8;
    value fill = #ff.byte;
    value poke = 3;
    value val = #ad.byte;
    value memory = State.pokeMemory(Array<Byte>.ofSize(size, fill), poke->val);
    
    for (address in 0:size) {
        if (address == poke) {
            assertEquals(memory[address], val);
        } else {
            assertEquals(memory[address], fill);
        }
    }
}

test
shared void testPokeMemoryMultiple() {
    value size = 8;
    value fill = #ff.byte;
    value poke1 = 3;
    value val1 = #ad.byte;
    value poke2 = 7;
    value val2 = #99.byte;
    value memory = State.pokeMemory(Array<Byte>.ofSize(size, fill), poke1->val1, poke2->val2);
    
    for (address in 0:size) {
        if (address == poke1) {
            assertEquals(memory[address], val1);
        } else if (address == poke2) {
            assertEquals(memory[address], val2);
        } else {
            assertEquals(memory[address], fill);
        }
    }
}
