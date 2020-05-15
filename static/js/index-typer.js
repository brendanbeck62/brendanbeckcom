var app = document.getElementById('type-text');

var typewriter = new Typewriter(app, {
});

typewriter
  .typeString('<span class="typer-h1">BRENDAN BECK</span><br>')
  .pauseFor(1000)
  .typeString('<span class="typer-h2">i make stuff look good</span>')
  .start();
