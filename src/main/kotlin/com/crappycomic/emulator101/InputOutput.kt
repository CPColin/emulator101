package com.crappycomic.emulator101

/**
 * Represents hardware connected to the Input and Output lines of the 8080 CPU.
 */
interface InputOutput {
    /**
     * Reads and returns a byte from the given [device].
     */
    fun input(device: UByte): UByte

    /**
     * Returns a copy of this instance, having written the given [data] to the given [device].
     */
    fun output(device: UByte, data: UByte): InputOutput

    companion object {
        /**
         * Implementation of [InputOutput] that doesn't do anything.
         */
        val noop = object : InputOutput {
            override fun input(device: UByte) = 0.toUByte()

            override fun output(device: UByte, data: UByte) = this
        }
    }
}
