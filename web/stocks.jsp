<%-- 
    Document   : stocks
    Created on : 09-Nov-2020, 22:49:38
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.CommonUtils"%>
<%@page import="java.time.ZonedDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.xml.datatype.XMLGregorianCalendar"%>
<%@page import="io.grimlock257.sccc.ws.Stock"%>
<%@page import="java.util.List"%>
<%@page import="io.grimlock257.sccc.ws.ShareBrokering"%>
<%@page import="io.grimlock257.sccc.ws.ShareBrokering_Service"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Stocks | Adams Share Broker</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

        <!-- jQuery and JS bundle w/ Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="main.css" />

        <!-- Custom JS -->
        <script src="stocks.js" type="text/javascript"></script>
        <script src="common.js" type="text/javascript"></script>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body class="bg-dark">
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary shadow">
            <div class="container">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggle">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarToggle">
                    <a class="navbar-brand" href="#">Adams Share Broker</a>
                    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">Home</a>
                        </li>
                        <li class="nav-item active">
                            <a class="nav-link" href="#">Stocks</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container bg-secondary text-white pt-4 pb-1 mb-4">
            <h1>Shares</h1>
            <%
                // Used to populate the search form with previous search criteria
                Boolean wasSearch = request.getParameter("search") != null;
            %>
            <div class="d-flex">
                <div class="p-2 w-100 ">This page lists the shares currently listed on Adams Share Broker</div>
                <div class="p-2">
                    <button class="btn btn-info" id="stocks-search-btn" data-toggle="collapse" data-target="#search">
                        Search<span id="stocks-search-btn-spacer"></span><span id="stocks-search-btn-arrow" class="<% out.println(wasSearch ? "active" : ""); %>">⯆</span>
                    </button>
                </div>
            </div>
            <div class="collapse js-stocks-search-card  <% out.println(wasSearch ? "show" : ""); %>" id="search">
                <div class="card card-body bg-dark mb-4">
                    <form method="POST" action="?search">
                        <div class="form-row">
                            <div class="col-md-5 mb-3">
                                <label>Stock name</label>
                                <input type="text" name="stockName" <% out.println(wasSearch ? "value='" + request.getParameter("stockName") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. coca-cola">
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Stock symbol</label>
                                <input type="text" name="stockSymbol" <% out.println(wasSearch ? "value='" + request.getParameter("stockSymbol") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. KO">
                            </div>
                            <div class="col-md-5 mb-3">
                                <label>Currency</label>
                                <div class="input-group">
                                    <select name="stockCurrency" class="form-control js-stocks-search-selectable">
                                        <option value="" selected readonly>Default (any)</option>
                                        <option value="usd" <% out.println(wasSearch && request.getParameter("stockCurrency").equals("usd") ? "selected" : "");%>>USD</option>
                                        <option value="gbp" <% out.println(wasSearch && request.getParameter("stockCurrency").equals("gbp") ? "selected" : "");%>>GBP</option>
                                        <option value="aud" <% out.println(wasSearch && request.getParameter("stockCurrency").equals("aud") ? "selected" : "");%>>AUD</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="col-md-3 mb-3">
                                <label>Share price is</label>
                                <div class="input-group">
                                    <select name="sharePriceFilter"class="form-control js-stocks-search-selectable">
                                        <option value="equal" selected>Default (equal to)</option>
                                        <option value="lessOrEqual" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("lessOrEqual") ? "selected" : ""); %>>Is less than or equal to</option>
                                        <option value="equal" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("equal") ? "selected" : ""); %>>Is equal to</option>
                                        <option value="greaterOrEqual" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("greaterOrEqual") ? "selected" : ""); %>>Is greater than or equal to</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Share price</label>
                                <input type="number" name="sharePrice" <% out.println(wasSearch ? "value='" + request.getParameter("sharePrice") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. 10" step="any" min="0">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>Sort by</label>
                                <div class="input-group">
                                    <select name="sortBy" class="form-control js-stocks-search-selectable">
                                        <option value="stockSymbol" selected>Default (stock symbol)</option>
                                        <option value="stockName" <% out.println(wasSearch && request.getParameter("sortBy").equals("stockName") ? "selected" : ""); %>>Stock name</option>
                                        <option value="stockSymbol" <% out.println(wasSearch && request.getParameter("sortBy").equals("stockSymbol") ? "selected" : ""); %>>Stock symbol</option>
                                        <option value="shareCurrency" <% out.println(wasSearch && request.getParameter("sortBy").equals("shareCurrency") ? "selected" : ""); %>>Currency</option>
                                        <option value="sharePrice" <% out.println(wasSearch && request.getParameter("sortBy").equals("sharePrice") ? "selected" : ""); %>>Share price</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Order by</label>
                                <div class="input-group">
                                    <select name="order" class="form-control js-stocks-search-selectable">
                                        <option value="desc" selected>Default (descending)</option>
                                        <option value="asc" <% out.println(wasSearch && request.getParameter("order").equals("asc") ? "selected" : ""); %>>Ascending</option>
                                        <option value="desc" <% out.println(wasSearch && request.getParameter("order").equals("desc") ? "selected" : ""); %>>Descending</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-1 mb-3 d-flex flex-column justify-content-end">
                                <button class="btn btn-danger form-control" id="js-stocks-search-reset" type="reset">Reset</button>
                            </div>
                            <div class="col-md-1 mb-3 d-flex flex-column justify-content-end">
                                <button class="btn btn-primary form-control" type="submit">Search!</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
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

                    String searchResult = handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order);

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
    </body>
</html>

<%!
    // Create reference to the web service
    ShareBrokering_Service service = new ShareBrokering_Service();
    ShareBrokering port = service.getShareBrokeringPort();

    /**
     * Handle when a search is submitted, attempt to retrieve search results from the Web Service.
     *
     * @param stockName The stock name to search for (contains)
     * @param stockSymbol The stock symbol to search for (contains)
     * @param stockCurrency The stock currency to search for (equals)
     * @param sharePriceFilter The share price filter (<=, =, >=)
     * @param sharePriceStr The share price as a string
     * @param sortBy The column in which the results should be ordered by
     * @param order Whether to order the sortBy column ascending or descending
     * @return The stocks table or a info diaglog as an HTML string
     */
    public String handleSearch(String stockName, String stockSymbol, String stockCurrency, String sharePriceFilter, String sharePriceStr, String sortBy, String order) {
        Double sharePrice = -1D;

        try {
            sharePrice = Double.parseDouble(sharePriceStr);
        } catch (NumberFormatException e) {
            if (sharePriceStr.length() > 0) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears a non-integer quantity was entered - please try again.</div>";
            }
        }

        List<Stock> filteredStocks = port.searchShares(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order);

        // Check there are stocks actually some stocks
        if (!(filteredStocks.size() > 0)) {
            return "<div class='bg-danger p-2'>Sorry, no stocks met your criteria - please try search again.</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(filteredStocks, true);
        }
    }
%>