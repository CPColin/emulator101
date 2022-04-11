package com.crappycomic.emulator101

/**
 * Represents hardware connected to the Input and Output lines of the 8080 CPU.
 */
interface InputOutput {
    /**
     * Reads and returns a byte from the given [device], assuming the given [machine] is attached
     * and of a supported type.
     */
    fun input(machine: Any?, device: UByte): UByte

    /**
     * Returns a copy of this instance, having written the given [data] to the given [device],
     * assuming the given [machine] is attached and of a supported type.
     */
    fun output(machine: Any?, device: UByte, data: UByte): InputOutput

    /**
     * Throws an exception if the given [machine] is of an unsupported type.
     *
     * (This is to evade a mess of generics.)
     */
    fun validateMachine(machine: Any?)

    companion object {
        /**
         * Implementation of [InputOutput] that doesn't do anything.
         */
        val noop = object : InputOutput {
            override fun input(machine: Any?, device: UByte) = 0.toUByte()

            override fun output(machine: Any?, device: UByte, data: UByte) = this

            override fun validateMachine(machine: Any?) {}
        }
    }
}
