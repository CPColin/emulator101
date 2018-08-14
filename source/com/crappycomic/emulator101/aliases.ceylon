import ceylon.language.meta.model {
    Attribute
}

shared alias BitFlag => Attribute<State, Boolean>;

shared alias BitFlagUpdate => BitFlag->Boolean;

shared alias ByteRegister => Attribute<State, Byte>;

shared alias ByteRegisterUpdate => ByteRegister->Byte;

shared alias IntegerRegister => Attribute<State, Integer>;

shared alias IntegerRegisterUpdate => IntegerRegister->Integer;

shared alias Memory => Array<Byte>;

shared alias MemoryUpdate => Integer->Byte;
