package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.State
import javax.sound.sampled.AudioSystem
import javax.sound.sampled.Clip

/**
 * Represents the physical state of the various switches and buttons in the Invaders cabinet.
 *
 * Note that, unlike [State] and [InvadersInputOutput], this class is mutable and ephemeral. These
 * properties can be expected to be changed by a different thread than the one that is emulating the
 * 8080 CPU. No synchronization is expected (or sensible).
 */
class InvadersCabinet {
    enum class SoundEffect(val filename: String, val loop: Boolean = false) {
        UFO("0.wav", true),
        SHOT("1.wav"),
        PLAYER_DEATH("2.wav"),
        INVADER_DEATH("3.wav"),
        FLEET_MOVE_1("4.wav"),
        FLEET_MOVE_2("5.wav"),
        FLEET_MOVE_3("6.wav"),
        FLEET_MOVE_4("7.wav"),
        UFO_DEATH("8.wav")
    }

    var coin = true

    var player1Start = false
    var player1Left = false
    var player1Right = false
    var player1Fire = false

    var player2Start = false
    var player2Left = false
    var player2Right = false
    var player2Fire = false

    private val soundEffects = SoundEffect.values().associateWith { soundEffect ->
        try {
            val clip = AudioSystem.getClip()

            val wav = javaClass.getResource("/${soundEffect.filename}")

            clip.open(AudioSystem.getAudioInputStream(wav))

            clip
        } catch (exception: Exception) {
            println("Unable to load ${soundEffect.filename}. File missing or format not supported.")

            null
        }
    }

    fun startSoundEffect(soundEffect: SoundEffect) {
        val clip = soundEffects[soundEffect]

        // Reset the frame position so the clip plays again if we've played it before.
        clip?.framePosition = 0

        if (soundEffect.loop) {
            clip?.loop(Clip.LOOP_CONTINUOUSLY)
        } else {
            clip?.start()
        }
    }

    fun stopSoundEffect(soundEffect: SoundEffect) {
        soundEffects[soundEffect]?.stop()
    }
}
