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
     * @param managementMode Whether the table is to be generated for the management page
     * @return The String representing the HTML table
     */
    public String getStockTableAsHTML(List<Stock> stocks, boolean clickableRows, boolean managementMode) {
        StringBuilder builder = new StringBuilder();

        // Create table and set up header row
        builder.append("<table class='table table-striped table-dark table-bordered " + (clickableRows ? "table-hover" : "") + " js-stocks-table'>");
        builder.append("<thead class='text-center'>");
        builder.append("<tr>");
        builder.append("<th class='border-right-0' rowspan='2'></th>");
        builder.append("<th class='border-left-0 text-left' rowspan='2'>Company</th>");
        builder.append("<th rowspan='2'>Symbol</th>");
        builder.append("<th rowspan='2'>Available</th>");
        builder.append("<th colspan='2'>Listed</th>");
        builder.append("<th colspan='2'>Preferred</th>");
        builder.append("<th rowspan='2'>Price Last Updated</th>");
        builder.append("<th rowspan='2'></th>");
        builder.append("</tr>");
        builder.append("<tr>");
        builder.append("<th>Price</th>");
        builder.append("<th>Currency</th>");
        builder.append("<th>Price</th>");
        builder.append("<th>Currency</th>");
        builder.append("</tr>");
        builder.append("</thead>");
        builder.append("<tbody>");

        // Iterate over Stock objects, adding a table row for each
        for (Stock stock : stocks) {
            builder.append("<tr " + (clickableRows ? "class='js-clickable-row c-clickable-row' data-href='company-profile.jsp'" : "") + " data-stock-name='" + stock.getStockName() + "' data-stock-symbol='" + stock.getStockSymbol() + "'>");
            builder.append("<td class='border-right-0 align-middle js-stock-img-cell c-stock-img-cell'></td>");
            builder.append("<th class='border-left-0 align-middle'>" + stock.getStockName() + "</th>");
            builder.append("<td class='align-middle c-shrink-cell'>" + stock.getStockSymbol() + "</td>");
            builder.append("<td class='align-middle c-shrink-cell text-right'>" + String.format("%.2f", stock.getAvailableShares()) + "</td>");
            builder.append("<td class='align-middle c-shrink-cell text-right js-currency-listed-price-cell'>" + String.format("%.2f", stock.getPrice().getPrice()) + "</td>");
            builder.append("<td class='align-middle c-shrink-cell text-left js-currency-listed-currency-cell'>" + stock.getPrice().getCurrency() + "</td>");
            builder.append("<td class='align-middle c-shrink-cell text-right js-currency-preference-price-cell'></td>");
            builder.append("<td class='align-middle c-shrink-cell text-left js-currency-preference-currency-cell'></td>");
            builder.append("<td class='align-middle text-center'>" + CommonUtils.formatDateTime(stock.getPrice().getUpdated()) + "</td>");
            builder.append("<td class='align-middle text-center'>");

            if (managementMode) {
                builder.append("<a href='stock-management-edit.jsp?stockSymbol=" + stock.getStockSymbol() + "&stockName=" + stock.getStockName() + "&availableShares=" + stock.getAvailableShares() + "' class='btn btn-warning mr-2 js-edit-btn'>Edit</a>");
                builder.append("<button type='button' class='btn btn-danger js-remove-btn' data-toggle='modal' data-target='#remove-modal' data-action='Remove' data-available-shares='" + stock.getAvailableShares() + "'>Remove</button>");

            } else {
                builder.append("<button type='button' class='btn btn-warning mr-2 js-sell-btn' data-toggle='modal' data-target='#sales-modal' data-action='Sell'>Sell</button>");
                builder.append("<button type='button' class='btn btn-success js-buy-btn'" + (stock.getAvailableShares() == 0F ? " disabled" : "") + " data-toggle='modal' data-target='#sales-modal' data-action='Buy' data-available-shares='" + stock.getAvailableShares() + "'>Buy</button>");
            }
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
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        ZonedDateTime zonedTime = dateTime.toGregorianCalendar().toZonedDateTime();

        return formatter.format(zonedTime);
    }
}
