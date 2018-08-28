import java.awt {
    Dimension,
    Graphics,
    Graphics2D
}
import java.awt.geom {
    AffineTransform
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
    
    value [image, videoRam] = invadersVideo(rasterWidth, rasterHeight);
    
    value transform = AffineTransform();
    
    transform.translate(0.0, rasterWidth.float);
    transform.quadrantRotate(-1);
    
    preferredSize = Dimension(rasterHeight, rasterWidth);
    
    shared void drawFrame(State state) {
        state.memory.copyTo(videoRam, videoRamOffset, 0, videoRam.size);
        
        repaint();
    }
    
    shared actual void paint(Graphics g) {
        assert (is Graphics2D g);
        
        g.drawImage(image, transform, null);
    }
}
