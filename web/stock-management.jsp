<%-- 
    Document   : stock-management
    Created on : 29-Nov-2020, 20:48:12
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.ws.Role"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    request.setAttribute("currentPage", "stock-management");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Stock Management");

    // Specify any JS includes
    String[] jsFiles = {"stock-management.js"};
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

<%
    // Check cookies for guid and role
    String guid = null;
    String role = null;

    for (Cookie cookie : request.getCookies()) {
        if (cookie.getName().equalsIgnoreCase("guid")) {
            guid = cookie.getValue();

            continue;
        }

        if (cookie.getName().equalsIgnoreCase("role")) {
            role = cookie.getValue().toUpperCase();
        }
    }

    if (guid != null && role != null && (Role.valueOf(role) == Role.ADMIN)) {
%>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Add New Stock</h1>
    <div class="card card-body bg-dark mb-3">
        <form method="POST" action="?add">
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Stock name</label>
                <div class="col-sm-10">
                    <input type="text" name="stockName" class="form-control" placeholder="Tesla" />
                </div>
            </div>
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Stock symbol</label>
                <div class="col-sm-10">
                    <input type="text" name="stockSymbol" class="form-control" placeholder="TSLA" />
                </div>
            </div>
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Quantity</label>
                <div class="col-sm-10">
                    <input type="number" name="shareQuantity" class="form-control" placeholder="100" min="0" />
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
        } else if (request.getParameter("remove") != null) {
            String stockSymbol = request.getParameter("stockSymbol");

            String removeResult = Stocks.getInstance().handleRemove(stockSymbol);

            out.println(removeResult);
            out.println(Stocks.getInstance().getStocksTable(true));
        } else {
            out.println(Stocks.getInstance().getStocksTable(true));
        }
    %>
</div>

<jsp:include page="includes/remove-modal.jsp" />

<%
} else {
%>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Access Denied</h1>
    <div class='bg-danger p-2 mb-3'>You do not have the appropriate permissions to view this page.</div>
</div>
<%
    }
%>

<jsp:include page="includes/footer.jsp" />