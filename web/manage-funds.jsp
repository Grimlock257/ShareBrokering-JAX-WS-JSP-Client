<%-- 
    Document   : manage-funds
    Created on : 17-Jan-2021, 15:19:34
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Stocks"%>

<%
    request.setAttribute("currentPage", "manage-funds");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Manage Funds");
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
    UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);

    if (userSessionModel != null) {
%>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Deposit Funds</h1>
    <div class="card card-body bg-dark mb-3">
        <form method="POST" action="?deposit">
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Funds amount</label>
                <div class="col-sm-10">
                    <input type="number" name="fundsAmount" class="form-control" placeholder="100" step="any" min="0" />
                </div>
            </div>
            <div class="row">
                <div class="col-sm-10 offset-md-2">
                    <div class="row">
                        <div class="col-md-6">
                            <button type="reset" class="btn btn-danger w-100">Reset</button>
                        </div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-success w-100">Deposit</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <%
        if (request.getParameter("deposit") != null) {
            String amount = request.getParameter("fundsAmount");

            out.println(Users.getInstance().depositFunds(userSessionModel.getGuid(), amount));
        }
    %>
</div>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Withdraw Funds</h1>
    <div class="card card-body bg-dark mb-3">
        <form method="POST" action="?withdraw">
            <div class="row form-group">
                <label  class="col-sm-2 col-form-label">Funds amount</label>
                <div class="col-sm-10">
                    <input type="number" name="fundsAmount" class="form-control" placeholder="100" step="any" min="0" />
                </div>
            </div>
            <div class="row">
                <div class="col-sm-10 offset-md-2">
                    <div class="row">
                        <div class="col-md-6">
                            <button type="reset" class="btn btn-danger w-100">Reset</button>
                        </div>
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-success w-100">Withdraw</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <%
        if (request.getParameter("withdraw") != null) {
            String amount = request.getParameter("fundsAmount");

            out.println(Users.getInstance().withdrawFunds(userSessionModel.getGuid(), amount));
        }
    %>
</div>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Available Funds</h1>
    <%
        out.println(Users.getInstance().getAvailableFunds(userSessionModel.getGuid()));
    %>
</div>
<%
} else {
%>
<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Uh-oh!</h1>
    <div class='bg-warning p-2 mb-3'>You must be logged in to manage your funds. Please log in!</div>
</div>
<%
    }
%>

<jsp:include page="includes/footer.jsp" />