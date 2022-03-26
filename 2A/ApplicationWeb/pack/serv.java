package pack;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import pack.Facade;
/**
 * Servlet implementation class serv
 */
@WebServlet("/serv")
public class serv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Facade facade;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public serv() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String op = request.getParameter("op");
		if (op.equals("ajoutPersonne")) {
		     this.facade.ajoutPersonne(request.getParameter("nom"),
		     request.getParameter("prenom"));
		     request.getRequestDispatcher("index.html").forward(request, response);
		} else if (op.equals("ajoutAdresse")) {
		     this.facade.ajoutAdresse(request.getParameter("rue"),
		     request.getParameter("ville"));
		     request.getRequestDispatcher("index.html").forward(request, response);
		} else if (op.equals("choix")) {
		   request.setAttribute("listePersonne", this.facade.listePersonnes());
		   request.setAttribute("listeAdresse",this.facade.listeAdresses());
		   request.getRequestDispatcher("choix.jsp").forward(request, response);
		} else if (op.equals("liste")) {
		   request.setAttribute("listePersonne", this.facade.listePersonnes());
		   request.setAttribute("listeAdresse",this.facade.listeAdresses());
		   request.getRequestDispatcher("liste.jsp").forward(request, response);
		}
		response.getWriter().println("<html><body>Hello World !</body></html>");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
