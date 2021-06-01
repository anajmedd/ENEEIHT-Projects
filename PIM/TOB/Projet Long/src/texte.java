import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.LayoutManager;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;


public class texte extends outil {
	
	int x, y;
	JPanel panel;
	
	public texte(String nom) {
		super(nom);
	}
	
	
	@Override
	public void action(int x, int y, JFrame frm, String font, int taille, int style, Color couleur, String forme) {
		this.x = x;
		this.y = y;
        String result = (String)JOptionPane.showInputDialog("Entrez votre texte:");
        if (result == null) {
        	result = "";
        }
		frm.add(new RectangleComponent(x,y, result, font, taille, style, couleur));
	}
	
}
