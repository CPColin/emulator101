package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.InputOutput
import com.crappycomic.emulator101.set
import com.crappycomic.emulator101.shr
import com.crappycomic.emulator101.word

/**
 * Represents the I/O hardware in the Invaders cabinet.
 *
 * See [this page](http://computerarcheology.com/Arcade/SpaceInvaders/Hardware.html) for details.
 */
data class InvadersInputOutput(
    val shiftHigh: UByte = 0.toUByte(),
    val shiftLow: UByte = 0.toUByte(),
    val shiftOffset: Int = 0
) : InputOutput {
    override fun input(machine: Any?, device: UByte): UByte {
        require(machine is InvadersCabinet)

        return when (device.toInt()) {
            1 -> 0.toUByte()
                .set(6, machine.player1Right)
                .set(5, machine.player1Left)
                .set(4, machine.player1Fire)
                .set(2, machine.player1Start)
                .set(1, machine.player2Start)
                .set(0, machine.coin)
            2 -> 0.toUByte()
                .set(6, machine.player2Right)
                .set(5, machine.player2Left)
                .set(4, machine.player2Fire)
            3 -> {
                val shiftWord = word(shiftHigh, shiftLow)

                (shiftWord shr 8 - shiftOffset).toUByte()
            }
            else -> 0.toUByte()
        }
    }

    override fun output(machine: Any?, device: UByte, data: UByte): InputOutput {
        require(machine is InvadersCabinet)

        return when (device.toInt()) {
            2 -> copy(shiftOffset = data.toInt() and 0x07)
            4 -> copy(shiftLow = shiftHigh, shiftHigh = data)
            else -> this
        }
    }

    override fun validateMachine(machine: Any?) = require(machine is InvadersCabinet)
}
