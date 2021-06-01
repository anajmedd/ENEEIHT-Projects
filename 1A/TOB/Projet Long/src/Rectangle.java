
import java.awt.Graphics;

import javax.swing.JPanel;

public class Rectangle extends JPanel {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/**
	 *
	 */


	@Override
	public void paintComponent(Graphics g){
		//x1, y1, width, height
		g.drawRect(200, 200,100, 40);

	}
}

