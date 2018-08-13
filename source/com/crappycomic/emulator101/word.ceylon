"Splits the given [[word]] into its constituent bytes."
shared Byte[2] bytes(Integer word)
        => [word.rightLogicalShift(8).byte, word.byte];

"Merges the given bytes into a 16-bit word."
shared Integer word(Byte? high, Byte? low)
        => (high?.unsigned else 0).leftLogicalShift(8)
            .or(low?.unsigned else 0);
