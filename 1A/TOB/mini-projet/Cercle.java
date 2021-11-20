import java.awt.Color;

/** Cercle modélise un ensemble de points à égale distance d'un point centre dans un
  * plan équipé d'un repère cartésien. un cercle peut être affiché et translaté.
  * son périmetre ainsi que son air peuvent être obtenue.
  *
  * @author Ayoub Najmeddine
  */
public class Cercle implements Mesurable2D {
          /** Definition des variables privated. */
          private Point centre;   /**  Centre du cercle. */
          private double rayon;   /**  rayon du cercle. */
          private Color couleur;  /**  Couleur du cercle. */
          /**Definition de la constante PI. */
          public static final double PI = Math.PI;

               /** Construire un cercle à partir d'un point et d'un rayon.
               *  @param  vc centre du cercle
               *  @param  vr  rayon du cercle
               */
          public Cercle(Point vc, double vr) {
               assert vr > 0;
               assert vc != null;
               this.centre = new Point(vc.getX(), vc.getY());
               this.rayon = vr;
               this.couleur = Color.blue;
          }

               /** Construire un cercle à partir de deux points diamétralement opposés.
               * @param  pt1
               * @param  pt2
               */


          public Cercle(Point pt1, Point pt2) {
               assert pt1 != null;
               assert pt2 != null;
               assert pt1.getX() != pt2.getX() ||  pt1.getY() != pt2.getY();
               double cx = (pt1.getX() + pt2.getX()) / 2;
               double cy = (pt1.getY() + pt2.getY()) / 2;
               this.centre = new Point(cx, cy);
               this.rayon = pt1.distance(pt2) / 2;
               this.couleur = Color.blue;
          }
               /** Construire un cercle à partir de deux points diametralement
               * opposes et d'une couleur.
               * @param pt1
               * @param pt2
               * @param couleurcercle  la couleur du cercle
               */
          public Cercle(Point pt1, Point pt2, Color couleurcercle) {
               this(pt1, pt2);
               assert couleurcercle != null;
	          this.setCouleur(couleurcercle);

          }
               /** Construire un cercle à partir d'un point centre et d'un
               * point de son circonference.
               * @param pt1 centre du cercle
               * @param pt2 point de la circonference
               * @return un cercle
               */
          public static Cercle creerCercle(Point pt1, Point pt2) {
               assert pt1 != null;
               assert pt2 != null;
               Point pt = new Point(pt1.getX(), pt1.getY());
               return new Cercle(pt, pt.distance(pt2));

          }
               /** Obtenir le rayon du cercle.
               * @return le rayon du cercle
               */
          public double getRayon() {
               return this.rayon;
          }
               /** Obtenir le centre du cercle.
               * @return le centre du cercle
               */
          public Point getCentre() {
               return new Point(centre.getX(), centre.getY());

          }
               /** Obtenir le diametre du cercle.
               * @return le diametre du cercle
               */
          public double getDiametre() {
               return 2 * this.rayon;
          }
               /** Obtenir la couleur du cercle.
               * @return la couleur du cercle
               */

          public Color getCouleur() {
               return this.couleur;
          }

               /** Modifier la valeur du rayon du cercle.
               * @param vr la nouvelle valeur du rayon
               */
          public void setRayon(double vr) {
               assert vr > 0;
               this.rayon = vr;
          }
               /** Modifier le diametre du cercle.
               * @param vd le nouveau diametre
               */
          public void setDiametre(double vd) {
               assert vd > 0;
               this.rayon =  vd / 2;
          }
               /** Modifier la couleur du cercle.
               * @param vc la nouvelle couleur
               */
          public void setCouleur(Color vc) {
               assert vc != null;
               this.couleur = vc;
          }
               /** Translater un cercle.
               * @param dx le deplacement selon l'axe des abscices
               * @param dy le deplacement selon l'axe des ordonnees
               */
          public void translater(double dx, double dy) {
               this.centre.translater(dx, dy);
          }
               /** Donner le perimetre du cercle.
               * @return le perimetre du cercle
               */
          @Override
		public double perimetre() {
               return 2 * PI * this.rayon;
          }
               /** Donner l aire du cercle.
               * @return l'aire du cercle
               */
          @Override
		public double aire() {
               return PI * this.rayon * this.rayon;
          }
               /** Afficher le cercle sous la forme Cr@(a,b).
               * @return la forme decrite d'affichage du cercle
               */
          @Override
		public String toString() {
               return "C" + this.rayon + "@" + this.centre;
          }
               /** Savoir si un point est interireur au cercle.
               * @param pt le point a tester l'appartenance
               * @return un booleen
               */
          public boolean contient(Point pt) {
               assert pt != null;
               return (centre.distance(pt) <= this.rayon);
          }
}
