

// Typer
// var app = document.getElementById('type-text');
// var typewriter = new Typewriter(app, {
// });
// typewriter
//   .typeString('BRENDEN')
//   .deleteChars(2)
//   .typeString('AN BECK<br>')
//   .pauseFor(500)
//   .typeString('<span class="typer-h2">I write code the right way.</span>')
//   .start();

$(window).on("load",function() {
    $(window).scroll(function() {
      var windowBottom = $(this).scrollTop() + $(this).innerHeight();
      $(".icon-scroll").each(function() {
        /* Check the location of each desired element */
        var objectBottom = $(this).offset().top + $(this).outerHeight();

        /* If the element is completely within bounds of the window, fade it in */
        if (objectBottom + 100 > windowBottom) { //object comes into view (scrolling down)
          if ($(this).css("opacity")==0) {$(this).fadeTo(500,1);}
        } else { //object goes out of view (scrolling up)
          if ($(this).css("opacity")==1) {$(this).fadeTo(500,0);}
        }
      });
    }).scroll(); //invoke scroll-handler on page-load
  });