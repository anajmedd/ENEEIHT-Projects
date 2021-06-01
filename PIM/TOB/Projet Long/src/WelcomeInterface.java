

import java.awt.EventQueue;

import javax.swing.JFrame;
import java.awt.BorderLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.awt.Font;
import java.awt.FlowLayout;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JSplitPane;
import javax.swing.ImageIcon;
import java.awt.Component;
import javax.swing.SwingConstants;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.Box;
import java.awt.Color;
import java.awt.Rectangle;
import java.awt.event.ActionListener;
import java.io.File;
import java.awt.event.ActionEvent;

public class WelcomeInterface {

	private JFrame frmBienvenue;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					WelcomeInterface window = new WelcomeInterface();
					window.frmBienvenue.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public WelcomeInterface() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frmBienvenue = new JFrame();
		frmBienvenue.setTitle("Menu Principal - TaurusCave");
		frmBienvenue.setBounds(100, 100, 450, 300);
		frmBienvenue.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmBienvenue.getContentPane().setLayout(new BorderLayout(0, 0));
		
		JPanel panel = new JPanel();
		panel.setBackground(Color.DARK_GRAY);
		frmBienvenue.getContentPane().add(panel, BorderLayout.NORTH);
		
		Box verticalBox = Box.createVerticalBox();
		panel.add(verticalBox);
		
		JLabel lblNewLabel = new JLabel("Bienvenue sur TaurusCave");
		lblNewLabel.setForeground(Color.WHITE);
		verticalBox.add(lblNewLabel);
		lblNewLabel.setFont(new Font("Lucida Grande", Font.PLAIN, 18));
		
		JLabel lblNewLabel_2 = new JLabel("<html><body>Donnez vie à vos idées à l'aide <br>\nde l'interface épurée de TaurusCave <br>\npour tous vos projets de dessin vectoriel <br>\net retouche photo.</body></html>");
		lblNewLabel_2.setAlignmentX(Component.CENTER_ALIGNMENT);
		lblNewLabel_2.setHorizontalTextPosition(SwingConstants.CENTER);
		lblNewLabel_2.setHorizontalAlignment(SwingConstants.CENTER);
		lblNewLabel_2.setForeground(Color.WHITE);
		verticalBox.add(lblNewLabel_2);
		
		JPanel panel_1 = new JPanel();
		frmBienvenue.getContentPane().add(panel_1, BorderLayout.CENTER);
		panel_1.setLayout(new FlowLayout(FlowLayout.CENTER, 5, 5));
		
		JButton nouveau = new JButton("Nouveau projet");
		nouveau.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				frmBienvenue.dispose();
				PrincipaleInterface2 inter = new PrincipaleInterface2(); 
				inter.main(null);
			}
		});
		nouveau.setVerticalTextPosition(SwingConstants.BOTTOM);
		nouveau.setHorizontalTextPosition(SwingConstants.CENTER);
		nouveau.setIcon(new ImageIcon(WelcomeInterface.class.getResource("/icons/file-line.png")));
		panel_1.add(nouveau);
		
		JButton projet_sauvegarde = new JButton("Projet sauvegardé");
		projet_sauvegarde.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser();
				FileNameExtensionFilter filter = new FileNameExtensionFilter(".taurus", "trs", "png");
				fileChooser.setFileFilter(filter);
				fileChooser.setDialogTitle("Ouvrir projet - TaurusCave");
				fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
				int val = fileChooser.showDialog(frmBienvenue, "Ouvrir");
				fileChooser.setDialogType(JFileChooser.OPEN_DIALOG);
				fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);

				if (val == JFileChooser.APPROVE_OPTION) {
				    File selectedFile = fileChooser.getSelectedFile();
				    System.out.println("Selected file: " + selectedFile.getAbsolutePath());
					frmBienvenue.dispose();
					PrincipaleInterface inter = new PrincipaleInterface(); 
					inter.main(null);
				}
			}
		});
		projet_sauvegarde.setVerticalTextPosition(SwingConstants.BOTTOM);
		projet_sauvegarde.setIcon(new ImageIcon(WelcomeInterface.class.getResource("/icons/save-line.png")));
		projet_sauvegarde.setHorizontalTextPosition(SwingConstants.CENTER);
		panel_1.add(projet_sauvegarde);
		
		JPanel panel_2 = new JPanel();
		frmBienvenue.getContentPane().add(panel_2, BorderLayout.SOUTH);
		
		JLabel lblNewLabel_1 = new JLabel("Projet Tob - 2021");
		panel_2.add(lblNewLabel_1);
	}

}
