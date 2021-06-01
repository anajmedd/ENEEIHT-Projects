import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.JPanel;

public class Triangle extends JPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	@Override
	public void paint(Graphics g) {
		super.paintComponent(g);
		this.setBackground(Color.WHITE);
		Graphics2D g2 = (Graphics2D) g;
		int[] x = {100, 200, 300};
		int[] y = {300, 127, 300};
		g2.drawPolygon(x,y,3);

	}

}

