import java.awt.EventQueue;
import java.io.File;

import javax.swing.JFrame;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JFileChooser;
import java.awt.Color;

public class SauvegardeInterface {

	private JFrame frmSauvegardeProjet;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					SauvegardeInterface window = new SauvegardeInterface();
					window.frmSauvegardeProjet.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public SauvegardeInterface() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmSauvegardeProjet = new JFrame();
		frmSauvegardeProjet.setTitle("Sauvegarde projet - TaurusCave");
		frmSauvegardeProjet.setBounds(100, 100, 739, 490);
		frmSauvegardeProjet.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		frmSauvegardeProjet.getContentPane().setLayout(new BorderLayout(0, 0));
		
		JPanel panel = new JPanel();
		panel.setBackground(Color.DARK_GRAY);
		frmSauvegardeProjet.getContentPane().add(panel, BorderLayout.NORTH);
		
		JLabel lblNewLabel = new JLabel("Veuillez choisir votre fichier de destination:");
		lblNewLabel.setForeground(Color.WHITE);
		panel.add(lblNewLabel);
		
		JFileChooser fileChooser = new JFileChooser();
		frmSauvegardeProjet.getContentPane().add(fileChooser, BorderLayout.CENTER);
		fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
		int val = fileChooser.showSaveDialog(frmSauvegardeProjet);
		if (val == JFileChooser.APPROVE_OPTION) {
			System.out.println("ok");
		}
	}

}
