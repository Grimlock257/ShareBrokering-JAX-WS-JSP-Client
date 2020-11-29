<%-- 
    Document   : sales-modal
    Created on : 29-Nov-2020, 10:32:21
    Author     : Adam Watson
--%>

<!-- Purchase/Sale modal -->
<div class="modal fade" id="sales-modal">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="js-modal-title">Share transaction</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form method="POST" id="js-modal-form">
                <div class="modal-body form-inline">
                    <div class="form-group">
                        <span id='js-action-text'>Quantity</span><input type="number" name="quantity" id="js-quantitiy-field" class="ml-4 form-control" required="required" step="any" min="0" max="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" name="symbol" id="js-form-symbol" value="" />
                    <input type="button" value="Cancel" class="btn btn-danger" data-dismiss="modal" />
                    <input type="submit" value="Purchase" class="btn btn-success" id="js-action-btn" />
                </div>
            </form>
        </div>
    </div>
</div>