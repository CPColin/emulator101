import java.awt {
    Image,
    Point
}
import java.awt.image {
    BufferedImage,
    ColorModel,
    DataBuffer,
    DataBufferByte,
    IndexColorModel,
    MultiPixelPackedSampleModel,
    SampleModel
}
import java.lang {
    ByteArray
}

import sun.awt.image {
    BytePackedRaster
}

ColorModel invadersColorModel {
    ByteArray values = ByteArray(2, 0.byte);
    
    values[1] = #ff.byte;
    
    return IndexColorModel(1, 2, values, values, values);
}

"The video RAM stores pixels left-to-right as bits 0-7, while this stuff in `java.awt.image` expects
 the opposite order. This class flips the bit order around on the fly. [[BytePackedRaster]] is an
 internal class, so this is clearly pretty fragile. Many other attempts to do this failed, because
 of various optimizations evading the sprawling class and method hierarchy.
 
 This is just an exercise, so whatever."
class InvadersRaster(Integer width, Integer height, SampleModel sampleModel,
            DataBufferByte dataBuffer)
        extends BytePackedRaster(sampleModel, dataBuffer, Point(0, 0)) {
    shared actual Object getDataElements(Integer x, Integer y, Object? obj) {
        value flipX = (x / 8 * 8) + (7 - (x % 8));
        
        return super.getDataElements(flipX, y, obj);
    }
}

[Image, Array<Byte>] invadersVideo(Integer width, Integer height) {
    value rasterSize = width * height / 8;
    value videoRam = Array<Byte>.ofSize(rasterSize, 0.byte);
    value dataBuffer = DataBufferByte(videoRam, rasterSize);
    value sampleModel = MultiPixelPackedSampleModel(DataBuffer.typeByte, width, height, 1);
    value raster = InvadersRaster(width, height, sampleModel, dataBuffer);
    value image = BufferedImage(invadersColorModel, raster, true, null);
    
    return [image, videoRam];
}
