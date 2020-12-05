/*
 * Created on : 05-Dec-2020, 23:09:11
 * Author     : Adam Watson
 */

$(document).ready(function () {

    /**
     * When the modal show event has been fired, set up the modal text and
     * max value for the text input field
     */
    $('#remove-modal').on('show.bs.modal', function (event) {
        var removeModal = $(this);
        var triggerButton = $(event.relatedTarget);

        var stockName = triggerButton.data('stock-name');
        var stockSymbol = triggerButton.data('stock-symbol');

        removeModal.find('#js-modal-title').text("Remove stock: " + stockName);
        removeModal.find('#js-modal-form').attr("action", "?remove&stockSymbol=" + stockSymbol);
        removeModal.find('#js-form-symbol').val(stockSymbol);
    });

    /**
     * When the modal has been fully hidden, reset the values
     */
    $('#remove-modal').on('hidden.bs.modal', function () {
        var salesModal = $(this);

        salesModal.find('#js-modal-title').text("Remove stock");
        salesModal.find('#js-modal-form').attr("action", "");
        salesModal.find('#js-form-symbol').val("");
    });
});