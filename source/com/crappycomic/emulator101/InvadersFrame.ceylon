import java.awt {
    Dimension,
    Graphics,
    Graphics2D
}
import java.awt.geom {
    AffineTransform
}
import java.awt.image {
    DataBufferByte,
    BufferedImage,
    Raster
}

import javax.swing {
    JFrame,
    JPanel
}

class InvadersFrame() extends JFrame() {
    shared InvadersPanel panel = InvadersPanel();
    
    defaultCloseOperation = JFrame.exitOnClose;
    add(panel);
    pack();
    setLocationRelativeTo(null);
    title = "Invaders";
    visible = true;
}

class InvadersPanel() extends JPanel() {
    value rasterWidth = 256;
    value rasterHeight = 224;
    value videoRamOffset = #2400;
    value rasterSize = rasterWidth * rasterHeight / 8;
    
    value image = BufferedImage(rasterWidth, rasterHeight, BufferedImage.typeByteBinary);
    
    value transform = AffineTransform();
    
    transform.scale(-1.0, 1.0);
    transform.quadrantRotate(1);
    
    preferredSize = Dimension(rasterHeight, rasterWidth);
    
    shared void drawFrame(State state) {
        value videoRam = Array<Byte>.ofSize(rasterSize, 0.byte);
        
        state.memory.copyTo(videoRam, videoRamOffset, 0, rasterSize);
        
        value dataBuffer = DataBufferByte(videoRam, rasterSize);
        value raster = Raster.createPackedRaster(dataBuffer, rasterWidth, rasterHeight, 1, null);
        
        image.setData(raster);
        
        repaint();
    }
    
    shared actual void paint(Graphics g) {
        assert (is Graphics2D g);
        
        g.drawImage(image, transform, null);
    }
}
