/* 
 * Created on : 11-Nov-2020, 00:18:49
 * Author     : Adam Watson
 */

$(document).ready(function () {

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
});
