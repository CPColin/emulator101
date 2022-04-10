package com.crappycomic.emulator101

data class Memory(
    private val memory: Map<Int, UByte>,

    val size: Int
) {
    constructor(
        initialValues: ByteArray,
        initialValuesOffset: Int = 0,
        size: Int
    ) : this(
        memory = initialValues
            .mapIndexed { index, value -> (index + initialValuesOffset) to value.toUByte() }
            .filter { it.first < size }
            .toMap(),
        size = size
    )

    operator fun get(address: Int) = memory[address] ?: 0.toUByte()

    operator fun get(address: UInt) = get(address.toInt())

    operator fun get(address: UShort) = get(address.toInt())

    fun with(vararg updates: Pair<Int, UByte>): Memory {
        val newMemory = memory.toMutableMap()

        updates.forEach { (address, value) ->
            if (address < size) {
                newMemory[address] = value
            }
        }

        return Memory(
            memory = newMemory,
            size = size
        )
    }
}
