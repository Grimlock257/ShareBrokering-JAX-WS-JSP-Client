<%-- 
    Document   : remove-modal
    Created on : 05-Dec-2020, 22:49:26
    Author     : Adam Watson
--%>

<!-- Remove modal -->
<div class="modal fade" id="remove-modal">
    <div class="modal-dialog">
        <div class="modal-content bg-dark text-white">
            <div class="modal-header">
                <h5 class="modal-title" id="js-modal-title">Remove stock</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <form method="POST" id="js-modal-form">
                <div class="modal-body">
                    <p>This is an irreversible action - make sure this is the stock you want to remove.
                </div>
                <div class="modal-footer">
                    <input type="hidden" name="symbol" id="js-form-symbol" value="" />
                    <input type="button" value="Cancel" class="btn btn-success" data-dismiss="modal" />
                    <input type="submit" value="Remove" class="btn btn-danger" id="js-action-btn" />
                </div>
            </form>
        </div>
    </div>
</div>