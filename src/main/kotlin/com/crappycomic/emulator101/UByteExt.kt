package com.crappycomic.emulator101

operator fun UByte.get(bit: Int): Boolean = (this and (1 shl bit).toUByte()).countOneBits() > 0
