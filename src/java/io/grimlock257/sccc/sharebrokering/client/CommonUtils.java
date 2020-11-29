package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.ws.Stock;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import javax.xml.datatype.XMLGregorianCalendar;

/**
 * CommonUtils
 *
 * Contains common utility functions used by the client
 *
 * @author Adam Watson
 */
public class CommonUtils {

    private static CommonUtils instance = null;

    /**
     * Private constructor to prevent instantiation
     */
    private CommonUtils() {
    }

    /**
     * Get the instance of the CommonUtils singleton
     *
     * @return The instance of the CommonUtils
     */
    public static CommonUtils getInstance() {

        if (instance == null) {
            instance = new CommonUtils();
        }

        return instance;
    }

    /**
     * Generate a String representing an HTML table of stocks
     *
     * @param stocks The stocks used to populate the table with
     * @param clickableRows Whether to have clickable rows
     * @return The String representing the HTML table
     */
    public String getStockTableAsHTML(List<Stock> stocks, boolean clickableRows) {
        StringBuilder builder = new StringBuilder();

        // Create table and set up header row
        builder.append("<table class='table table-striped table-dark " + (clickableRows ? "table-hover" : "") + "'>");
        builder.append("<thead>");
        builder.append("<tr>");
        builder.append("<th></th>");
        builder.append("<th>Company Name</th>");
        builder.append("<th>Stock Symbol</th>");
        builder.append("<th>Available Shares</th>");
        builder.append("<th>Share Currency</th>");
        builder.append("<th>Share Price</th>");
        builder.append("<th>Price Last Updated</th>");
        builder.append("<th></th>");
        builder.append("</tr>");
        builder.append("</thead>");
        builder.append("<tbody>");

        // Iterate over Stock objects, adding a table row for each
        for (Stock stock : stocks) {
            builder.append("<tr " + (clickableRows ? "class='js-clickable-row c-clickable-row' data-href='company-profile.jsp' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() : "") + "'>");
            builder.append("<td class='align-middle js-stock-img-cell c-stock-img-cell' data-stock-name='" + stock.getStockName() + "'></td>");
            builder.append("<th class='align-middle'>" + stock.getStockName() + "</th>");
            builder.append("<td class='align-middle'>" + stock.getStockSymbol() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getAvailableShares() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getPrice().getCurrency() + "</td>");
            builder.append("<td class='align-middle'>" + stock.getPrice().getPrice() + "</td>");
            builder.append("<td class='align-middle'>" + CommonUtils.formatDateTime(stock.getPrice().getUpdated()) + "</td>");
            builder.append("<td class='align-middle'>");
            builder.append("<button type='button' class='btn btn-warning mr-2 js-sell-btn' data-toggle='modal' data-target='#sales-modal' data-action='Sell' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "'>Sell</button>");
            builder.append("<button type='button' class='btn btn-success js-buy-btn'" + (stock.getAvailableShares() == 0F ? " disabled" : "") + " data-toggle='modal' data-target='#sales-modal' data-action='Buy' data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "' data-available-shares='" + stock.getAvailableShares() + "'>Buy</button>");
            builder.append("</td>");
            builder.append("</tr>");
        }

        // Close up the table
        builder.append("</tbody>");
        builder.append("</table>");

        // Return contents as a String
        return builder.toString();
    }

    /**
     * Format the provided XMLGregorianCalendar object into a more readable format
     *
     * @param dateTime The XMLGregorianCalendar object to format
     * @return The formatted date time as a String
     */
    public static String formatDateTime(XMLGregorianCalendar dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy HH:mm:ss");
        ZonedDateTime zonedTime = dateTime.toGregorianCalendar().toZonedDateTime();

        return formatter.format(zonedTime);
    }
}
