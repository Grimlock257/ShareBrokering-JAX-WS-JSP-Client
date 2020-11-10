<%-- 
    Document   : stocks
    Created on : 09-Nov-2020, 22:49:38
    Author     : Adam Watson
--%>

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
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="main.css" />

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
        <div class="container bg-secondary text-white py-1">
            <h1>Shares</h1>
            <p>This page lists the shares currently listed on Adams Share Broker</p>
            <%
                try {
                    // Create reference to the web service
                    ShareBrokering_Service service = new ShareBrokering_Service();
                    ShareBrokering port = service.getShareBrokeringPort();

                    // Get list of Stock objects from the server
                    List<Stock> stocks = port.getAllStocks();

                    // Check there are stocks actually some stocks
                    if (!(stocks.size() > 0)) {
                        out.println("<div class='bg-info p-2'>Sorry, there are no stocks listed at the moment - check back later</div>");
                    } else {
            %>
            <table class="table table-striped table-dark">
                <thead>
                    <tr>
                        <th>Company Name</th>
                        <th>Stock Symbol</th>
                        <th>Available Shares</th>
                        <th>Share Currency</th>
                        <th>Share Price</th>
                        <th>Price Last Updated</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Iterate over Stock objects, adding a table row for each
                        for (Stock stock : stocks) {
                            out.print("<tr>");
                            out.print("<th>" + stock.getStockName() + "</th>");
                            out.print("<td>" + stock.getStockSymbol() + "</td>");
                            out.print("<td>" + stock.getAvailableShares() + "</td>");
                            out.print("<td>" + stock.getPrice().getCurrency() + "</td>");
                            out.print("<td>" + stock.getPrice().getPrice() + "</td>");
                            out.print("<td>" + stock.getPrice().getUpdated() + "</td>");
                            out.print("<td>");
                            out.print("<button type='button' class='btn btn-warning mr-2'>Sell</button>");
                            out.print("<button type='button' class='btn btn-success'" + (stock.getAvailableShares() == 0F ? " disabled" : "") + ">Buy</button>");
                            out.print("</td>");
                            out.print("</tr>");
                        }
                    %>
                </tbody>
            </table>
            <%
                    }
                } catch (Exception e) {
                    out.println("<div class='bg-danger p-2'>Sorry, something went wrong... the error message is: " + e.getMessage() + "</div>");
                }
            %>
        </div>
    </body>
</html>
