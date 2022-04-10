package com.crappycomic.emulator101

/**
 * Returns the appropriate value for the Auxiliary Carry flag, which is set when a carry comes out
 * of the least significant nibble.
 *
 * For example, the following operation carried out of the low nibble and would set the flag:
 *
 * ```
 *   0000 1000
 * + 0000 1010
 * -----------
 *   0001 0010
 * ```
 *
 * while the following operation did not carry out of the low nibble and would clear the flag:
 *
 * ```
 *   0000 0100
 * + 0001 1010
 * -----------
 *   0001 1110
 * ```
 *
 * The code at <https://bluishcoder.co.nz/js8080/> inspired this code, where we compare bit #4, that
 * is, the least significant bit of the most significant nibble. If the bits matched in the
 * operands, the flag will match the bit in the result. Otherwise, the flag will be the opposite.
 */
fun flagAuxiliaryCarry(left: UByte, right: UByte, result: UByte): Boolean {
    val leftBit = left[4]
    val rightBit = right[4]
    val resultBit = result[4]

    return if (leftBit == rightBit) resultBit else !resultBit
}

fun flagCarry(int: UInt) = int[8]

fun flagParity(byte: UByte) = byte.countOneBits() % 2 == 0

fun flagSign(byte: UByte) = byte[UByte.SIZE_BITS - 1]

fun flagZero(byte: UByte) = byte == 0.toUByte()