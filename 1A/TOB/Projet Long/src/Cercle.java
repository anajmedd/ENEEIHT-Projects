
import java.awt.Graphics;

import javax.swing.JPanel;

public class Cercle extends JPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void paintComponent(Graphics g){
		int x1 = this.getWidth()/4;
		int y1 = this.getHeight()/4;
		g.drawOval(x1, y1, this.getWidth()/2, this.getHeight()/2);
	}
}
