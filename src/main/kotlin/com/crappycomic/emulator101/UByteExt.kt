package com.crappycomic.emulator101

infix fun UByte.add(value: Int): UByte = this add value.toUByte()

infix fun UByte.add(value: UByte): UByte = (this + value).toUByte()

operator fun UByte.get(bit: Int): Boolean = (this and (1 shl bit).toUByte()).countOneBits() > 0

fun UByte.set(bit: Int, value: Boolean): UByte =
    (1 shl bit).toUByte().let { mask ->
        if (value) {
            this or mask
        } else {
            this and mask.inv()
        }
    }

infix fun UByte.shl(bitCount: Int): UByte = (this.toUInt() shl bitCount).toUByte()

infix fun UByte.shr(bitCount: Int): UByte = (this.toUInt() shr bitCount).toUByte()

infix fun UByte.sub(value: Int): UByte = this sub value.toUByte()

infix fun UByte.sub(value: UByte): UByte = (this - value).toUByte()
