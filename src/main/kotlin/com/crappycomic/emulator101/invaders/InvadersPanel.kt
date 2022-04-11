package com.crappycomic.emulator101.invaders

import com.crappycomic.emulator101.State
import java.awt.Dimension
import java.awt.Graphics
import java.awt.Graphics2D
import java.awt.Image
import java.awt.geom.AffineTransform
import javax.swing.JPanel

class InvadersPanel : JPanel() {
    private val invadersVideo = invadersVideo(RASTER_WIDTH, RASTER_HEIGHT)

    private val image: Image = invadersVideo.first

    private val transform = AffineTransform().apply {
        translate(0.0, RASTER_WIDTH.toDouble())
        quadrantRotate(-1)
    }

    private val videoRam: ByteArray = invadersVideo.second

    init {
        // Flipping the dimensions because we're rotating ourselves 90°.
        preferredSize = Dimension(RASTER_HEIGHT, RASTER_WIDTH)
    }

    fun drawFrame(state: State) {
        state.memory.copyTo(
            destination = videoRam,
            sourceOffset = VIDEO_RAM_OFFSET
        )

        repaint()
    }

    override fun paint(g: Graphics?) {
        require(g is Graphics2D)

        g.drawImage(image, transform, null)
    }

    companion object {
        const val RASTER_HEIGHT = 224

        const val RASTER_WIDTH = 256

        val VIDEO_RAM_OFFSET = 0x2400.toUShort()
    }
}