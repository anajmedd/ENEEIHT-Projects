import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.SystemColor;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.io.File;

import javax.swing.AbstractListModel;
import javax.swing.Box;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JColorChooser;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSpinner;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.ScrollPaneConstants;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingConstants;
import javax.swing.filechooser.FileNameExtensionFilter;

public class PrincipaleInterface2 implements MouseListener{

	private JFrame frmTaurusCave;
	int font_style = Font.PLAIN;
	Color la_couleur = Color.BLACK;
	String formechoisie = "Rectangle";

	/**
	 * Launch the application. Test
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			@Override
			public void run() {
				try {
					PrincipaleInterface2 window = new PrincipaleInterface2();
					window.frmTaurusCave.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public PrincipaleInterface2() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	public void initialize() {
		
		
		GestionnaireSysteme systeme = new GestionnaireSysteme();
		
		JLabel lblNewLabel_1 = new JLabel("Coordonnées: (0,0)");
		JLabel lblNewLabel = new JLabel("-");
		JLabel outil_selec = new JLabel("Outil selectionné:");
		JLabel style_label = new JLabel("Brut");
		JLabel color_label = new JLabel("Black");
		
		frmTaurusCave = new JFrame();
		frmTaurusCave.getContentPane().setBackground(Color.WHITE);
		frmTaurusCave.setTitle("TaurusCave");
		frmTaurusCave.setBounds(100, 100, 978, 618);
		frmTaurusCave.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frmTaurusCave.getContentPane().setLayout(new BorderLayout(0, 0));

		Box couches = Box.createVerticalBox();
		couches.setBackground(Color.LIGHT_GRAY);
		frmTaurusCave.getContentPane().add(couches, BorderLayout.EAST);

		JButton ajouter_couche = new JButton("Ajouter");
		ajouter_couche.setHorizontalAlignment(SwingConstants.LEFT);
		ajouter_couche.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/file-add-line.png")));
		ajouter_couche.setToolTipText("Ajouter un calque");
		ajouter_couche.setMinimumSize(new Dimension(118, 29));
		ajouter_couche.setMaximumSize(new Dimension(118, 29));
		ajouter_couche.setAlignmentX(0.5f);
		couches.add(ajouter_couche);

		JButton supprimer_couche = new JButton("Supprimer ");
		supprimer_couche.setHorizontalAlignment(SwingConstants.LEFT);
		supprimer_couche.setMaximumSize(new Dimension(118, 29));
		supprimer_couche.setMinimumSize(new Dimension(118, 29));
		supprimer_couche.setAlignmentX(Component.CENTER_ALIGNMENT);
		supprimer_couche.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/delete-bin-line.png")));
		supprimer_couche.setToolTipText("Supprimer le calque");
		couches.add(supprimer_couche);

		JButton importation = new JButton("Importation");
		importation.setHorizontalAlignment(SwingConstants.LEFT);
		importation.setAlignmentX(Component.CENTER_ALIGNMENT);
		importation.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/inbox-unarchive-line.png")));
		importation.setToolTipText("Importer une image");
		couches.add(importation);

		JButton opacite = new JButton("Opacite");
		opacite.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				OpaciteInterface inter = new OpaciteInterface();
				inter.main(null);
			}
		});
		opacite.setHorizontalAlignment(SwingConstants.LEFT);
		opacite.setMaximumSize(new Dimension(118, 29));
		opacite.setMinimumSize(new Dimension(118, 29));
		opacite.setAlignmentX(Component.CENTER_ALIGNMENT);
		opacite.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/sun-line.png")));
		opacite.setToolTipText("Ajuster la luminosité");
		couches.add(opacite);

		JButton melange = new JButton("Mélange");
		melange.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				MelangeInterface inter = new MelangeInterface();
				inter.main(null);
			}
		});
		melange.setHorizontalAlignment(SwingConstants.LEFT);
		melange.setMinimumSize(new Dimension(118, 29));
		melange.setMaximumSize(new Dimension(118, 29));
		melange.setAlignmentX(Component.CENTER_ALIGNMENT);
		melange.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/remixicon-line.png")));
		melange.setToolTipText("Mélanger les calques");
		couches.add(melange);

		JPanel panel = new JPanel();
		FlowLayout flowLayout = (FlowLayout) panel.getLayout();
		flowLayout.setVgap(1);
		flowLayout.setHgap(1);
		couches.add(panel);

		JList list = new JList();
		list.setPreferredSize(new Dimension(90, 300));
		list.setMinimumSize(new Dimension(118, 0));
		list.setMaximumSize(new Dimension(118, 0));
		list.setLayoutOrientation(JList.VERTICAL_WRAP);
		panel.add(list);
		list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		list.setModel(new AbstractListModel() {
			String[] values = new String[] {"Calque1", "Calque2(N/A)"};
			public int getSize() {
				return values.length;
			}
			public Object getElementAt(int index) {
				return values[index];
			}
		});

		Box outils_haut = Box.createHorizontalBox();
		outils_haut.setBackground(Color.LIGHT_GRAY);
		frmTaurusCave.getContentPane().add(outils_haut, BorderLayout.NORTH);

		JButton sauvegarder = new JButton("");
		sauvegarder.setBackground(Color.GRAY);
		sauvegarder.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {

				JFileChooser fileChooser = new JFileChooser();
				fileChooser.setSelectedFile(new File("NouveauProjet.taurus"));
				FileNameExtensionFilter filter = new FileNameExtensionFilter(".taurus", "trs", "png");
				fileChooser.setFileFilter(filter);
				fileChooser.setDialogTitle("Sauvegarde projet - TaurusCave");
				fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
				int val = fileChooser.showDialog(frmTaurusCave, "Sauvegarder");
				fileChooser.setDialogType(JFileChooser.SAVE_DIALOG);
				fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

				if (val == JFileChooser.APPROVE_OPTION) {
					File selectedFile = fileChooser.getSelectedFile();
					System.out.println("Selected file: " + selectedFile.getAbsolutePath());
				}
			}
		});
		sauvegarder.setToolTipText("Sauvegarder");
		sauvegarder.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/download-2-line.png")));
		sauvegarder.setSelectedIcon(null);
		outils_haut.add(sauvegarder);

		JComboBox comboBox = new JComboBox();
		comboBox.setModel(new DefaultComboBoxModel(new String[] {"Arial", "Time", "Helvetica", "Times New Roman", "Calibri"}));
		outils_haut.add(comboBox);

		JSpinner spinner = new JSpinner();
		spinner.setModel(new SpinnerNumberModel(14, 1, Integer.MAX_VALUE, 1));
		outils_haut.add(spinner);

		JButton gras = new JButton("");
		gras.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (font_style != Font.BOLD) {
					font_style = Font.BOLD;
					style_label.setText("Gras");
				}else {
					font_style = Font.PLAIN;
					style_label.setText("Brut");
				}
			}
		});
		
		JButton texte = new JButton("");
		texte.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				texte txt = new texte("texte");
				systeme.selectionner(txt, outil_selec);
			}
		});
		texte.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/text.png")));
		outils_haut.add(texte);
		gras.setToolTipText("Gras");
		gras.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/bold.png")));
		outils_haut.add(gras);

		JButton italique = new JButton("");
		italique.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				if (font_style != Font.ITALIC) {
					font_style = Font.ITALIC;
					style_label.setText("Italique");
				}else {
					font_style = Font.PLAIN;
					style_label.setText("Brut");
				}
			}
		});
		italique.setToolTipText("Italique");
		italique.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/italic.png")));
		outils_haut.add(italique);

		JButton souligne = new JButton("");
		souligne.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				systeme.sous_ligne();
			}
		});
		souligne.setToolTipText("Souligner");
		souligne.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/underline.png")));
		outils_haut.add(souligne);

		JButton couleur = new JButton("");
		couleur.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				la_couleur = JColorChooser.showDialog(frmTaurusCave,"Choose",Color.CYAN);
				color_label.setText(la_couleur.toString());
			}
		});
		couleur.setToolTipText("Changer de couleur");
		couleur.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/font-color.png")));
		outils_haut.add(couleur);

		JButton stylo = new JButton("");
		stylo.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		stylo.setToolTipText("Stylo");
		stylo.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/pencil-line.png")));
		outils_haut.add(stylo);

		JButton pinceau = new JButton("");
		pinceau.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int a = 3;
		    	JTextField xField = new JTextField(5);
		        
		        JPanel myPanel = new JPanel();
		        myPanel.add(new JLabel("epaiss:"));
		        myPanel.add(xField);


		        int result = JOptionPane.showConfirmDialog(null, myPanel,
		            "Entrez l'épaisseur voulue:", JOptionPane.OK_CANCEL_OPTION);
		        if (result == JOptionPane.OK_OPTION) {
		          a = Integer.parseInt(xField.getText());
		        }
				Stylo stylo = new Stylo(a, la_couleur);
				frmTaurusCave.getContentPane().add(stylo);
			}
		});
		pinceau.setToolTipText("Pinceau");
		pinceau.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/brush-line.png")));
		outils_haut.add(pinceau);

		JButton seau = new JButton("");
		seau.setToolTipText("Seau de peinture");
		seau.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/paint-line.png")));
		outils_haut.add(seau);

		JButton gomme = new JButton("");
		gomme.setToolTipText("Gomme");
		gomme.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/eraser-line.png")));
		outils_haut.add(gomme);

		JComboBox comboBox_1 = new JComboBox();
		comboBox_1.setModel(new DefaultComboBoxModel(new String[] {"Rectangle", "Rectangle Plein", "Cercle", "Cercle Plein", "Triangle", "Triangle Plein"}));
		outils_haut.add(comboBox_1);

		JButton selectionner = new JButton("");
		selectionner.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				formechoisie = (String)comboBox_1.getSelectedItem();
				System.out.println(formechoisie);
				forme frme = new forme("Forme");
				systeme.selectionner(frme, outil_selec);
			}
		});
		selectionner.setToolTipText("Selectionner forme");
		selectionner.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/shape-line.png")));
		outils_haut.add(selectionner);

		Box outils_gauche = Box.createVerticalBox();
		outils_gauche.setBackground(Color.LIGHT_GRAY);
		frmTaurusCave.getContentPane().add(outils_gauche, BorderLayout.WEST);

		JButton reculer = new JButton("");
		reculer.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				systeme.reculer();
			}
		});
		reculer.setToolTipText("Reculer");
		reculer.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/arrow-go-back-line.png")));
		outils_gauche.add(reculer);

		JButton avancer = new JButton("");
		avancer.setToolTipText("Avancer");
		avancer.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/arrow-go-forward-line.png")));
		outils_gauche.add(avancer);

		JButton recadrage = new JButton("");
		recadrage.setToolTipText("Recadrage");
		recadrage.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/crop-line.png")));
		outils_gauche.add(recadrage);

		JButton deplacement = new JButton("");
		deplacement.setToolTipText("Deplacer");
		deplacement.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/drag-move-2-line.png")));
		outils_gauche.add(deplacement);

		JButton zoom = new JButton("");
		zoom.setToolTipText("Zoom");
		zoom.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/zoom-in-line.png")));
		outils_gauche.add(zoom);

		JButton rotation = new JButton("");
		rotation.setToolTipText("Rotation");
		rotation.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/anticlockwise-line.png")));
		outils_gauche.add(rotation);

		JButton aligng = new JButton("");
		aligng.setToolTipText("Aligner à gauche");
		aligng.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/align-left.png")));
		outils_gauche.add(aligng);

		JButton alignd = new JButton("");
		alignd.setToolTipText("Aligner à droite");
		alignd.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/align-right.png")));
		outils_gauche.add(alignd);

		JButton alignc = new JButton("");
		alignc.setToolTipText("Centrer");
		alignc.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/align-center.png")));
		outils_gauche.add(alignc);

		JButton justify = new JButton("");
		justify.setToolTipText("Justifier");
		justify.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/align-justify.png")));
		outils_gauche.add(justify);

		JButton autocollants = new JButton("");
		autocollants.setToolTipText("Autocollants");
		autocollants.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/image-line.png")));
		outils_gauche.add(autocollants);

		JButton supprimer = new JButton("");
		supprimer.setToolTipText("Supprimer");
		supprimer.setIcon(new ImageIcon(PrincipaleInterface2.class.getResource("/icons/delete-bin-line.png")));
		outils_gauche.add(supprimer);

		JPanel sud = new JPanel();
		sud.setBackground(Color.LIGHT_GRAY);
		frmTaurusCave.getContentPane().add(sud, BorderLayout.SOUTH);
		sud.setLayout(new BorderLayout(0, 0));

		JPanel panel_1 = new JPanel();
		panel_1.setBackground(SystemColor.window);
		sud.add(panel_1, BorderLayout.SOUTH);
		
		panel_1.add(color_label);
		
		JLabel lblNewLabel_3 = new JLabel("-");
		panel_1.add(lblNewLabel_3);
		
		panel_1.add(style_label);
		
		JLabel lblNewLabel_2 = new JLabel("-");
		panel_1.add(lblNewLabel_2);

		panel_1.add(lblNewLabel_1);		
		panel_1.add(lblNewLabel);
		panel_1.add(outil_selec);
		
		frmTaurusCave.addMouseMotionListener(new MouseMotionListener() {

			@Override
			public void mouseDragged(MouseEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void mouseMoved(MouseEvent e) {
				// TODO Auto-generated method stub
			    int x=e.getX();
			    int y=e.getY();
			    lblNewLabel_1.setText("Coordonnées: (" + x + "," + y + ")");
			}
			
		});
		
		frmTaurusCave.addMouseListener(new MouseListener() {

			@Override
			public void mouseClicked(MouseEvent e) {
				// TODO Auto-generated method stub
			    int x=e.getX();
			    int y=e.getY();
			    int offset = 50;
			    System.out.println(x+","+y);
			    if(systeme.outil_selectionne != null) {
			    	systeme.outil_selectionne.action(x-offset, y-offset, frmTaurusCave, (String)comboBox.getSelectedItem(), 
			    			(int) spinner.getValue(), font_style, la_couleur, formechoisie);
			    }
				
			}

			@Override
			public void mousePressed(MouseEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void mouseReleased(MouseEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void mouseEntered(MouseEvent e) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void mouseExited(MouseEvent e) {
				// TODO Auto-generated method stub
				
			}
			
		});
	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
		System.out.println("eee");
		
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

}
