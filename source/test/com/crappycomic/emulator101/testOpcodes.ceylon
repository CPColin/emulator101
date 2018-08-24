import ceylon.test {
    assertEquals,
    test
}

import com.crappycomic.emulator101 {
    Opcode,
    opcodes
}

test
shared void testOpcodesDistinct() {
    // If we accidentally repeated a value, these won't match.
    assertEquals(opcodes.size, `Opcode`.caseValues.size);
}
