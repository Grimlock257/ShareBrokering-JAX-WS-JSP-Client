/*
 * Created on : 10-Nov-2020, 13:38:54
 * Author     : Adam Watson
 */

$(document).ready(function () {

    /**
     * When the modal show event has been fired, set up the modal text and
     * max value for the text input field
     */
    $('#sales-modal').on('show.bs.modal', function (event) {
        var salesModal = $(this);
        var triggerButton = $(event.relatedTarget);
        var parentRow = triggerButton.closest("tr");

        var action = triggerButton.data('action');
        var availableShares = triggerButton.data('available-shares');

        var stockName = parentRow.data('stock-name');
        var stockSymbol = parentRow.data('stock-symbol');

        salesModal.find('#js-modal-title').text(action + " " + stockName + " shares");
        salesModal.find('#js-action-text').text(action + " quantity");
        salesModal.find('#js-action-btn').val(action);
        salesModal.find('#js-modal-form').attr("action", "?" + action.toLowerCase() + "&stockName=" + stockName + "&stockSymbol=" + stockSymbol);
        salesModal.find('#js-form-symbol').val(stockSymbol);

        if (availableShares !== null && availableShares !== undefined) {
            salesModal.find('#js-quantitiy-field').prop("max", availableShares);
        }

        if ((availableShares === null || availableShares === undefined) && action.toLowerCase() === "sell") {
            salesModal.find('#js-quantitiy-field').removeAttr("max");
        }
    });

    /**
     * When the modal has been fully hidden, reset the values
     */
    $('#sales-modal').on('hidden.bs.modal', function () {
        var salesModal = $(this);

        salesModal.find('#js-modal-title').text("Share transaction");
        salesModal.find('#js-action-text').text("Quantity");
        salesModal.find('#js-quantitiy-field').prop("max", 0);
        salesModal.find('#js-modal-form').attr("action", "");
        salesModal.find('#js-form-symbol').val("");
    });
});