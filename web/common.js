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
            var currenciesForm = $(".js-currencies-form");

            if (response !== null && response !== undefined) {
                var currenciesFormSelect = currenciesForm.find("select");
                currenciesFormSelect.removeClass("d-none");

                var userCurrency = Cookies.get('userCurrency');

                Object.keys(response).forEach(function (key) {
                    currenciesFormSelect.append("<option value='" + key.toLowerCase() + "' " + ((userCurrency === key.toLowerCase()) ? "selected" : "") + ">" + key + " - " + response[key] + "</option>");
                });
            } else {
                currenciesForm.append("<div class='bg-danger p-2'>Failed to retrieve currencies. Please try again.</div>");
            }
        }
    });

    /**
     * Listen to currency form select change events to update the userCurrency cookie
     */
    $(".js-currencies-form select").change(function () {
        Cookies.set('userCurrency', $(this).val());
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
        var stockName = cell.data('stock-name');

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
});
