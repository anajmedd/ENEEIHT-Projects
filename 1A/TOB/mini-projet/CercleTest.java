import java.awt.Color;
import org.junit.*;
import static org.junit.Assert.*;


public class CercleTest {

    // précision pour les comparaisons réelle
	public final static double EPSILON = 0.001;

	// Les points du sujet
	private Point A, B, C, D, E ,G ,F ,O;

	// Les cercles du sujet
	private Cercle C1, C2 ,C3 ,C4;

	@Before public void setUp() {
		// Construire les points
		A = new Point(0, -1);
		B = new Point(4, -1);
		C = new Point(4 ,1);
		D = new Point(8, 1);
		E = new Point(8 ,4);
        G = new Point(8,-2);
        F = new Point(6, 1);
        O = new Point(2,-1);

		// Construire les cercles
		C1 = new Cercle(A,B,Color.green);
		C2 = new Cercle(C, D);
        C3 = new Cercle(E, G);
	
	}

    @Test public void TesterE12(){
        assertEquals("E12 pour C3 : D n'est pas centre de C3",8,C3.getCentre().getX(),EPSILON);
        assertEquals("E12 pour C3 : D n'est pas centre de C3",1,C3.getCentre().getY(),EPSILON);
        assertEquals("E12 pour C3 : le rayon de C3 incorrect",C3.getRayon(),3.0,EPSILON);
        assertEquals("E12 pour C3 : la couleur est incorrect",C3.getCouleur(),Color.blue);

        assertEquals("E12 pour C2 : F n'est pas centre de C2",F.getX(),C2.getCentre().getX(),EPSILON);
        assertEquals("E12 pour C2 : F n'est pas centre de C2",F.getY(),C2.getCentre().getY(),EPSILON);
        assertEquals("E12 pour C2 : le rayon de C2 incorrect",C2.getRayon(),2.0,EPSILON);
        assertEquals("E12 pour C2 : la couleur est incorrect",C2.getCouleur(),Color.blue);
        
    }

    @Test public void TesterE13(){
        assertEquals("E13 pour C1 : O n'est pas centre de C1 ",2,C1.getCentre().getX(),EPSILON);
        assertEquals("E13 pour C1 : O n'est pas centre de C1",-1,C1.getCentre().getY(),EPSILON);
        assertEquals("E13 pour C1 : le rayon de C1 incorrect",C1.getRayon(),2.0,EPSILON);
        assertEquals("E13 pour C1 : la couleur est incorrect",C1.getCouleur(),Color.green);
        

    }

    @Test public void TesterE14(){
        Cercle C4 = new Cercle( new Point(0,1) ,3);
        C4 = C4.creerCercle(D,E);
        assertEquals("E14 pour C4 : le rayon de C4 est incorrect",3.0,C4.getRayon(),EPSILON);
        assertEquals("E14 pour C4 : D n'est pas centre de C4 ",8,C4.getCentre().getX(),EPSILON);
        assertEquals("E14 pour C4 : D n'est pas centre de C4",1,C4.getCentre().getY(),EPSILON);
        assertEquals("E14 pour C4 : la couleur est incorrect",C4.getCouleur(),Color.blue);

       
    }
}

