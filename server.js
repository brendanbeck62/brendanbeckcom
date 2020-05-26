'use strict';

const express = require('express');
const url = require('url');
const favicon = require('express-favicon');

// Constants
const PORT = 80;
const HOST = '0.0.0.0';

// App test
const app = express();

app.use(express.static(__dirname + '/static/'));
app.use(favicon(__dirname + '/static/img/favicon.ico'));
app.set('view engine', 'ejs');


app.get(/^(?!\/api\/)/, (req, res) => {
    let purl = url.parse(req.url, true);
    let pathname = 'pages' + purl.pathname;

    if ((pathname)[pathname.length - 1] === '/') {
        pathname += 'index';
    }
    res.render(pathname, purl.query);
});

app.listen(PORT, HOST);
console.log(`Running it on http://${HOST}:${PORT}`);
