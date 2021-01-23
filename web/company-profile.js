/*
 * Created on : 28-Nov-2020, 21:50:49
 * Author     : Adam Watson
 */

$(document).ready(function () {

    // Get query parameters
    const urlParams = new URLSearchParams(window.location.search);
    const stockName = urlParams.get('stockName');

    // Add stock name
    $(".js-company-name").append(stockName);

    // Asynchronously get news items at page load and populate
    $.ajax({
        type: "GET",
        url: "http://localhost:8080/NewsAPI/webresources/news",
        data: "name=" + stockName,
        success: function (response) {
            if (response.status === "ok") {
                if (response.totalResults > 0) {
                    response.articles.forEach(function (article) {
                        const articleDate = new Date(article.publishedAt).toLocaleString();
                        const newCard = `
                            <div class="col-md-3 d-flex align-items-stretch">
                                <div class="card text-white bg-dark mb-2">
                                    <img class="card-img-top" src="${article.urlToImage}">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title">${article.title}</h5>
                                        <p class="card-text c-article-description">${article.description}</p>
                                        <a href="${article.url}" title="Open article in new tab" target="_blank" class="btn btn-light mt-auto">Read more</a>
                                    </div>
                                    <div class="card-footer">
                                        <small class="text-muted"><span class="c-single-line">By ${article.author}</span></small>
                                        <small class="text-muted">Published ${articleDate}</small>
                                    </div>
                                </div>
                            </div>`;

                        $(".js-news-item-container").append(newCard);
                    });
                } else {
                    $(".js-news-item-container").append("<div class='bg-info p-2 w-100 mb-2 font-weight-bold'>No article results</div>");
                }
            } else {
                $(".js-news-item-container").append("<div class='bg-danger p-2 w-100 mb-2 font-weight-bold'>Failed to retrieve articles. Please try again.</div>");
            }
        },
        error: function () {
            $(".js-news-item-container").append("<div class='bg-danger p-2 w-100 mb-2 font-weight-bold'>Failed to retrieve articles. Please try again.</div>");
        }
    });
});