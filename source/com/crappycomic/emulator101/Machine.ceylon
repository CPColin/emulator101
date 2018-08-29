"A representation of machine hardware connected to the 8080 that can be read from or written to."
shared interface Machine {
    "Reads a byte from the specified [[device]] and returns it."
    shared formal Byte input(Byte device);
    
    "Return a new instance with the given byte of [[data]] written to the specified [[device]]."
    shared formal Machine output(Byte device, Byte data);
}

shared object noopMachine satisfies Machine {
    shared actual Byte input(Byte device) => 0.byte;
    
    shared actual Machine output(Byte device, Byte data) => this;
}
