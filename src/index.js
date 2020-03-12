import "./whois-mono/stylesheet.css";
import { Elm } from "./Main.elm";

(function(i, s, o, g, r, a, m) {
  i["GoogleAnalyticsObject"] = r;
  (i[r] =
    i[r] ||
    function() {
      (i[r].q = i[r].q || []).push(arguments);
    }),
    (i[r].l = 1 * new Date());
  (a = s.createElement(o)), (m = s.getElementsByTagName(o)[0]);
  a.async = 1;
  a.src = g;
  m.parentNode.insertBefore(a, m);
})(
  window,
  document,
  "script",
  "https://www.google-analytics.com/analytics.js",
  "ga"
);

ga("create", "UA-147193488-1", "auto");
ga("send", "pageview");

const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
  navigator.userAgent
);

const app = Elm.Main.init({
  node: document.querySelector("main"),
  flags: {
    windowSize: {
      width: window.innerWidth,
      height: window.innerHeight
    },
    isMobile
  }
});

app.ports.download.subscribe(() => {
  ga("send", {
    hitType: "event",
    eventCategory: "Download"
  });
});
