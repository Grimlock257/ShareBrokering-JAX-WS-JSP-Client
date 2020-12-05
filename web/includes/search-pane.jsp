<%-- 
    Document   : search-pane
    Created on : 05-Dec-2020, 22:42:53
    Author     : Adam Watson
--%>

<!-- Search panel -->
<%
    // Used to populate the search form with previous search criteria
    Boolean wasSearch = request.getParameter("search") != null;
%>
<div class="d-flex">
    <div class="p-2 w-100 ">Below is a table of stocks currently listed on Adams Share Broker. Select the search button to the right to search through the stocks</div>
    <div class="p-2">
        <button class="btn btn-info" id="stocks-search-btn" data-toggle="collapse" data-target="#search">
            Search<span id="stocks-search-btn-spacer"></span><span id="stocks-search-btn-arrow" class="<% out.println(wasSearch ? "active" : ""); %>">&#11206;</span>
        </button>
    </div>
</div>
<div class="collapse js-stocks-search-card  <% out.println(wasSearch ? "show" : ""); %>" id="search">
    <div class="card card-body bg-dark mb-4">
        <form>
            <div class="form-row">
                <div class="col-md-5 mb-3">
                    <label>Stock name</label>
                    <input type="text" name="stockName" <% out.println(wasSearch ? "value='" + request.getParameter("stockName") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. coca-cola">
                </div>
                <div class="col-md-2 mb-3">
                    <label>Stock symbol</label>
                    <input type="text" name="stockSymbol" <% out.println(wasSearch ? "value='" + request.getParameter("stockSymbol") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. KO">
                </div>
                <div class="col-md-5 mb-3">
                    <label>Currency</label>
                    <div class="input-group js-currencies-form">
                        <select name="stockCurrency" class="form-control js-stocks-search-selectable">
                            <option value="" readonly>Default (any)</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="col-md-3 mb-3">
                    <label>Share price is</label>
                    <div class="input-group">
                        <select name="sharePriceFilter"class="form-control js-stocks-search-selectable">
                            <option value="equal" selected>Default (equal to)</option>
                            <option value="lessOrEqual" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("lessOrEqual") ? "selected" : ""); %>>Is less than or equal to</option>
                            <option value="equal" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("equal") ? "selected" : ""); %>>Is equal to</option>
                            <option value="greaterOrEqual" <% out.println(wasSearch && request.getParameter("sharePriceFilter").equals("greaterOrEqual") ? "selected" : ""); %>>Is greater than or equal to</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-2 mb-3">
                    <label>Share price</label>
                    <input type="number" name="sharePrice" <% out.println(wasSearch ? "value='" + request.getParameter("sharePrice") + "'" : ""); %> class="form-control js-stocks-search-text-clearable" placeholder="e.g. 10" step="any" min="0">
                </div>
                <div class="col-md-3 mb-3">
                    <label>Sort by</label>
                    <div class="input-group">
                        <select name="sortBy" class="form-control js-stocks-search-selectable">
                            <option value="stockSymbol" selected>Default (stock symbol)</option>
                            <option value="stockName" <% out.println(wasSearch && request.getParameter("sortBy").equals("stockName") ? "selected" : ""); %>>Stock name</option>
                            <option value="stockSymbol" <% out.println(wasSearch && request.getParameter("sortBy").equals("stockSymbol") ? "selected" : ""); %>>Stock symbol</option>
                            <option value="shareCurrency" <% out.println(wasSearch && request.getParameter("sortBy").equals("shareCurrency") ? "selected" : ""); %>>Currency</option>
                            <option value="sharePrice" <% out.println(wasSearch && request.getParameter("sortBy").equals("sharePrice") ? "selected" : ""); %>>Share price</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-2 mb-3">
                    <label>Order by</label>
                    <div class="input-group">
                        <select name="order" class="form-control js-stocks-search-selectable">
                            <option value="desc" selected>Default (descending)</option>
                            <option value="asc" <% out.println(wasSearch && request.getParameter("order").equals("asc") ? "selected" : ""); %>>Ascending</option>
                            <option value="desc" <% out.println(wasSearch && request.getParameter("order").equals("desc") ? "selected" : "");%>>Descending</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-1 mb-3 d-flex flex-column justify-content-end">
                    <button class="btn btn-danger form-control" id="js-stocks-search-reset" type="reset">Reset</button>
                </div>
                <div class="col-md-1 mb-3 d-flex flex-column justify-content-end">
                    <button class="btn btn-primary form-control" name="search" type="submit">Search!</button>
                </div>
            </div>
        </form>
    </div>
</div>