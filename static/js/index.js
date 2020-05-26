// shows the landing resume button
window.onload=function() { //executes when the page finishes loading 
    setTimeout(showBtn, 8000);
};
function showBtn() {
    document.getElementById("resume-btn").className="show";
}


// Typer
var app = document.getElementById('type-text');
var typewriter = new Typewriter(app, {
});
typewriter
  .typeString('<span class="typer-h1">BRENDEN')
  .deleteChars(2)
  .typeString('AN BECK</span><br>')
  .pauseFor(500)
  .typeString('<span class="typer-h2">I make stuff look good.</span>')
  .start();