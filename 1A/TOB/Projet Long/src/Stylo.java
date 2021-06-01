import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.LinkedList;
import java.util.List;

import javax.swing.JPanel;

public class Stylo extends JPanel implements MouseMotionListener, MouseListener{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	LinkedList<Point> list = new LinkedList<Point>();
	List<String> actionsEffectuees = new LinkedList<String>();
	
	int epaisseur;
	Color couleur;

	public Stylo(int ep, Color couleur){
		this.epaisseur = ep;
		this.couleur = couleur;
		setLayout(new BorderLayout());
		addMouseListener(this);
		addMouseMotionListener(this);
	}

	@Override
	public void paint(Graphics g) {
		// TODO Auto-generated method stub
		super.paint(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setStroke(new BasicStroke(epaisseur));

        
		for (int i=0; i<list.size() - 1; i++){
			Point p1 = list.get(i);
			Point p2 = list.get(i+1);
	        g2.setColor(couleur);
			g2.drawLine(p1.x, p1.y, p2.x, p2.y);
		}
	}

	@Override
	public void mouseDragged(MouseEvent e) {
		list.add(e.getPoint());
		repaint();
	}


	@Override
	public void mouseMoved(MouseEvent arg0) {
		// TODO Auto-generated method stub
	}


	@Override
	public void mouseClicked(MouseEvent e) {

	}


	@Override
	public void mouseEntered(MouseEvent arg0) {
		// TODO Auto-generated method stub

	}


	@Override
	public void mouseExited(MouseEvent arg0) {
		// TODO Auto-generated method stub
	}



	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		list.add(e.getPoint());
	}



	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		repaint();
	}
}

