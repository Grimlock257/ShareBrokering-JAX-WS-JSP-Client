<%--
    Document   : company-profile
    Created on : 28-Nov-2020, 21:07:10
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    request.setAttribute("currentPage", "company-profile");

    // Set the pageTitle attribute for the tab title
    if (request.getParameter("stockName") != null) {
        request.setAttribute("pageTitle", request.getParameter("stockName"));
    } else {
        request.setAttribute("pageTitle", "Company profile");
    }

    // Specify any JS includes
    String[] jsFiles = {"company-profile.js", "stocks.js"};
    request.setAttribute("jsIncludes", jsFiles);
%>

<jsp:include page="includes/header.jsp" />

<%--
    Logout
--%>
<%
    if (request.getParameter("logout") != null) {
        Users.getInstance().logout(response);

        String name = request.getParameter("stockName");
        String symbol = request.getParameter("stockSymbol");

        response.sendRedirect("company-profile.jsp?stockName=" + name + "&stockSymbol=" + symbol + "&loggedout");
    }
%>

<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1 class="js-company-name"></h1>
    <h2>Information</h2>
    <%
        // Check cookies for guid and role
        UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);
        boolean isLoggedIn = userSessionModel != null;

        // Display page contents based on query parameters
        if (request.getParameter("buy") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handlePurchase(request, symbol, quantity));
        } else if (request.getParameter("sell") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handleSale(request, symbol, quantity));
        }

        out.println(Stocks.getInstance().getStockTable(request.getParameter("stockSymbol"), isLoggedIn));
    %>
    <h2>Popular articles</h2>
    <div class="row js-news-item-container c-news-item-container"></div>
</div>

<jsp:include page="includes/sales-modal.jsp" />

<jsp:include page="includes/footer.jsp" />