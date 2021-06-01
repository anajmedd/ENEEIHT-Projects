import java.awt.Graphics;

import javax.swing.JPanel;

public class Ligne extends JPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	public Ligne() {

	}


	@Override
	public void paintComponent(Graphics g){
		//x1, y1, x2, y2
		g.drawLine(0, this.getHeight(), this.getWidth(), 0);
	}
}
