<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>HomePage</title>
</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
  <div>
        <center>
  				<label style="font-family:Cursive;font-size:30px">Scrivi un operazione:</label><br>
  				<%
  				session = request.getSession(false);
  				String query = (String)session.getAttribute("query");
  				String id = (String)request.getParameter("id");
  				String queryOp = (String)request.getParameter("query");
  				if(id != null && queryOp != null) {
  					System.out.println(queryOp);
  					String newQueryOp = "";
  					for(char c: queryOp.toCharArray()) {
  						if (c == '^') {
  							newQueryOp += "\"";
  							continue;
  						}
  						newQueryOp += c;
  					}
  				%>
  					<textarea name="query" form="eseguiOpForm" style="height:300px;width:700px;font-family:Cursive"><%= newQueryOp%></textarea><br>
  				<% }
  				
  				else if(query != null) {
  				%>
  					<textarea name="query" form="eseguiOpForm" style="height:300px;width:700px;font-family:Cursive"><%= query%></textarea><br>
  				<% } else { %>
  					<textarea name="query" form="eseguiOpForm" style="height:300px;width:700px;font-family:Cursive"></textarea><br>
  				<% }
  				String errorQuery = (String)session.getAttribute("errorQuery");
  				if(errorQuery != null) {
  				%>
  				<p><font size=4 color=red style="font-family:Cursive">
  				<%= errorQuery %>
  				</p>
  				<% }
  				session.removeAttribute("query");
  				session.removeAttribute("errorQuery");
  				%>
  				<form method="post" id="eseguiOpForm">
  				<button type="submit" formaction="jsp/operationResult.jsp" class="btn btn-outline-dark" style="font-family:Cursive;font-size:30px">
  				Esegui <i class="fa-solid fa-gears"></i></button>
  				</form>
        </center>
  </div>
  <div class="container" style="padding: 100px">
  	<center>
       	<p>
       	<form method="post"> 
          <button type="submit" formaction="jsp/existingOperations.jsp" class="btn btn-outline-dark" style="font-family:Cursive;font-size:50px">
          Visualizza operazioni esistenti <i class="fa-solid fa-database"></i></button>
          </form>
        </p>
    </center>
  </div>
</body>
</html>