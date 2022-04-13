package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.InputOutput
import com.crappycomic.emulator101.get
import com.crappycomic.emulator101.set
import com.crappycomic.emulator101.shr
import com.crappycomic.emulator101.word

/**
 * Represents the I/O hardware in the Invaders cabinet.
 *
 * See [this page](http://computerarcheology.com/Arcade/SpaceInvaders/Hardware.html) for details.
 */
data class InvadersInputOutput(
    val outputPort3: UByte = 0.toUByte(),
    val outputPort5: UByte = 0.toUByte(),
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

                (shiftWord shr (8 - shiftOffset)).toUByte()
            }
            else -> 0.toUByte()
        }
    }

    override fun output(machine: Any?, device: UByte, data: UByte): InputOutput {
        require(machine is InvadersCabinet)

        return when (device.toInt()) {
            2 -> copy(shiftOffset = data.toInt() and 0x07)
            3 -> {
                if (leadingEdge(outputPort3, data, 0)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.UFO)
                } else if (trailingEdge(outputPort3, data, 0)) {
                    machine.stopSoundEffect(InvadersCabinet.SoundEffect.UFO)
                }
                if (leadingEdge(outputPort3, data, 1)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.SHOT)
                }
                if (leadingEdge(outputPort3, data, 2)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.PLAYER_DEATH)
                }
                if (leadingEdge(outputPort3, data, 3)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.INVADER_DEATH)
                }

                copy(outputPort3 = data)
            }
            4 -> copy(shiftLow = shiftHigh, shiftHigh = data)
            5 -> {
                if (leadingEdge(outputPort5, data, 0)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.FLEET_MOVE_1)
                }
                if (leadingEdge(outputPort5, data, 1)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.FLEET_MOVE_2)
                }
                if (leadingEdge(outputPort5, data, 2)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.FLEET_MOVE_3)
                }
                if (leadingEdge(outputPort5, data, 3)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.FLEET_MOVE_4)
                }
                if (leadingEdge(outputPort5, data, 4)) {
                    machine.startSoundEffect(InvadersCabinet.SoundEffect.UFO_DEATH)
                }

                copy(outputPort5 = data)
            }
            else -> this
        }
    }

    override fun validateMachine(machine: Any?) = require(machine is InvadersCabinet)

    companion object {
        /**
         * Returns true if the given [bit] was `false` in the [oldData] and is `true` in the
         * [newData], indicating the leading edge of a signal pulse.
         */
        fun leadingEdge(oldData: UByte, newData: UByte, bit: Int) = !oldData[bit] && newData[bit]

        /**
         * Returns true if the given [bit] was `true` in the [oldData] and is `false` in the
         * [newData], indicating the trailing edge of a signal pulse.
         */
        fun trailingEdge(oldData: UByte, newData: UByte, bit: Int) = oldData[bit] && !newData[bit]
    }
}
