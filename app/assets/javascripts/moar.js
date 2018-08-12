document.addEventListener("ajax:success", function(event){
  var link = event.target;
  var containerSelector = link.getAttribute("data-paginates");
  if (containerSelector) {
    var response = event.detail[0];

    // insert response elements
    var container = document.querySelector(containerSelector);
    var responseContainer = response.querySelector(containerSelector);
    if (responseContainer) {
      while (responseContainer.hasChildNodes()) {
        container.appendChild(responseContainer.firstChild);
      }
    }

    // update browser URL
    var newUrl = link.href + "&" + link.getAttribute("data-accumulation-param") + "=1";
    history.replaceState({}, "", newUrl);

    // update pagination link
    var responseLink = response.querySelector("a[data-paginates]");
    if (responseLink) {
      link.setAttribute("href", responseLink.getAttribute("href"));
      link.setAttribute("data-remote", responseLink.getAttribute("data-remote"));
    } else {
      link.parentNode.removeChild(link);
    }
  }
});
