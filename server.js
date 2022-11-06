'use strict';

require('dotenv').config({path: __dirname + `/.env.${process.env.NODE_ENV}`});
const express = require('express');
const url = require('url');
const favicon = require('express-favicon');
const fs = require('fs');

// Constants
var HOST = process.env.HOST || '127.0.0.1';
var PORT = process.env.PORT || 8080;

// App test
const app = express();

app.use(express.static(__dirname + '/static/'));
app.use(favicon(__dirname + '/static/img/favicon.ico'));
app.set('view engine', 'ejs');

// Download for the VSCode synthwave theme...
// TODO remove this when full page is made for it
app.get('/synthwave-theme', (req, res) => {
    const file = `${__dirname}/static/downloads/Synthwave-Theme.vsix`;
    res.download(file); // Set disposition and send it.
});

app.get(/^(?!\/api\/)/, (req, res) => {
    let purl = url.parse(req.url, true);
    let pathname = 'pages' + purl.pathname;

    if ((pathname)[pathname.length - 1] === '/') {
        pathname += 'index';
    }

    // add the path + extension, so that the fs.access can find it
    var pathPrepend = "./views/";
    var extenstion = ".ejs"
    var fullpath = pathPrepend.concat(pathname).concat(extenstion);

    // check if the file exists in the pages directory
    fs.access(fullpath, fs.F_OK, (err) => {
        // if it does not exist, display the 404 page
        if (err) {
            res.render("pages/404", purl.query);
            return
        }

        // otherwise display the page
        res.render(pathname, purl.query);
      })

});

app.listen(PORT, HOST);
console.log(`brendanbeck.com running on http://${HOST}:${PORT}`);
