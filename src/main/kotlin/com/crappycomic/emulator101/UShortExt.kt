package com.crappycomic.emulator101

infix fun UShort.add(value: Int) = this add value.toUShort()

infix fun UShort.add(value: UShort) = (this + value).toUShort()