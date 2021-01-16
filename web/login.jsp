<%-- 
    Document   : login
    Created on : 16-Jan-2021, 00:35:23
    Author     : AdamW
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>

<%
    request.setAttribute("currentPage", "login");

    // Set the pageTitle attribute for the tab title
    request.setAttribute("pageTitle", "Login");
%>

<jsp:include page="includes/header.jsp" />

<div class="container bg-secondary text-white pt-4 pb-1 mb-4">
    <h1>Login</h1>
    <div class="card card-body bg-dark mb-3">
        <div class="col-md-8 offset-md-2">
            <form method="POST" action="?login">
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
                    <a href="register.jsp" class="offset-md-2 col-sm-10 col-form-label text-white">Not registered? Register!</a>
                </div>
                <div class="row">
                    <div class="col-sm-10 offset-md-2">
                        <div class="row">
                            <div class="col-md-6">
                                <button type="reset" class="btn btn-danger w-100">Reset</button>
                            </div>
                            <div class="col-md-6">
                                <button type="submit" class="btn btn-success w-100">Login!</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <%
        if (request.getParameter("login") != null) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            out.println(Users.getInstance().login(username, password));
        }
    %>
</div>

<jsp:include page="includes/footer.jsp" />