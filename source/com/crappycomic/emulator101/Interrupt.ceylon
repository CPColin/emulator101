import java.util.concurrent {
    ArrayBlockingQueue,
    BlockingQueue
}

"Encapsulates one or more bytes of interrupt data on the system bus. The first byte is required and
 is the opcode for the operation to be executed. The next two bytes are optional data."
shared class Interrupt(Byte+ data) {
    shared Byte opcode => data[0];
    
    shared Byte? dataByte => data[1];
    
    shared Byte[2]? dataBytes
            => if (exists high = data[2], exists low = data[1])
                then [high, low]
                else null;
    
    shared Integer? dataWord
            => if (exists [high, low] = dataBytes)
                then word(high, low)
                else null;
}

BlockingQueue<Interrupt> interrupt = ArrayBlockingQueue<Interrupt>(1);
