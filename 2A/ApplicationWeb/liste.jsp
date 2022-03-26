<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" import="java.util.*, pack.*"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>liste</title>
</head>
<body>
Personnes :
<%
Collection<Personne> personnes = (Collection<Personne>)request.getAttribute("personnes") ;
Collection<Adresse> adresses = (Collection<Adresse>)request.getAttribute("adresses");
for (Personne p : personnes) {
String out1 = p.getNom() + " " + p.getPrenom();
%>
<%= out1 %>
<%
for (Adresse a : adresses) {
String out2 = a.getRue() + " " + a.getVille();
%>
<%= out2 %>
<%
}
}
%>
</body>
</html>