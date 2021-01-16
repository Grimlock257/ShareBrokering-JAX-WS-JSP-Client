<%-- 
    Document   : stock-management-edit
    Created on : 05-Dec-2020, 23:25:19
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.ws.Role"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    request.setAttribute("currentPage", "stock-management-edit");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Edit Stock | Stock Management");
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
    <h1>Edit Stock</h1>
    <div class="card card-body bg-dark mb-3">
        <form method="POST" action="?edit">
            <input type="hidden" name="stockSymbol" value="<% out.print(request.getParameter("stockSymbol") != null ? request.getParameter("stockSymbol") : ""); %>" />
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Stock name</label>
                <div class="col-sm-10">
                    <input type="text" name="stockName" class="form-control" <% out.print(request.getParameter("stockName") != null ? "value='" + request.getParameter("stockName") + "'" : "placeholder='Tesla'"); %> />
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
                    <input type="text" name="newStockSymbol" class="form-control" <% out.print(newStockSymbolValue != null ? "value='" + newStockSymbolValue + "'" : "placeholder='TSLA'"); %> />
                </div>
            </div>
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Quantity</label>
                <div class="col-sm-10">
                    <input type="number" name="availableShares" class="form-control" <% out.print(request.getParameter("availableShares") != null ? "value='" + request.getParameter("availableShares") + "'" : "placeholder='100'"); %> min="0 /">
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