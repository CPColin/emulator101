package com.crappycomic.emulator101

data class Memory(
    private val memory: Map<UShort, UByte>,

    val size: UShort
) {
    constructor(
        initialValues: ByteArray = ByteArray(0),
        initialValuesOffset: Int = 0,
        size: Int
    ) : this(
        memory = initialValues
            .mapIndexed { index, value -> (index + initialValuesOffset).toUShort() to value.toUByte() }
            .filter { it.first < size.toUShort() }
            .toMap(),
        size = size.toUShort()
    )

    operator fun get(address: Int) = get(address.toUShort())

    operator fun get(address: UInt) = get(address.toUShort())

    operator fun get(address: UShort) = memory[address] ?: 0.toUByte()

    fun with(vararg updates: Pair<UShort, UByte>): Memory {
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
