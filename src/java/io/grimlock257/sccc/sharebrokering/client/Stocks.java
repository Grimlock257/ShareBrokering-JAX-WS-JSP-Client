package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel;
import io.grimlock257.sccc.ws.ShareBrokering;
import io.grimlock257.sccc.ws.ShareBrokering_Service;
import io.grimlock257.sccc.ws.Stock;
import io.grimlock257.sccc.ws.UserStock;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.xml.ws.WebServiceException;

/**
 * Stocks
 *
 * Contains methods regarding stocks such as retrieving table or stocks, or handling or purchasing and selling
 *
 * @author Adam Watson
 */
public class Stocks {

    private static Stocks instance = null;

    /**
     * Private constructor to prevent instantiation
     */
    private Stocks() {
    }

    /**
     * Get the instance of the Stocks singleton
     *
     * @return The instance of the Stocks
     */
    public static Stocks getInstance() {

        if (instance == null) {
            instance = new Stocks();
        }

        return instance;
    }

    /**
     * Retrieve stocks from the Web Service and return a HTML table representation, or info dialog if there are no Stocks to display (non management mode)
     *
     * @param isLoggedIn Whether a user is logged in
     * @return The stocks table or a info dialog as an HTML string
     */
    public String getStocksTable(boolean isLoggedIn) {
        return getStocksTable(false, isLoggedIn);
    }

    /**
     * Retrieve stocks from the Web Service and return a HTML table representation, or info dialog if there are no Stocks to display
     *
     * @param managementMode Whether the table should be for the management mode
     * @param isLoggedIn Whether a user is logged in
     * @return The stocks table or a info dialog as an HTML string
     */
    public String getStocksTable(boolean managementMode, boolean isLoggedIn) {
        // Get list of Stock objects from the server
        List<Stock> stocks;

        try {
            stocks = getPort().getAllStocks();
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        // Check there are stocks actually some stocks
        if (!(stocks.size() > 0)) {
            return "<div class='bg-info p-2 mb-3'>Sorry, there are no stocks listed at the moment - check back later</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(stocks, true, managementMode, isLoggedIn);
        }
    }

    /**
     * Retrieve stock from the Web Service and return a HTML table representation, or error dialog if no stock was found
     *
     * @param companySymbol The symbol to use for the lookup
     * @param isLoggedIn Whether a user is logged in
     * @return The stock table or a error dialog as an HTML string
     */
    public String getStockTable(String companySymbol, boolean isLoggedIn) {
        // Get Stock object from the server
        Stock stock;

        try {
            stock = getPort().getStockBySymbol(companySymbol);
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        // Check stock is not null
        if (stock == null) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, the stock could not be found - check back later, or please try again.</div>";
        } else {
            List<Stock> theStock = new ArrayList<>();
            theStock.add(stock);

            return CommonUtils.getInstance().getStockTableAsHTML(theStock, false, false, isLoggedIn);
        }
    }

    /**
     * Retrieve user stocks from the Web Service and return a HTML table representation, or info dialog if there are no UserStocks to display
     *
     * @param guid The GUID of the users whose stocks to display
     * @return The user stocks table or a info dialog as an HTML string
     */
    public String getUserStocksTable(String guid) {
        // Get list of UserStock objects from the server
        List<UserStock> userStocks;

        try {
            userStocks = getPort().getUserStocks(guid);
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        // Check there are stocks actually some stocks owned by the user
        if (!(userStocks.size() > 0)) {
            return "<div class='bg-info p-2 mb-3'>You do not own any stocks. Purchase some from the Stocks page first!</div>";
        } else {
            return CommonUtils.getInstance().getUserStockTableAsHTML(userStocks);
        }
    }

    /**
     * Handle when a search is submitted, attempt to retrieve search results from the Web Service (non management mode)
     *
     * @param stockName The stock name to search for (contains)
     * @param stockSymbol The stock symbol to search for (contains)
     * @param stockCurrency The stock currency to search for (equals)
     * @param sharePriceFilter The share price filter (<=, =, >=)
     * @param sharePriceStr The share price as a string
     * @param sortBy The column in which the results should be ordered by
     * @param order Whether to order the sortBy column ascending or descending
     * @param isLoggedIn Whether a user is logged in
     * @return The stocks table or a info dialog as an HTML string
     */
    public String handleSearch(String stockName, String stockSymbol, String stockCurrency, String sharePriceFilter, String sharePriceStr, String sortBy, String order, boolean isLoggedIn) {
        return handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePriceStr, sortBy, order, false, isLoggedIn);
    }

    /**
     * Handle when a search is submitted, attempt to retrieve search results from the Web Service.
     *
     * @param stockName The stock name to search for (contains)
     * @param stockSymbol The stock symbol to search for (contains)
     * @param stockCurrency The stock currency to search for (equals)
     * @param sharePriceFilter The share price filter (<=, =, >=)
     * @param sharePriceStr The share price as a string
     * @param sortBy The column in which the results should be ordered by
     * @param order Whether to order the sortBy column ascending or descending
     * @param managementMode Whether to render the table in management mode
     * @param isLoggedIn Whether a user is logged in
     * @return The stocks table or a info dialog as an HTML string
     */
    public String handleSearch(String stockName, String stockSymbol, String stockCurrency, String sharePriceFilter, String sharePriceStr, String sortBy, String order, boolean managementMode, boolean isLoggedIn) {
        Double sharePrice = -1D;

        try {
            sharePrice = Double.parseDouble(sharePriceStr);
        } catch (NumberFormatException e) {
            if (sharePriceStr.length() > 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-numeric value was entered - please try again.</div>";
            }
        }

        List<Stock> filteredStocks;

        try {
            filteredStocks = getPort().searchShares(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order);
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        // Check there are stocks actually some stocks
        if (!(filteredStocks.size() > 0)) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, no stocks met your criteria - please try search again.</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(filteredStocks, true, managementMode, isLoggedIn);
        }
    }

    /**
     * Handle when a purchase order is actioned, attempt to execute the purchase on the Web Service.
     *
     * @param request The request object from the call site page
     * @param symbol The stock symbol which the user is purchasing
     * @param quantityStr The quantity that the user is purchasing as a String
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handlePurchase(HttpServletRequest request, String symbol, String quantityStr) {
        UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);

        if (userSessionModel == null) {
            return "<div class='bg-danger p-2 mb-3'>You need to be logged in to purchase shares. Please login.</div>";
        }

        try {
            if (symbol == null || quantityStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double quantity = Double.parseDouble(quantityStr);

            if (quantity <= 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot purchase 0 or less shares - please try again.</div>";
            } else {
                Boolean purchaseSuccess;

                try {
                    purchaseSuccess = getPort().purchaseShare(userSessionModel.getGuid(), symbol, quantity);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (purchaseSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully purchased " + quantity + " shares.</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your purchase has failed. Please try again.</div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-numeric value was entered - please try again.</div>";
        }
    }

    /**
     * Handle when sell order is actioned, attempt to execute the sale on the Web Service.
     *
     * @param request The request object from the call site page
     * @param symbol The stock symbol which the user is selling
     * @param quantityStr The quantity that the user is selling as a String
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handleSale(HttpServletRequest request, String symbol, String quantityStr) {
        UserSessionModel userSessionModel = Users.getInstance().getUserSessionDetails(request);

        if (userSessionModel == null) {
            return "<div class='bg-danger p-2 mb-3'>You need to be logged in to sell shares. Please login.</div>";
        }

        try {
            if (symbol == null || quantityStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double quantity = Double.parseDouble(quantityStr);

            if (quantity <= 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot sell 0 or less shares - please try again.</div>";
            } else {
                Boolean saleSuccess;

                try {
                    saleSuccess = getPort().sellShare(userSessionModel.getGuid(), symbol, quantity);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (saleSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully sold " + quantity + " shares.</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your sale has failed. Please try again.</div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-numeric value was entered - please try again.</div>";
        }
    }

    /**
     * Handle when a stock is added to the system, attempt to execute the add operation on the Web Service.
     *
     * @param stockName The company name of the new stock
     * @param stockSymbol The symbol for the new stock
     * @param availableSharesStr The amount of available shares for the new stock
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handleAdd(String stockName, String stockSymbol, String availableSharesStr) {
        try {
            if (stockName == null || stockSymbol == null || availableSharesStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double availableShares = Double.parseDouble(availableSharesStr);

            if (availableShares < 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot have less than 0 shares - please try again.</div>";
            } else {
                Boolean addSuccess;

                try {
                    addSuccess = getPort().addShare(stockName, stockSymbol, availableShares);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (addSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully added " + stockSymbol + " as a share.</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your addition has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-integer value was entered - please try again.</div>";
        }
    }

    /**
     * Handle when a stock is removed from the system, attempt to execute the remove operation on the Web Service.
     *
     * @param stockSymbol The symbol for the stock to be removed
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handleRemove(String stockSymbol) {
        if (stockSymbol == null) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
        }

        Boolean removeSuccess;

        try {
            removeSuccess = getPort().deleteShare(stockSymbol);
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        if (removeSuccess) {
            return "<div class='bg-success p-2 mb-3'>You have successfully removed the stock with the symbol '" + stockSymbol + "'.</div>";
        } else {
            return "<div class='bg-danger p-2 mb-3'>Your removal has failed. Please try again. </div>";
        }
    }

    /**
     * Handle when a stock is edited, attempt to execute the modify operation on the Web Service.
     *
     * @param stockName The updated stockName
     * @param currentStockSymbol The current stock symbol
     * @param newStockSymbol The updated stock symbol
     * @param availableSharesStr The updated available share amount
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handleEdit(String stockName, String currentStockSymbol, String newStockSymbol, String availableSharesStr) {
        try {
            if (stockName == null || currentStockSymbol == null || newStockSymbol == null || availableSharesStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double availableShares = Double.parseDouble(availableSharesStr);

            if (availableShares < 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot have less than 0 shares - please try again.</div>";
            } else {
                Boolean editSuccess;

                try {
                    editSuccess = getPort().modifyShare(stockName, currentStockSymbol, newStockSymbol, availableShares);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (editSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully modified " + currentStockSymbol + ".</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your modification has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-integer value was entered - please try again.</div>";
        }
    }

    /**
     * Attempt to form a connection to the Share Brokering SOAP service
     *
     * @return A port connection to the web service, or null if failure
     */
    private ShareBrokering getPort() {
        try {
            // Create reference to the web service
            ShareBrokering_Service service = new ShareBrokering_Service();
            ShareBrokering port = service.getShareBrokeringPort();

            return port;
        } catch (WebServiceException e) {
            System.err.println("[JSP Client] WebServiceException connecting to SharesBrokering SOAP service. ShareBrokering port will throw NPE. " + e.getMessage());
        }

        return null;
    }
}
