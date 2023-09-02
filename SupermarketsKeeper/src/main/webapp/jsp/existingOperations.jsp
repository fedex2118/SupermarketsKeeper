<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.beans.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>ExistingOperations</title>
</head>
<body>
<%@ include file="/jsp/onTop.jsp" %>
<div style="font-family:Cursive">
<center>
<%
	OperationsContainer operations = (OperationsContainer)session.getAttribute("operations");
	
	if (operations == null) {
		operations = new OperationsContainer();
	
		operations.initializeContainer("/sqlFiles/DML.sql");
		
		session.setAttribute("operations", operations);
	}
	
	String path = "/SupermarketsKeeper/index.jsp";
	
	for(Operation operation: operations.getOperations()) { 
		int id = operation.getId();
		String query = operation.getQuery();
		String description = operation.getDescription();
	%>
		<hr>
		<p><b><font size=6>Operazione: <%=id %></font></b></p>
		<p>Descrizione:</p>
		<p><%=description %></p>
		<form method="post">
		<input type="hidden" name="id" value=<%=id %>>
		<input type="hidden" name="query" value="<%=query %>">
		
		<button type="submit" formaction=<%=path %> class="btn btn-outline-dark" style="font-family:Cursive;font-size:30px">
		Seleziona <i class="fa-solid fa-truck-ramp-box"></i></button>
		</form>
		<p></p>
	<%
	}
%>
</center>
</div>
</body>
</html>