var app = document.getElementById('type-text');

    var typewriter = new Typewriter(app, {
        loop: true
    });

    typewriter.typeString('Hello World!')
        .pauseFor(2500)
        .deleteAll()
        .typeString('Strings can be removed')
        .pauseFor(2500)
        .deleteChars(7)
        .typeString('altered!')
        .start();