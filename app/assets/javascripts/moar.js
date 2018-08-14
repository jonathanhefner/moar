document.addEventListener("ajax:success", function(event){
  var link = event.target;
  var containerSelector = link.getAttribute("data-paginates");
  if (containerSelector) {
    var response = event.detail[0];

    // insert response elements
    var container = document.querySelector(containerSelector);
    if (!container) {
      console.error("Invalid pagination target: " + containerSelector);
      return;
    }
    var responseContainer = response.querySelector(containerSelector);
    if (responseContainer) {
      while (responseContainer.hasChildNodes()) {
        container.appendChild(responseContainer.firstChild);
      }
    }

    // update browser URL
    var newUrl = link.href + "&" + link.getAttribute("data-accumulation-param") + "=1";
    history.replaceState(history.state, "", newUrl);

    // update pagination link
    var responseLink = response.querySelector("a[data-paginates]");
    if (responseLink) {
      link.parentNode.replaceChild(responseLink, link);
    } else {
      link.parentNode.removeChild(link);
    }
  }
});
