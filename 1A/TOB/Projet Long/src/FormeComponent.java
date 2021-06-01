import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.Box;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class FormeComponent extends JComponent {
    int x, y, taille, style, a, b, epaisseur;
    String txt, font, forme;
    Color couleur;
    
    FormeComponent(int x, int y, String txt, String font, int taille, int style, Color couleur, String forme, int a, int b, int epaisseur)
    {
        this.x = x;
        this.y = y;
        this.txt = txt;
        this.font = font;
        this.taille = taille;
        this.style = style;
        this.couleur = couleur;
        this.forme = forme;
        this.a = a;
        this.b = b;
        this.epaisseur = epaisseur;
    }

    @Override
    public void paint(Graphics g)
    {
        super.paint(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setStroke(new BasicStroke(epaisseur));
        
        g2.setColor(couleur);
        
        if (forme == "Rectangle") {
        	g2.drawRect(x, y, a, b);
        }else if (forme == "Rectangle Plein") {
        	g2.fillRect(x, y, a, b);
        }else if (forme == "Cercle") {
        	g2.drawOval(x, y, a, b);
        }else if (forme == "Cercle Plein") {
        	g2.fillOval(x, y, a, b);
        }
    }
}
