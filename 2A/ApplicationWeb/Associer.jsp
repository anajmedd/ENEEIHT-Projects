<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" import="java.util.*, pack.*"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Associer</title>
</head>
<body>
    Personnnes :
       <%
       Collection<Personne> personnes =
       (Collection<Personne>)request.getAttribute("personnes") ;
       Collection<Adresse> adresses = (Collection<Adresse>)request.getAttribute("adresses");
       for (Personne p : personnes) {
            String np = p.getNom() + " " + p.getPrenom();
       %>
      <input type="radio" id="<%= p.getId() %>" value="<%= np %>">
       <%
       }
       %>
     Adresses :
     <%
     for (Adresse a : adresses) {
        String adrs = a.getRue() + " " + a.getVille();
     %>
     <input type="radio" id="<%= a.getId() %>" value="<%= adrs %>">
     <%
     }
     %>
</body>
</html>