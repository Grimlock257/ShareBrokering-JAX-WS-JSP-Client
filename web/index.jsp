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

<div class="container bg-secondary text-white pt-4 pb-1 mb-4 text-center">
    <h1>Home</h1>
    <p>This is the Shares Brokering system developed by Adam Watson for NTU module COMP30231: Service Centric & Cloud Computing.</p>
</div>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4 text-center">
    <h2>Using the System</h2>
    <p>Use the navigation bar at the top of the page to navigate between the pages - different pages will be available once you're logged in!</p>
    <hr />
    <b>Note:</b><p class='d-inline'> You will need to have sufficient funds in order to purchase shares for a given stock.
</div>

<jsp:include page="includes/footer.jsp" />