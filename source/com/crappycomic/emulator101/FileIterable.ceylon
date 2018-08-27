import java.io {
    BufferedInputStream,
    FileInputStream
}

class FileIterable(String path) satisfies Iterable<Byte> {
    value stream = BufferedInputStream(FileInputStream(path));
    
    shared actual Iterator<Byte> iterator() => object satisfies Iterator<Byte> {
        shared actual Byte|Finished next() {
            value byte = stream.read();
            
            if (byte == -1) {
                stream.close();
                
                return finished;
            } else {
                return byte.byte;
            }
        }
    };
}
