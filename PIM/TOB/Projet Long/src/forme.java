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

import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;


public class forme extends outil {
	
	int x, y;
	JPanel panel;
	
	public forme(String nom) {
		super(nom);
	}
	
	
	@Override
	public void action(int x, int y, JFrame frm, String font, int taille, int style, Color couleur, String forme) {
		this.x = x;
		this.y = y;
		
    	int a = 0;
    	int b = 0;
    	int epaisseur = 3;
    	
    	JTextField xField = new JTextField(5);
        JTextField yField = new JTextField(5);
        JTextField epField = new JTextField(5);
        
        JPanel myPanel = new JPanel();
        myPanel.add(new JLabel("x:"));
        myPanel.add(xField);
        myPanel.add(Box.createHorizontalStrut(15)); // a spacer
        myPanel.add(new JLabel("y:"));
        myPanel.add(yField);
        myPanel.add(Box.createHorizontalStrut(15)); // a spacer
        myPanel.add(new JLabel("epaiss:"));
        myPanel.add(epField);

        int result = JOptionPane.showConfirmDialog(null, myPanel,
            "Entrez la taille voulue:", JOptionPane.OK_CANCEL_OPTION);
        if (result == JOptionPane.OK_OPTION) {
          a = Integer.parseInt(xField.getText());
          b = Integer.parseInt(yField.getText());
          epaisseur = Integer.parseInt(epField.getText());
        }
		frm.add(new FormeComponent(x,y, "", font, taille, style, couleur, forme, a, b, epaisseur));
	}
	
}
