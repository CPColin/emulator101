package com.crappycomic.emulator101

fun format(byte: UByte) = String.format("%02x", byte.toInt())

fun format(short: UShort) = String.format("%04x", short.toInt())
