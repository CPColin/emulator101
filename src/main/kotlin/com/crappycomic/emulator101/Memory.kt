package com.crappycomic.emulator101

data class Memory(
    private val memory: Map<UShort, UByte>,

    val size: Int
) {
    constructor(
        initialValues: ByteArray = ByteArray(0),
        initialValuesOffset: Int = 0,
        size: Int
    ) : this(
        memory = initialValues
            .mapIndexed { index, value -> (index + initialValuesOffset).toUShort() to value.toUByte() }
            .filter { it.first.toInt() < size }
            .toMap(),
        size = size
    )

    fun copyTo(destination: ByteArray, sourceOffset: UShort) {
        val addressRange = sourceOffset until (sourceOffset add destination.size)

        addressRange.forEachIndexed { index, address ->
            destination[index] = get(address).toByte()
        }
    }

    operator fun get(address: Int) = get(address.toUShort())

    operator fun get(address: UInt) = get(address.toUShort())

    operator fun get(address: UShort) = memory[address] ?: DEFAULT_VALUE

    fun with(vararg updates: Pair<UShort, UByte>): Memory {
        val newMemory = memory.toMutableMap()

        updates.forEach { (address, value) ->
            if (address.toInt() < size) {
                if (value == DEFAULT_VALUE) {
                    newMemory.remove(address)
                } else {
                    newMemory[address] = value
                }
            }
        }

        return Memory(
            memory = newMemory,
            size = size
        )
    }

    companion object {
        val DEFAULT_VALUE = 0.toUByte()
    }
}
