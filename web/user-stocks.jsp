<%-- 
    Document   : user-stocks
    Created on : 17-Jan-2021, 12:20:32
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    // Check cookies for guid and role
    UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);

    if (userSessionModel == null) {
        response.sendRedirect("index.jsp");
    }
%>

<%
    request.setAttribute("currentPage", "user-stocks");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Your Stocks");

    // Specify any JS includes
    String[] jsFiles = {"stocks.js"};
    request.setAttribute("jsIncludes", jsFiles);
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

<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Your Shares</h1>

    <%
        // Handle different page states
        if (request.getParameter("buy") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handlePurchase(request, symbol, quantity));
            out.println(Stocks.getInstance().getUserStocksTable(userSessionModel.getGuid()));
        } else if (request.getParameter("sell") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handleSale(request, symbol, quantity));
            out.println(Stocks.getInstance().getUserStocksTable(userSessionModel.getGuid()));
        } else {
            out.println(Stocks.getInstance().getUserStocksTable(userSessionModel.getGuid()));
        }
    %>
</div>

<jsp:include page="includes/sales-modal.jsp" />

<jsp:include page="includes/footer.jsp" />