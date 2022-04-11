package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.Memory
import com.crappycomic.emulator101.Opcode
import com.crappycomic.emulator101.State
import com.crappycomic.emulator101.emulate
import com.crappycomic.emulator101.interrupts
import java.awt.event.KeyAdapter
import java.awt.event.KeyEvent
import java.util.Timer
import java.util.TimerTask
import javax.swing.JFrame

class Invaders() {
    private val cabinet = InvadersCabinet()

    private var state: State

    init {
        state = State(
            memory = Memory(
                initialValues = loadRom(),
                size = 0x10000
            )
        )

        val panel = InvadersPanel()
        val frame = InvadersFrame(panel)

        connectButtons(cabinet, frame)
        scheduleInterrupts(panel)
    }

    private fun scheduleInterrupts(panel: InvadersPanel) {
        Timer(true).scheduleAtFixedRate(
            object : TimerTask() {
                var opcodeIndex = 0

                val opcodes = listOf(Opcode.RESTART_1, Opcode.RESTART_2)

                override fun run() {
                    val opcode = opcodes[opcodeIndex % opcodes.size]

                    interrupts.offer(opcode)
                    opcodeIndex++

                    if (opcode == Opcode.RESTART_2) {
                        panel.drawFrame(state)
                    }
                }
            },
            1000,
            MILLISECONDS_PER_INTERRUPT.toLong()
        )
    }

    fun gameLoop() {
        var lastInterrupt = System.currentTimeMillis()
        var totalCycles = 0

        while (true) {
//            disassemble(state)

            val (result, cycles) = emulate(state, cabinet)

            state = result
            totalCycles += cycles

            if (state.interruptsEnabled) {
                val interrupt = if (state.stopped) {
                    println("Processor stopped. Waiting for interrupt.")

                    interrupts.take()
                } else {
                    interrupts.poll()
                }

                if (interrupt is Opcode) {
                    state = state.copy(interrupt = interrupt)
                }
            } else {
                if (state.stopped) {
                    println("Processor stopped with interrupts disabled. Exiting.")

                    break
                } else {
                    interrupts.clear()
                }
            }

            if (totalCycles >= CYCLES_PER_INTERRUPT) {
                val sleep = System.currentTimeMillis() - lastInterrupt - MILLISECONDS_PER_INTERRUPT

                if (sleep > 0) {
                    Thread.sleep(sleep)
                }

                lastInterrupt = System.currentTimeMillis()
                totalCycles = 0
            }
        }
    }

    companion object {
        /** Clock divider for slower machines. */
        private const val THROTTLE = 1

        private const val CYCLES_PER_SECOND = 2_000_000 / THROTTLE

        private const val FRAMES_PER_SECOND = 60 / THROTTLE

        private const val INTERRUPTS_PER_SECOND = FRAMES_PER_SECOND * 2

        private const val MILLISECONDS_PER_INTERRUPT = 1_000 / INTERRUPTS_PER_SECOND

        private const val CYCLES_PER_INTERRUPT = CYCLES_PER_SECOND / INTERRUPTS_PER_SECOND

        /**
         * Connects the buttons in the given [cabinet] to a key listener on the given [frame]
         */
        fun connectButtons(cabinet: InvadersCabinet, frame: JFrame) {
            frame.addKeyListener(
                object : KeyAdapter() {
                    override fun keyPressed(event: KeyEvent) {
                        when (event.keyCode) {
                            KeyEvent.VK_1 -> cabinet.player1Start = true
                            KeyEvent.VK_LEFT -> cabinet.player1Left = true
                            KeyEvent.VK_RIGHT -> cabinet.player1Right = true
                            KeyEvent.VK_UP -> cabinet.player1Fire = true
                            KeyEvent.VK_2 -> cabinet.player2Start = true
                            KeyEvent.VK_A -> cabinet.player2Left = true
                            KeyEvent.VK_D -> cabinet.player2Right = true
                            KeyEvent.VK_W -> cabinet.player2Fire = true
                            KeyEvent.VK_C -> cabinet.coin = false
                        }
                    }

                    override fun keyReleased(event: KeyEvent) {
                        when (event.keyCode) {
                            KeyEvent.VK_1 -> cabinet.player1Start = false
                            KeyEvent.VK_LEFT -> cabinet.player1Left = false
                            KeyEvent.VK_RIGHT -> cabinet.player1Right = false
                            KeyEvent.VK_UP -> cabinet.player1Fire = false
                            KeyEvent.VK_2 -> cabinet.player2Start = false
                            KeyEvent.VK_A -> cabinet.player2Left = false
                            KeyEvent.VK_D -> cabinet.player2Right = false
                            KeyEvent.VK_W -> cabinet.player2Fire = false
                            KeyEvent.VK_C -> cabinet.coin = true
                        }
                    }
                }
            )
        }

        fun loadRom(): ByteArray {
            val romE = Invaders::class.java.getResource("/invaders.e")
            val romF = Invaders::class.java.getResource("/invaders.f")
            val romG = Invaders::class.java.getResource("/invaders.g")
            val romH = Invaders::class.java.getResource("/invaders.h")

            requireNotNull(romE) { "Invaders ROM part E not found. Check the README." }
            requireNotNull(romF) { "Invaders ROM part F not found. Check the README." }
            requireNotNull(romG) { "Invaders ROM part G not found. Check the README." }
            requireNotNull(romH) { "Invaders ROM part H not found. Check the README." }

            return romH.readBytes() + romG.readBytes() + romF.readBytes() + romE.readBytes()
        }
    }
}
