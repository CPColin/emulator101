package com.crappycomic.emulator101

data class Memory(
    private val memory: ByteArray,

    val size: Int
) {
    constructor(
        initialValues: ByteArray = ByteArray(0),
        initialValuesOffset: Int = 0,
        size: Int
    ) : this(
        memory = ByteArray(size).apply { initialValues.copyInto(this, initialValuesOffset) },
        size = size
    )

    fun copyTo(destination: ByteArray, sourceOffset: UShort) {
        val start = sourceOffset.toInt()
        val end = start + destination.size

        memory.copyInto(destination, 0, start, end)
    }

    override fun equals(other: Any?) =
        other is Memory &&
            memory.contentEquals(other.memory) &&
            size == other.size

    operator fun get(address: Int) = memory[address].toUByte()

    operator fun get(address: UInt) = get(address.toInt())

    operator fun get(address: UShort) = get(address.toInt())

    override fun hashCode() = memory.contentHashCode() * 31 + size

    fun with(vararg updates: Pair<UShort, UByte>): Memory {
        val newMemory = memory.copyOf()

        updates.forEach { (address, value) ->
            if (address.toInt() < size) {
                newMemory[address.toInt()] = value.toByte()
            }
        }

        return Memory(
            memory = newMemory,
            size = size
        )
    }
}
