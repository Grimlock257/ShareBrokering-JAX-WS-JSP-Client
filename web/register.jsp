<%-- 
    Document   : register
    Created on : 16-Jan-2021, 00:02:36
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.sharebrokering.client.Users"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Register | Adams Share Broker</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" onerror="this.onerror=null;this.href='vendor/bootstrap.min.css';" />

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

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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

                    out.println(Users.getInstance().register(firstName, lastName, username, password, currency));
                }
            %>
        </div>
    </body>
</html>