package com.crappycomic.emulator101

fun word(high: UByte, low: UByte): UShort =
    high.toUShort().rotateLeft(8) or low.toUShort()
