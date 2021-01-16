<%-- 
    Document   : register
    Created on : 16-Jan-2021, 00:02:36
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.model.ClientResponseModel"%>
<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>

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

    if (guid != null && role != null) {
        response.sendRedirect("index.jsp");
    }
%>

<%
    request.setAttribute("currentPage", "register");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Register");
%>

<jsp:include page="includes/header.jsp" />

<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Register</h1>
    <div class="card card-body bg-dark mb-3">
        <div class="col-md-8 offset-md-2">
            <form method="POST" action="?register">
                <div class="row form-group">
                    <label class="col-sm-2 col-form-label">First name</label>
                    <div class="col-sm-10">
                        <input type="text" name="firstName" class="form-control" placeholder="Joe" required />
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-sm-2 col-form-label">Last name</label>
                    <div class="col-sm-10">
                        <input type="text" name="lastName" class="form-control" placeholder="Bloggs" required />
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-sm-2 col-form-label">Username</label>
                    <div class="col-sm-10">
                        <input type="text" name="username" class="form-control" placeholder="Joe.Bloggs" required />
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-sm-2 col-form-label">Password</label>
                    <div class="col-sm-10">
                        <input type="password" name="password" class="form-control" placeholder="supersecret" required />
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-sm-2 col-form-label">Currency</label>
                    <div class="col-sm-10 js-currencies-form">
                        <select name="currency" class="form-control js-stocks-search-selectable" required>
                            <option value="" selected readonly disabled>Select funds currency</option>
                        </select>
                    </div>
                </div>
                <div class="row form-group">
                    <a href="login.jsp" class="offset-md-2 col-sm-10 col-form-label text-white">Already registered? Login!</a>
                </div>
                <div class="row">
                    <div class="col-sm-10 offset-md-2">
                        <div class="row">
                            <div class="col-md-6">
                                <button type="reset" class="btn btn-danger w-100">Reset</button>
                            </div>
                            <div class="col-md-6">
                                <button type="submit" class="btn btn-success w-100">Register!</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <%
        if (request.getParameter("register") != null) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String currency = request.getParameter("currency").toUpperCase();

            ClientResponseModel clientResponseModel = Users.getInstance().register(firstName, lastName, username, password, currency);

            if (clientResponseModel.isIsSuccessful()) {
                response.sendRedirect("login.jsp");
            } else {
                out.println(clientResponseModel.getMessage());
            }
        }
    %>
</div>

<jsp:include page="includes/footer.jsp" />