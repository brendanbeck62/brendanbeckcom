var app = document.getElementById('type-text');

    var typewriter = new Typewriter(app, {
    });

    typewriter.pauseFor(2500)
        .typeString('BRENDAN BECK<br>')
        .pauseFor(2500)
        .typeString('I build things for the web.')
        .pauseFor(2500)
        .start();