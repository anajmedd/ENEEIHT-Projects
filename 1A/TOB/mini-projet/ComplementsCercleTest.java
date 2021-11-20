import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;


/**
*@author Ayoub Najmeddine
 */

public class ComplementsCercleTest {

	// précision pour les comparaisons réelle
	public final static double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B ,C ,D ,E;

	// Les cercles du sujet
	private Cercle C1, C2;

@Before public void setUp() {
		// Construire les points
		A = new Point(4, 1);
		B = new Point(1, 1);
		E = new Point(2, 1);

        //Construire des cercles
        C1 = new Cercle(A,1);
        C2 = new Cercle(B,2);
        
    /** Vérifier si deux points ont mêmes coordonnées.
	  *@param p1 le premier point
	  *@param p2 le deuxième point
	  */
}
	static void memesCoordonnees(String message, Point p1, Point p2) {
		assertEquals(message + " (x)", p1.getX(), p2.getX(), EPSILON);
		assertEquals(message + " (y)", p1.getY(), p2.getY(), EPSILON);
	}

    //E20 : Verifier le point d'intersection entre deux cercles
	@Test public void testerE20() {

        //On translate ce point selon l'axe des abscisses avec la quantité la valeur du rayon
        C = new Point(C1.getCentre().getX() + C1.getRayon(), C1.getCentre().getY());
        //On translate ce point selon négativement selon x avec la quantite la valeur du rayon   
        D = new Point(C2.getCentre().getX() - C2.getRayon(), C2.getCentre().getY());
		memesCoordonnees("E20 : Centre de C1 incorrect", E , C);
        memesCoordonnees("E20 : Centre de C1 incorrect", E , D);
		
        
	}
}
