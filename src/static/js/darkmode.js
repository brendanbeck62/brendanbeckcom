// https://dev.to/codedgar/how-to-create-a-dark-theme-system-in-5-minutes-or-less-with-vanilla-js-2922
let theme_toggler = document.querySelector('#theme_toggler');

theme_toggler.addEventListener('click', function () {
  document.body.classList.toggle('dark_mode');

  // animates the icons
  document.querySelector(".sun-logo").classList.toggle("animate-sun");
  document.querySelector(".moon-logo").classList.toggle("animate-moon");

  if (document.body.classList.contains('dark_mode')) {
    localStorage.setItem('website_theme', 'dark_mode');
  } else {
    localStorage.setItem('website_theme', 'default');
  }
});

function retrieve_theme() {
  var theme = localStorage.getItem('website_theme');
  if (theme != null) {
    document.body.classList.remove('default', 'dark_mode'); document.body.classList.add(theme);
  }
}


window.addEventListener("storage", function () {
  retrieve_theme();
}, false);
