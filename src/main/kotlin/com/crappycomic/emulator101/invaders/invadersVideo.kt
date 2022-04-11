@file:Suppress("JAVA_MODULE_DOES_NOT_EXPORT_PACKAGE")

package com.crappycomic.emulator101.invaders

import sun.awt.image.BytePackedRaster
import java.awt.Image
import java.awt.Point
import java.awt.image.BufferedImage
import java.awt.image.DataBuffer
import java.awt.image.DataBufferByte
import java.awt.image.IndexColorModel
import java.awt.image.MultiPixelPackedSampleModel
import java.awt.image.SampleModel

fun invadersVideo(width: Int, height: Int): Pair<Image, ByteArray> {
    /**
     * The video RAM stores pixels left-to-right as bits 0-7, while this stuff in `java.awt.image`
     * expects the opposite order. This class flips the bit order around on the fly.
     * [BytePackedRaster] is an internal class, so this is clearly pretty fragile. Many other
     * attempts to do this failed, because of various optimizations evading the sprawling class and
     * method hierarchy.
     *
     * This is just an exercise, so whatever.
     */
    class InvadersRaster(sampleModel: SampleModel, dataBuffer: DataBufferByte) :
        BytePackedRaster(sampleModel, dataBuffer, Point(0, 0)) {
        override fun getDataElements(x: Int, y: Int, obj: Any?): Any {
            val flipX = (x / 8 * 8) + (7 - (x % 8))

            return super.getDataElements(flipX, y, obj)
        }
    }


    val invadersColorModel = byteArrayOf(0, 0xff.toByte()).let { IndexColorModel(1, 2, it, it, it) }

    val rasterSize = width * height / 8
    val videoRam = ByteArray(rasterSize)
    val dataBuffer = DataBufferByte(videoRam, rasterSize)
    val sampleModel = MultiPixelPackedSampleModel(DataBuffer.TYPE_BYTE, width, height, 1)
    val raster = InvadersRaster(sampleModel, dataBuffer)
    val image = BufferedImage(invadersColorModel, raster, true, null)

    return image to videoRam
}
