<%-- 
    Document   : stocks
    Created on : 09-Nov-2020, 22:49:38
    Author     : Adam Watson
--%>

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
    <h1 class="d-inline mr-auto">Shares</h1>
    <p class="d-inline">hello</p>
    <!--    <form class="js-currencies-form js-currency-preference-form">
            <select name="preferenceCurrency" class="form-control d-none">
                <option value="gbp" readonly>GBP - British Pound (default)</option>
            </select>
        </form>-->

    <jsp:include page="includes/search-pane.jsp" />

    <%
        // Handle different page states
        if (request.getParameter("search") != null) {
            String stockName = request.getParameter("stockName");
            String stockSymbol = request.getParameter("stockSymbol");
            String stockCurrency = request.getParameter("stockCurrency");
            String sharePriceFilter = request.getParameter("sharePriceFilter");
            String sharePrice = request.getParameter("sharePrice");
            String sortBy = request.getParameter("sortBy");
            String order = request.getParameter("order");

            String searchResult = Stocks.getInstance().handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order);

            out.println(searchResult);
        } else if (request.getParameter("buy") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handlePurchase(symbol, quantity));
            out.println(Stocks.getInstance().getStocksTable());
        } else if (request.getParameter("sell") != null) {
            String symbol = request.getParameter("symbol");
            String quantity = request.getParameter("quantity");

            out.println(Stocks.getInstance().handleSale(symbol, quantity));
            out.println(Stocks.getInstance().getStocksTable());
        } else {
            out.println(Stocks.getInstance().getStocksTable());
        }
    %>
</div>

<jsp:include page="includes/sales-modal.jsp" />

<jsp:include page="includes/footer.jsp" />