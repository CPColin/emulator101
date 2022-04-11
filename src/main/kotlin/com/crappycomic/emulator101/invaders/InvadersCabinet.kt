package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.State

/**
 * Represents the physical state of the various switches and buttons in the Invaders cabinet.
 *
 * Note that, unlike [State] and [InvadersInputOutput], this class is mutable and ephemeral. These
 * properties can be expected to be changed by a different thread than the one that is emulating the
 * 8080 CPU. No synchronization is expected (or sensible).
 */
class InvadersCabinet {
    var coin = true

    var player1Start = false
    var player1Left = false
    var player1Right = false
    var player1Fire = false

    var player2Start = false
    var player2Left = false
    var player2Right = false
    var player2Fire = false
}
