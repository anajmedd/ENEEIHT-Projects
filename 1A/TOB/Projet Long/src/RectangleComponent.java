import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Polygon;
import java.awt.Rectangle;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Line2D;
import java.awt.geom.Point2D;

import javax.swing.JComponent;


public class RectangleComponent extends JComponent
{
    int x, y, taille, style;
    String txt, font;
    Color couleur;
    
    RectangleComponent(int x, int y, String txt, String font, int taille, int style, Color couleur)
    {
        this.x = x;
        this.y = y;
        this.txt = txt;
        this.font = font;
        this.taille = taille;
        this.style = style;
        this.couleur = couleur;
    }

    @Override
    public void paintComponent(Graphics g)
    {
        super.paintComponent(g);
        g.setFont(new Font(font, style, taille)); 
        g.setColor(couleur);
        g.drawString(txt, x, y);
    }
}