<%-- 
    Document   : stock-management
    Created on : 29-Nov-2020, 20:48:12
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Stock Management | Adams Share Broker</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

        <!-- jQuery and JS bundle w/ Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <!-- Third-party JS -->
        <script src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="main.css" />

        <!-- Custom JS -->
        <script src="common.js" type="text/javascript"></script>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body class="bg-dark">
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary shadow sticky-top">
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
                        <li class="nav-item">
                            <a class="nav-link" href="stocks.jsp">Stocks</a>
                        </li>
                        <li class="nav-item active">
                            <a class="nav-link" href="#">Stock Management</a>
                        </li>
                    </ul>
                    <form class="js-currencies-form js-currency-preference-form">
                        <select name="preferenceCurrency" class="form-control d-none">
                            <option value="gbp" readonly>GBP - British Pound (default)</option>
                        </select>
                    </form>
                </div>
            </div>
        </nav>

        <div class="container bg-secondary text-white pt-4 pb-1 mb-4">
            <h1>Add New Stock</h1>
            <div class="card card-body bg-dark mb-3">
                <form method="POST" action="?add">
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Stock name</label>
                        <div class="col-sm-10">
                            <input type="text" name="stockName" class="form-control" placeholder="Tesla">
                        </div>
                    </div>
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Stock symbol</label>
                        <div class="col-sm-10">
                            <input type="text" name="stockSymbol" class="form-control" placeholder="TSLA">
                        </div>
                    </div>
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Quantity</label>
                        <div class="col-sm-10">
                            <input type="number" name="shareQuantity" class="form-control" placeholder="100" min="0">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-10 offset-md-2">
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="reset" class="btn btn-danger w-100">Reset</button>
                                </div>
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-success w-100">Add</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <%
                if (request.getParameter("add") != null) {
                    String stockName = request.getParameter("stockName");
                    String stockSymbol = request.getParameter("stockSymbol");
                    String shareQuantity = request.getParameter("shareQuantity");

                    out.println(Stocks.getInstance().handleAdd(stockName, stockSymbol, shareQuantity));
                }
            %>
        </div>
        <div class="container bg-secondary text-white pt-4 pb-1 mb-4">
            <h1>Edit Existing Stocks</h1>

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

                    String searchResult = Stocks.getInstance().handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order, true);

                    out.println(searchResult);
                } else {
                    out.println(Stocks.getInstance().getStocksTable(true));
                }
            %>
        </div>

        <jsp:include page="includes/sales-modal.jsp" />
    </body>
</html>