import ceylon.language.meta.declaration {
    FunctionDeclaration
}
import ceylon.test {
    assertEquals,
    test,
    assertFalse,
    assertTrue,
    parameters
}
import ceylon.test.annotation {
    IgnoreAnnotation,
    TestAnnotation
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

{Opcode*} verifyAllOpcodesTestedParameters = `Opcode`.caseValues;

Map<String, FunctionDeclaration> testFunctions = map {
    for (declaration in `package`.members<FunctionDeclaration>())
    if (declaration.name.startsWith("testEmulate"))
    declaration.name.lowercased -> declaration
};

test
parameters(`value verifyAllOpcodesTestedParameters`)
shared void verifyAllOpcodesTested(Opcode opcode) {
    value testFunction = testFunctions["testEmulate``opcode.string``".lowercased];
    
    assertTrue(testFunction exists);
    
    assert (exists testFunction);
    
    assertTrue(testFunction.annotated<TestAnnotation>(), "Function is not annotated test");
    assertTrue(testFunction.annotated<SharedAnnotation>(), "Function is not shared");
    assertFalse(testFunction.annotated<IgnoreAnnotation>(), "Function is ignored");
}
