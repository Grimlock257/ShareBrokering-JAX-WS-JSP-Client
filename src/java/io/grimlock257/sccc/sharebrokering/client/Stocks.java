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
     * Retrieve stocks from the Web Service and return a HTML table representation, or info dialog if there are no Stocks to display
     *
     * @return The stocks table or a info dialog as an HTML string
     */
    public String getStocksTable() {
        // Get list of Stock objects from the server
        List<Stock> stocks = port.getAllStocks();

        // Check there are stocks actually some stocks
        if (!(stocks.size() > 0)) {
            return "<div class='bg-info p-2'>Sorry, there are no stocks listed at the moment - check back later</div>";
        } else {
            return CommonUtils.getInstance().getStockTableAsHTML(stocks, true);
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

            return CommonUtils.getInstance().getStockTableAsHTML(theStock, false);
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
}
