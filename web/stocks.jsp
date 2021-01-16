<%-- 
    Document   : stocks
    Created on : 09-Nov-2020, 22:49:38
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    request.setAttribute("currentPage", "stocks");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Stocks");

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

        response.sendRedirect("stocks.jsp?loggedout");
    }
%>

<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Shares</h1>

    <jsp:include page="includes/search-pane.jsp" />

    <%
        // Check cookies for guid and role
        UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);
        boolean isLoggedIn = userSessionModel != null;

        // Handle different page states
        if (request.getParameter("search") != null) {
            String stockName = request.getParameter("stockName");
            String stockSymbol = request.getParameter("stockSymbol");
            String stockCurrency = request.getParameter("stockCurrency");
            String sharePriceFilter = request.getParameter("sharePriceFilter");
            String sharePrice = request.getParameter("sharePrice");
            String sortBy = request.getParameter("sortBy");
            String order = request.getParameter("order");

            String searchResult = Stocks.getInstance().handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order, isLoggedIn);

            out.println(searchResult);
        } else if (request.getParameter("buy") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handlePurchase(request, symbol, quantity));
            out.println(Stocks.getInstance().getStocksTable(isLoggedIn));
        } else if (request.getParameter("sell") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handleSale(request, symbol, quantity));
            out.println(Stocks.getInstance().getStocksTable(isLoggedIn));
        } else {
            out.println(Stocks.getInstance().getStocksTable(isLoggedIn));
        }
    %>
</div>

<jsp:include page="includes/sales-modal.jsp" />

<jsp:include page="includes/footer.jsp" />