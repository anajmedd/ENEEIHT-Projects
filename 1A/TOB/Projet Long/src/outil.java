import java.awt.Color;
import java.awt.Graphics;

import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class outil extends JComponent {
	public String Nom;

	public outil(String nom) {
		Nom = nom;
	}
	
	public void action(int x, int y) {
		System.out.println("actionné");
	}


	public void paint(Graphics g) {
		// TODO Auto-generated method stub
		
	}

	public void end(Graphics g) {
		// TODO Auto-generated method stub
		
	}

	public void action(int x, int y, JFrame frm) {
		// TODO Auto-generated method stub
		
	}

	public void action(int x, int y, String texte, JFrame frm) {
		// TODO Auto-generated method stub
		
	}


	public void action(int x, int y, JFrame frm, String font, int taille, int style, Color couleur, String forme) {
		// TODO Auto-generated method stub
		
	}
	
	
}
