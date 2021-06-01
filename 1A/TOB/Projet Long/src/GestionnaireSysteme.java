import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class GestionnaireSysteme {

	public static void main(String[] args) {
		// TODO Auto-generated method
		System.out.println("aa");
	}
	
	outil outil_selectionne = null;
	
	public void selectionner(outil outil, JLabel txt) {
		outil_selectionne = outil;
		System.out.println("Outil Selectionne");
		System.out.println(outil_selectionne.Nom);
		System.out.println("####################");
		txt.setText("Outil selectionné: " + outil.Nom);
	}

	/* Bouttons outils gauche */
	public void reculer() {
		System.out.println("On recule eeeeeee");
	}
	public void avancer() {
		System.out.println("On avance ici");
	}
	public void recadrer() {
		System.out.println("recadrer");
	}
	public void bouger() {
		System.out.println("bouger");
	}
	public void zoomer() {
		System.out.println("zoomer");
	}
	public void rotation() {
		System.out.println("rotation");
	}
	public void aligner_gauche() {
		System.out.println("aligner g");
	}
	public void aligner_droite() {
		System.out.println("aligner d");
	}
	public void centrer() {
		System.out.println("centrer");
	}
	public void justifier() {
		System.out.println("justifier");
	}
	public void autocollant() {
		System.out.println("autocollant");
	}
	public void effacer() {
		System.out.println("effacer");
	}


	/* Bouttons outils top */
	public void sauvegarder() {
		System.out.println("ajouter");
	}
	public void texte() {
		System.out.println("TEXTE");
	}
	public void gras() {
		System.out.println("En gras plz");
	}
	public void italique() {
		System.out.println("En italique plz");
	}
	public void sous_ligne() {
		System.out.println("On souligne plz");
	}
	public void change_couleur() {
		System.out.println("change couleur");
	}
	public Stylo stylo() {
		Stylo stylo = new Stylo();
		return stylo;
	}
	public void pinceau() {
		System.out.println("pinceau");
	}
	public void seau() {
		System.out.println("seau");
	}
	public void gomme() {
		System.out.println("gomme");
	}
	public void choisir_forme() {
		System.out.println("seau");
	}


	/* Bouttons calques */
	public void ajouter() {
		System.out.println("ajouter");
	}
	public void supprimer() {
		System.out.println("supprimer");
	}
	public void importer() {
		System.out.println("importer");
	}
	public void opacite() {
		System.out.println("opacite");
	}
	public void melanger() {
		System.out.println("melanger");
	}
}
