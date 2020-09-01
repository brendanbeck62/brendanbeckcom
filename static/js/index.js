// shows the landing resume button
window.onload=function() { //executes when the page finishes loading
    setTimeout(showBtn, 8000);
};
function showBtn() {
    document.getElementById("resume-btn").className="show";
}

// Work experience and edu collapsibles
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("timeline-active");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
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
  .typeString('<span class="typer-h2">I write code the right way.</span>')
  .start();