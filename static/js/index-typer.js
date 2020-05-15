var app = document.getElementById('type-text');

var typewriter = new Typewriter(app, {
});

typewriter
  .typeString('<span class="typer-h1">BRENDEN')
  .deleteChars(2)
  .typeString('AN BECK</span><br>')
  .pauseFor(500)
  .typeString('<span class="typer-h2">i make stuff look good.</span>')
  .start();
