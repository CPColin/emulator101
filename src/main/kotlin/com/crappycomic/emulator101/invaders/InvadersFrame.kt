package com.crappycomic.emulator101.invaders

import javax.swing.JFrame
import javax.swing.JPanel

class InvadersFrame(panel: InvadersPanel) : JFrame() {
    init {
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        add(panel)
        pack()
        setLocationRelativeTo(null)
        title = "Invaders"
        isVisible = true
    }
}
