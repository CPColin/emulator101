package com.crappycomic.emulator101

infix fun UShort.add(value: Int) = this add value.toUShort()

infix fun UShort.add(value: UShort) = (this + value).toUShort()

infix fun UShort.shr(bitCount: Int) = ((this.toInt() and 0xffff) ushr bitCount).toUShort()

infix fun UShort.sub(value: Int) = this sub value.toUShort()

infix fun UShort.sub(value: UShort) = (this - value).toUShort()
