<%-- 
    Document   : header.jsp
    Created on : 16-Jan-2021, 11:06:51
    Author     : Adam Watson
--%>

<%@page import="io.grimlock257.sccc.ws.Role"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <%
            if (request.getAttribute("pageTitle") != null) {
                out.println("<title>" + request.getAttribute("pageTitle") + " | Adams Share Broker</title>");
            } else {
                out.println("<title>Adams Share Broker</title>");
            }
        %>

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
        <%
            if (request.getAttribute("jsIncludes") != null) {
                for (String jsFile : (String[]) request.getAttribute("jsIncludes")) {
                    out.println("<script src='" + jsFile + "' type='text/javascript'></script>");
                }
            }
        %>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    </head>
    <body class="bg-dark">
        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary shadow">
            <%
                String currentPage = null;

                if (request.getAttribute("currentPage") != null) {
                    currentPage = (String) request.getAttribute("currentPage");
                }
            %>
            <div class="container">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggle">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarToggle">
                    <a class="navbar-brand" href="#">Adams Share Broker</a>
                    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                        <li class="nav-item">
                            <a class="nav-link <%= currentPage != null && currentPage.equalsIgnoreCase("index") ? "active" : ""%>" href="index.jsp">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <%= currentPage != null && (currentPage.equalsIgnoreCase("stocks") || currentPage.equalsIgnoreCase("company-profile")) ? "active" : ""%>" href="stocks.jsp">Stocks</a>
                        </li>
                        <%
                            // Check cookies for guid and role
                            String guid = null;
                            String role = null;

                            for (Cookie cookie : request.getCookies()) {
                                if (cookie.getName().equalsIgnoreCase("guid")) {
                                    guid = cookie.getValue();
                                }

                                if (cookie.getName().equalsIgnoreCase("role")) {
                                    role = cookie.getValue().toUpperCase();
                                }
                            }

                            if (guid != null && role != null && (Role.valueOf(role) == Role.ADMIN)) {
                        %>
                        <li class="nav-item">
                            <a class="nav-link <%= currentPage != null && (currentPage.equalsIgnoreCase("stock-management") || currentPage.equalsIgnoreCase("stock-management-edit")) ? "active" : ""%>" href="stock-management.jsp">Stock Management</a>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                    <span class="navbar-text">
                        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
                            <%
                                if (guid != null && role != null) {
                            %>
                            <li class="nav-item">
                                <a class="nav-link" href="<%= (request.getQueryString() != null) ? "?" + request.getQueryString() + "&" : "?"%>logout">Logout</a>
                            </li>
                            <%
                            } else {
                            %>
                            <li class="nav-item">
                                <a class="nav-link <%= currentPage != null && currentPage.equalsIgnoreCase("register") ? "active" : ""%>" href="register.jsp">Register</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link <%= currentPage != null && currentPage.equalsIgnoreCase("login") ? "active" : ""%>" href="login.jsp">Login</a>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                    </span>
                </div>
            </div>
        </nav>