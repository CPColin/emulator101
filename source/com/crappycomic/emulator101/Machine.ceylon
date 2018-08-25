"A representation of machine hardware connected to the 8080 that can be read from or written to."
shared interface Machine {
    "Reads a byte from the specified [[device]] and returns it."
    shared formal Byte input(Byte device);
    
    "Write the given byte of [[data]] to the specified [[device]]."
    shared formal void output(Byte device, Byte data);
}
