/* 
 * Created on : 11-Nov-2020, 00:18:49
 * Author     : Adam Watson
 */

$(document).ready(function () {

    /**
     *  Asynchronously get currencies at page load and populate
     */
    $.ajax({
        type: "GET",
        url: "http://localhost:8080/CurrencyAPI/webresources/currencies",
        success: function (response) {
            if (response !== null && response !== undefined) {
                var userCurrency = Cookies.get('userCurrency');

                // Iterate over each currency dropdown on the page
                $(".js-currencies-form").each(function () {
                    var currencyForm = $(this);
                    var currenciesFormSelect = currencyForm.find("select");

                    currenciesFormSelect.removeClass("d-none");

                    // Determine whether the form is for currency prefernce
                    if (currencyForm.hasClass("js-currency-preference-form")) {
                        Object.keys(response).forEach(function (key) {
                            currenciesFormSelect.append("<option value='" + key + "' " + ((userCurrency === key) ? "selected" : "") + ">" + key + " - " + response[key] + "</option>");
                        });
                    } else {
                        // Get query parameters
                        const urlParams = new URLSearchParams(window.location.search);
                        const wasSearch = urlParams.has('search');
                        const stockCurrency = urlParams.get('stockCurrency');

                        Object.keys(response).forEach(function (key) {
                            currenciesFormSelect.append("<option value='" + key + "' " + ((wasSearch && stockCurrency === key) ? "selected" : "") + ">" + key + " - " + response[key] + "</option>");
                        });
                    }
                });
            } else {
                $("body > .container").prepend("<div class='bg-danger p-2'>Failed to retrieve currencies. Please try again.</div>");
            }
        }
    });

    /**
     * Look for a table with a class of js-stocks-table and iterate over the rows. Convert the base price to the prefernenc currency, or default to GBP
     */
    $.fn.convertCurrencies = function () {
        // Attempt to get userCurrenct from Cookie
        var userCurrency = Cookies.get('userCurrency');
        var theTable = $(".js-stocks-table");

        // If no cookie, default to GBP
        if (userCurrency === undefined) {
            userCurrency = "gbp";
        }

        theTable.find("tbody tr").each(function () {
            var theRow = $(this);
            var baseCurrency = theRow.find(".js-currency-listed-currency-cell").html();
            var value = theRow.find(".js-currency-listed-price-cell").html();

            // Set the currency cell value
            theRow.find(".js-currency-preference-currency-cell").html(userCurrency.toUpperCase());

            // Asynchronously convert the currency via the CurrencyAPI and update the table
            $.ajax({
                type: "GET",
                url: "http://localhost:8080/CurrencyAPI/webresources/convert",
                data: "baseCurrency=" + baseCurrency + "&targetCurrency=" + userCurrency + "&value=" + value,
                success: function (response) {
                    var preferredCurrencyPriceCell = theRow.find(".js-currency-preference-price-cell");

                    if (response !== null && response !== undefined && response.status === "success") {
                        preferredCurrencyPriceCell.html(response.value.toFixed(2));
                    } else {
                        preferredCurrencyPriceCell.html("<span class='text-warning font-weight-bold'>Error</span>");
                    }
                }
            });
        });
    };

    /**
     * On page load, convert currencies
     */
    $(".js-stocks-table").ready($.fn.convertCurrencies());

    /**
     * Listen to currency form select change events to update the userCurrency cookie
     */
    $(".js-currency-preference-form select").change(function () {
        Cookies.set('userCurrency', $(this).val());

        $.fn.convertCurrencies();
    });

    /**
     * When the show event has been fired, add the active class and to trigger
     * the CSS transition
     */
    $('.js-stocks-search-card').on('show.bs.collapse', function () {
        $('#stocks-search-btn-arrow').addClass('active');
    });


    /**
     * When the hide event has been fired, remove the active class and to trigger
     * the CSS transition
     */
    $('.js-stocks-search-card').on('hide.bs.collapse', function () {
        $('#stocks-search-btn-arrow').removeClass('active');
    });

    /**
     * For every stock image cell, make an asynchronous request to the logo API to search for the logo based on
     * company name
     */
    $('.js-stock-img-cell').each(function () {
        var cell = $(this);
        var parentRow = cell.closest("tr");
        var stockName = parentRow.data('stock-name');

        $.ajax({
            type: "GET",
            url: "http://localhost:8080/LogoAPI/webresources/logo",
            data: "name=" + stockName,
            success: function (response) {
                if (response.success === true) {
                    cell.append("<img src='" + response.logoUrl + "' alt='" + stockName + " logo' class='c-company-logo'/>");
                }
            }
        });
    });

    /**
     * When the search form reset button has been clicked, removed 'selected' attribute from all option elements
     */
    $("#js-stocks-search-reset").on("click", function () {
        $('.js-stocks-search-selectable option').each(function () {
            $(this).removeAttr("selected");
        });

        $('.js-stocks-search-text-clearable').each(function () {
            $(this).removeAttr("value");
        });
    });

    /**
     * When a clickable row (but not a button on the row) receives a click event, retrieve data attributes from the row regarding target desination, and navigate to the new page
     */
    $('.js-clickable-row').on("click", function () {
        var isButton = $(event.target).is('button');

        var rowDestination = $(this).data("href");
        var stockName = $(this).data("stock-name");
        var stockSymbol = $(this).data("stock-symbol");
        var url = rowDestination + "?stockName=" + stockName + "&stockSymbol=" + stockSymbol;

        if (!isButton) {
            window.location = url;
        }
    });
});
