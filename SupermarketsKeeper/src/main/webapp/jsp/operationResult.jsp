<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>OperationResult</title>
</head>
<%
String dbURL = "jdbc:mysql://localhost:3306/supermarkets_keeper";
String dbUser = "root";
String dbPass = "";

String select = "SELECT";
String insert = "INSERT";
String update = "UPDATE";
String delete = "DELETE";

session = request.getSession(true);
String reqText = request.getParameter("query");
System.out.println(reqText);

Connection connection = null;
Statement statement = null;
ResultSet resultSet = null;
int updateResult = 0;

String errorQuery = null;

if(reqText != null && reqText != "") {
	try {
		Class.forName("com.mysql.jdbc.Driver");
		connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
		statement = connection.createStatement();
		
		byte[] bytes = reqText.getBytes(StandardCharsets.UTF_8);
		String query = new String(bytes, StandardCharsets.UTF_8);
		System.out.println(query);
		
		%>
		<body>
		<%@ include file="/jsp/onTop.jsp" %>
		<%
		if(reqText.toUpperCase().startsWith(select)) { // SELECT
			resultSet = statement.executeQuery(query);
			ResultSetMetaData metaData = resultSet.getMetaData();
			
			StringBuffer results = new StringBuffer();
			int columnCount = metaData.getColumnCount();
			%>
			<div>
			<table border=1 cellpadding=5 cellspacing=0 width=400 style="border-collapse:collapse;margin-left:auto;margin-right:auto;font-family:Cursive">
			<tr>
			<%
			for (int i = 1; i <= columnCount; i++) {
			%>
				<td style="border: 1px solid black"><b><%= metaData.getColumnName(i)%></b></td>
			<% } %>
			</tr>
				<%
				while (resultSet.next()) { 
				%>
			<tr>
					<%
					for (int i = 1; i <= columnCount; i++) {
					%>
					<td style="border: 1px solid black"><%=resultSet.getObject(i)%></td>
					<% } %>
			</tr>
				<% } %>
			</table>
		<% }
		else if(reqText.toUpperCase().startsWith(insert)) { // INSERT
			updateResult = statement.executeUpdate(query); %>
			<center>
				<p><font size=4 color=green style=""font-family:Cursive">Operazione eseguita con successo: <%=updateResult %> record aggiunto/aggiunti</font></p>
			</center>
			
		<% }
		else if(reqText.toUpperCase().startsWith(update)) { // UPDATE
			updateResult = statement.executeUpdate(query); %>
			<center>
				<p><font size=4 color=green style=""font-family:Cursive">Operazione eseguita con successo: <%=updateResult %> record cambiato/cambiati</font></p>
			</center>
		<% } 
		else if(reqText.toUpperCase().startsWith(delete)) { // DELETE
			updateResult = statement.executeUpdate(query); %>
			<center>
				<p><font size=4 color=green style=""font-family:Cursive">Operazione eseguita con successo: <%=updateResult %> record eliminato/eliminati</font></p>
			</center>
		<% } else
			statement.execute(query);
		
		
	} catch (SQLException e) { // detect problems interacting with the database
		e.printStackTrace();
		System.err.println("SQL problem:" + e.getMessage());
		System.err.println("SQL state" + e.getSQLState());
		System.err.println("Error:" + e.getErrorCode());
		errorQuery = "SQL problem:" + e.getMessage() + "\n" + "SQL state" + e.getSQLState() + "\n" + "Error:" + e.getErrorCode();
		session.setAttribute("errorQuery", errorQuery);
		session.setAttribute("query", reqText);
		response.sendRedirect(response.encodeURL("/SupermarketsKeeper/index.jsp"));

	} catch (ClassNotFoundException e) { // detect problems loading database driver
		e.printStackTrace();
		System.err.println("Non trovo il driver " + e.getMessage());
	}
	finally {
		if (connection != null)
			try { connection.close();
			} 
			catch (SQLException e) {
				e.printStackTrace();
				System.err.println(e.getMessage());
			}
	}
} else { // Campo vuoto o null
	errorQuery = "Scrivi l'operazione!";
	session.setAttribute("errorQuery", errorQuery);
	response.sendRedirect(response.encodeURL("/SupermarketsKeeper/index.jsp"));
	
}
%>
  	<div style="padding: 100px">
		<center>
	      	<form method="post"> 
          	<button type="submit" formaction="/SupermarketsKeeper/index.jsp" class="btn btn-outline-dark" style="font-family:Cursive;font-size:50px">
          	Home <i class="fa-solid fa-house"></i></button>
          	</form>
		</center>
  	</div>
  </div>
</body>
</html>
