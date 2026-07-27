window.addEventListener("load", function () {
  const iframe = document.createElement("iframe");

  iframe.src =
    "https://www.openstreetmap.org/export/embed.html?bbox=-78.9900%2C40.2700%2C-78.8500%2C40.3800&layer=mapnik&marker=40.3267%2C-78.9219";

  iframe.style.border = "0";
  iframe.style.width = "100%";
  iframe.style.height = "100%";

  window.flutter_inappwebview = iframe;
});
