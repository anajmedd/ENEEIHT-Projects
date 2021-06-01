import java.awt.*;  
import javax.swing.JFrame;
import javax.swing.JPanel;  
  
public class DisplayGraphics extends JPanel{  
      
    public void paintComponent(Graphics g) { 
    	super.paintComponent(g);
        g.drawString("Hello",40,40);  
        g.fillRect(130, 30,100, 80);  
        g.drawOval(30,130,50, 60);  
        g.fillOval(130,130,50, 60);  
        g.drawArc(30, 200, 40,50,90,60);  
        g.fillArc(30, 130, 40,50,180,40);  
          
    }  
}  