


import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class testTexte
{
    static boolean isPressed = false;

    public static void main(String[] args)
    {
    	JPanel pan = new JPanel();
    	
        final JFrame frame = new JFrame();

        final int FRAME_WIDTH  = 400;
        final int FRAME_HEIGHT = 400;

        frame.setSize(FRAME_WIDTH, FRAME_HEIGHT);
        frame.setTitle("Test 2");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new BorderLayout());
        
        JPanel panel = new JPanel();
        frame.add(panel,BorderLayout.NORTH);


        final JButton btnRectangle = new JButton("Rectangle");
        panel.add(btnRectangle);

        class RectangleButtonListener implements ActionListener
        { 
            public void actionPerformed(ActionEvent event)
            {
                isPressed = true;
            }      
        }

        ActionListener rectButtonListener = new RectangleButtonListener();
        btnRectangle.addActionListener(rectButtonListener);


        class MousePressListener implements MouseListener
        {
            public void mousePressed(MouseEvent event)
            {

            }

            public void mouseReleased(MouseEvent event)
            {
                int x = event.getXOnScreen();
                int y = event.getYOnScreen();

                if(isPressed)
                {
                    RectangleComponent rc = new RectangleComponent(x, y);
                    frame.add(rc);
                    frame.revalidate();
                    frame.repaint();
                }
            }
            public void mouseClicked(MouseEvent event){}
            public void mouseEntered(MouseEvent event){}
            public void mouseExited(MouseEvent event){}
        }

        MousePressListener mListener = new MousePressListener();
        frame.addMouseListener(mListener);


        frame.setVisible(true);
    }

}