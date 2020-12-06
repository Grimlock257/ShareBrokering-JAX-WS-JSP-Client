<%-- 
    Document   : stock-management-edit
    Created on : 05-Dec-2020, 23:25:19
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Stock | Stock Management | Adams Share Broker</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" onerror="this.onerror=null;this.href='vendor/bootstrap.min.css';">

        <!-- jQuery and JS bundle w/ Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <!-- Local fallback for jQuery and JS bundle w/ Popper.js -->
        <script>window.jQuery || document.write('<script src="vendor/jquery-3.5.1.min.js">\x3C/script>')</script>
        <script>typeof $().modal !== 'undefined' || document.write('<script src="vendor/bootstrap.bundle.min.js">\x3C/script>')</script>

        <!-- Third-party JS -->
        <script src="https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"></script>

        <!-- Local fallback for third-party JS -->
        <script>typeof Cookies !== 'undefined' || document.write('<script src="vendor/js.cookie.min.js">\x3C/script>')</script>

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
                        <li class="nav-item">
                            <a class="nav-link" href="stock-management.jsp">Stock Management</a>
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
            <h1>Edit Stock</h1>
            <div class="card card-body bg-dark mb-3">
                <form method="POST" action="?edit">
                    <input type="hidden" name="stockSymbol" value="<% out.print(request.getParameter("stockSymbol") != null ? request.getParameter("stockSymbol") : ""); %>" />
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Stock name</label>
                        <div class="col-sm-10">
                            <input type="text" name="stockName" class="form-control" <% out.print(request.getParameter("stockName") != null ? "value='" + request.getParameter("stockName") + "'" : "placeholder='Tesla'"); %>>
                        </div>
                    </div>
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Stock symbol</label>
                        <div class="col-sm-10">
                            <%
                                String newStockSymbolValue = null;

                                if (request.getParameter("newStockSymbol") != null) {
                                    newStockSymbolValue = request.getParameter("newStockSymbol");
                                } else if (request.getParameter("stockSymbol") != null) {
                                    newStockSymbolValue = request.getParameter("stockSymbol");
                                }
                            %>
                            <input type="text" name="newStockSymbol" class="form-control" <% out.print(newStockSymbolValue != null ? "value='" + newStockSymbolValue + "'" : "placeholder='TSLA'"); %>>
                        </div>
                    </div>
                    <div class="row form-group">
                        <label  class="col-sm-2 col-form-label">Quantity</label>
                        <div class="col-sm-10">
                            <input type="number" name="availableShares" class="form-control" <% out.print(request.getParameter("availableShares") != null ? "value='" + request.getParameter("availableShares") + "'" : "placeholder='100'"); %> min="0">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-10 offset-md-2">
                            <div class="row">
                                <div class="col-md-6">
                                    <button type="reset" class="btn btn-danger w-100">Reset</button>
                                </div>
                                <div class="col-md-6">
                                    <button type="submit" class="btn btn-success w-100">Save</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <%
                if (request.getParameter("edit") != null) {
                    String stockName = request.getParameter("stockName");
                    String currentStockSymbol = request.getParameter("stockSymbol");
                    String newStockSymbol = request.getParameter("newStockSymbol");
                    String availableShares = request.getParameter("availableShares");

                    out.println(Stocks.getInstance().handleEdit(stockName, currentStockSymbol, newStockSymbol, availableShares));
                }
            %>
        </div>
    </body>
</html>