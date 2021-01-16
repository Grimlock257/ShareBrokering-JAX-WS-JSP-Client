<%-- 
    Document   : index
    Created on : 09-Nov-2020, 22:16:20
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    request.setAttribute("currentPage", "index");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Home");
%>

<jsp:include page="includes/header.jsp" />

<%--
    Logout
--%>
<%
    if (request.getParameter("logout") != null) {
        Users.getInstance().logout(response);

        response.sendRedirect("index.jsp?loggedout");
    }
%>

<div class="container">
    <h1>Hello World!</h1>
</div>

<jsp:include page="includes/footer.jsp" />