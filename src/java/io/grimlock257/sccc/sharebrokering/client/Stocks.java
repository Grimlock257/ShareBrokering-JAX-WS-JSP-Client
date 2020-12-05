package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.ws.ShareBrokering;
import io.grimlock257.sccc.ws.ShareBrokering_Service;
import io.grimlock257.sccc.ws.Stock;
import java.util.ArrayList;
import java.util.List;

/**
 * Stocks
 *
 * Contains methods regarding stocks such as retrieving table or stocks, or handling or purchasing and selling
 *
 * @author Adam Watson
 */
public class Stocks {

    private static Stocks instance = null;

    ShareBrokering_Service service;
    ShareBrokering port;

    /**
     * Private constructor to prevent instantiation
     */
    private Stocks() {
        // Create reference to the web service
        service = new ShareBrokering_Service();
        port = service.getShareBrokeringPort();
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
     * @return The stocks table or a info dialog as an HTML string
     */
    public String getStocksTable() {
        return getStocksTable(false);
    }

    /**
     * Retrieve stocks from the Web Service and return a HTML table representation, or info dialog if there are no Stocks to display
     *
     * @param managementMode Whether the table should be for the management mode
     * @return The stocks table or a info dialog as an HTML string
     */
    public String getStocksTable(boolean managementMode) {
        // Get list of Stock objects from the server
        List<Stock> stocks = port.getAllStocks();

        // Check there are stocks actually some stocks
        if (!(stocks.size() > 0)) {
            return "<div class='bg-info p-2'>Sorry, there are no stocks listed at the moment - check back later</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(stocks, true, managementMode);
        }
    }

    /**
     * Retrieve stock from the Web Service and return a HTML table representation, or error dialog if no stock was found
     *
     * @param companySymbol The symbol to use for the lookup
     * @return The stock table or a error dialog as an HTML string
     */
    public String getStockTable(String companySymbol) {
        // Get Stock object from the server
        Stock stock = port.getStockBySymbol(companySymbol);

        // Check stock is not null
        if (stock == null) {
            return "<div class='bg-danger p-2'>Sorry, the stock could not be found - check back later, or please try again.</div>";
        } else {
            List<Stock> theStock = new ArrayList<>();
            theStock.add(stock);

            return CommonUtils.getInstance().getStockTableAsHTML(theStock, false, false);
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
     * @return The stocks table or a info dialog as an HTML string
     */
    public String handleSearch(String stockName, String stockSymbol, String stockCurrency, String sharePriceFilter, String sharePriceStr, String sortBy, String order) {
        return handleSearch(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePriceStr, sortBy, order, false);
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
     * @return The stocks table or a info dialog as an HTML string
     */
    public String handleSearch(String stockName, String stockSymbol, String stockCurrency, String sharePriceFilter, String sharePriceStr, String sortBy, String order, boolean managementMode) {
        Double sharePrice = -1D;

        try {
            sharePrice = Double.parseDouble(sharePriceStr);
        } catch (NumberFormatException e) {
            if (sharePriceStr.length() > 0) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears a non-integer quantity was entered - please try again.</div>";
            }
        }

        List<Stock> filteredStocks = port.searchShares(stockName, stockSymbol, stockCurrency, sharePriceFilter, sharePrice, sortBy, order);

        // Check there are stocks actually some stocks
        if (!(filteredStocks.size() > 0)) {
            return "<div class='bg-danger p-2'>Sorry, no stocks met your criteria - please try search again.</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(filteredStocks, true, managementMode);
        }
    }

    /**
     * Handle when a purchase order is actioned, attempt to execute the purchase on the Web Service.
     *
     * @param symbol The stock symbol which the user is purchasing
     * @param quantityStr The quantity that the user is purchasing as a String
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handlePurchase(String symbol, String quantityStr) {
        try {
            Double quantity = Double.parseDouble(quantityStr);

            if (symbol == null || quantity == null) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            } else if (quantity <= 0) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. You cannot purchase 0 or less shares - please try again.</div>";
            } else {
                Boolean purchaseSuccess = port.purchaseShare(symbol, quantity);

                if (purchaseSuccess) {
                    return "<div class='bg-success p-2'>You have successfully purchased " + quantity + " shares.</div>";
                } else {
                    return "<div class='bg-danger p-2'>Your purchase has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears a non-integer quantity was entered - please try again.</div>";
        }
    }

    /**
     * Handle when sell order is actioned, attempt to execute the sale on the Web Service.
     *
     * @param symbol The stock symbol which the user is selling
     * @param quantityStr The quantity that the user is selling as a String
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String handleSale(String symbol, String quantityStr) {
        try {
            Double quantity = Double.parseDouble(quantityStr);

            if (symbol == null || quantity == null) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            } else if (quantity <= 0) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. You cannot sell 0 or less shares - please try again.</div>";
            } else {
                Boolean saleSuccess = port.sellShare(symbol, quantity);

                if (saleSuccess) {
                    return "<div class='bg-success p-2'>You have successfully sold " + quantity + " shares.</div>";
                } else {
                    return "<div class='bg-danger p-2'>Your sale has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears a non-integer quantity was entered - please try again.</div>";
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
                return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double availableShares = Double.parseDouble(availableSharesStr);

            if (availableShares < 0) {
                return "<div class='bg-danger p-2'>Sorry, something went wrong. You cannot have less than 0 shares - please try again.</div>";
            } else {
                Boolean addSuccess = port.addShare(stockName, stockSymbol, availableShares);

                if (addSuccess) {
                    return "<div class='bg-success p-2'>You have successfully added " + stockSymbol + " as a share.</div>";
                } else {
                    return "<div class='bg-danger p-2'>Your addition has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2'>Sorry, something went wrong. It appears a non-integer value was entered - please try again.</div>";
        }
    }
}
