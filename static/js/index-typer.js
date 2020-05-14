var app = document.getElementById('type-text');

var typewriter = new Typewriter(app, {
});

typewriter
  .typeString('<h1>BRENDAN BECK<br></h1>')
  .typeString('<h2>i make stuff look good</h2>')
  .pauseFor(1000)
  .start();
