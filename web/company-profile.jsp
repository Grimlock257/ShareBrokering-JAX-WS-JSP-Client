<%--
    Document   : company-profile
    Created on : 28-Nov-2020, 21:07:10
    Author     : Adam Watson
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.time.ZonedDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.xml.datatype.XMLGregorianCalendar"%>
<%@page import="java.util.List"%>
<%@page import="io.grimlock257.sccc.ws.Stock"%>
<%@page import="io.grimlock257.sccc.ws.ShareBrokering"%>
<%@page import="io.grimlock257.sccc.ws.ShareBrokering_Service"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Home | Adams Share Broker</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

        <!-- jQuery and JS bundle w/ Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="main.css" />

        <!-- Custom JS -->
        <script src="company-profile.js" type="text/javascript"></script>

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
                        <li class="nav-item">
                            <a class="nav-link" href="stocks.jsp">Stocks</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container bg-secondary text-white pt-4 pb-1 mb-4">
            <h1 class="js-company-name"></h1>
            <%
                // If the stockSymbol is present as a query parameter, display the information section with the stock table entry
                if (request.getParameter("stockSymbol") != null) {
                    out.println("<h2>Information</h2>");
                    out.println(getStockTable(request.getParameter("stockSymbol")));
                }
            %>
            <h2>Popular articles</h2>
            <div class="row js-news-item-container c-news-item-container"></div>
        </div>
    </body>
</html>

<%!
    // Create reference to the web service
    ShareBrokering_Service service = new ShareBrokering_Service();
    ShareBrokering port = service.getShareBrokeringPort();

    /**
     * Retrieve stock from the Web Service and return a HTML table representation, or error diaglog if no stock was found
     *
     * @return The stock table or a error diaglog as an HTML string
     */
    public String getStockTable(String companySymbol) {
        // Get Stock object from the server
        Stock stock = port.getStockBySymbol(companySymbol);

        // Check stock is not null
        if (stock == null) {
            return "<div class='bg-danger p-2'>Sorry, the stock could not be found - check back later, or please try again.</div>";
        } else {
            List<Stock> theStock = new ArrayList<Stock>();
            theStock.add(stock);

            return getStockTableAsHTML(theStock);
        }
    }

    /**
     * Generate a String representing an HTML table of stocks
     *
     * @param stocks The stocks used to populate the table with
     * @return The String representing the HTML table
     */
    public String getStockTableAsHTML(List<Stock> stocks) {
        StringBuilder builder = new StringBuilder();

        // Create table and set up header row
        builder.append("<table class='table table-striped table-dark table-hover'>");
        builder.append("<thead>");
        builder.append("<tr>");
        builder.append("<th></th>");
        builder.append("<th>Company Name</th>");
        builder.append("<th>Stock Symbol</th>");
        builder.append("<th>Available Shares</th>");
        builder.append("<th>Share Currency</th>");
        builder.append("<th>Share Price</th>");
        builder.append("<th>Price Last Updated</th>");
        builder.append("<th></th>");
        builder.append("</tr>");
        builder.append("</thead>");
        builder.append("<tbody>");

        // Iterate over Stock objects, adding a table row for each
        for (Stock stock : stocks) {
            builder.append("<tr class='js-clickable-row c-clickable-row' data-href='company-profile.jsp' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "'>");
            builder.append("<td class='align-middle js-stock-img-cell c-stock-img-cell' data-stock-name='" + stock.getStockName() + "'></td>");
            builder.append("<th class='align-middle'>" + stock.getStockName() + "</th>");
            builder.append("<td class='align-middle'>" + stock.getStockSymbol() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getAvailableShares() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getPrice().getCurrency() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getPrice().getPrice() + "</td>");
            builder.append("<td class='align-middle'>" + formatDateTime(stock.getPrice().getUpdated()) + "</td>");
            builder.append("<td class='align-middle'>");
            builder.append("<button type='button' class='btn btn-warning mr-2 js-sell-btn' data-toggle='modal' data-target='#sales-modal' data-action='Sell' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "'>Sell</button>");
            builder.append("<button type='button' class='btn btn-success js-buy-btn'" + (stock.getAvailableShares() == 0F ? " disabled" : "") + " data-toggle='modal' data-target='#sales-modal' data-action='Buy' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "' data-available-shares='" + stock.getAvailableShares() + "'>Buy</button>");
            builder.append("</td>");
            builder.append("</tr>");
        }

        // Close up the table
        builder.append("</tbody>");
        builder.append("</table>");

        // Return contents as a String
        return builder.toString();
    }

    /**
     * Format the provided XMLGregorianCalendar object into a more readable format
     *
     * @param dateTime The XMLGregorianCalendar object to format
     * @return The formatted date time as a String
     */
    public String formatDateTime(XMLGregorianCalendar dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy HH:mm:ss");
        ZonedDateTime zonedTime = dateTime.toGregorianCalendar().toZonedDateTime();

        return formatter.format(zonedTime);
    }
%>