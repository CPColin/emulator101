package com.crappycomic.emulator101

operator fun UInt.get(bit: Int): Boolean = (this and (1 shl bit).toUInt()).countOneBits() > 0
