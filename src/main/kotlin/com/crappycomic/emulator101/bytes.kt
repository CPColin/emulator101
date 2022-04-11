package com.crappycomic.emulator101

fun bytes(word: UShort) = word.rotateRight(UByte.SIZE_BITS).toUByte() to word.toUByte()
