# brendanbeck.com

## Main server file
server.js

## Routing
All api requests go through /api/

All front end and static requests go through /          (root)

Meaning if you go to localhost:8080/software it will take you to the software page
with html, css, javascript etc.. but if you go to localhost:8080/api/software
it will not grab html.. the route assumes you are trying to access an api functionality

## HTML Pages
All html pages are in the /views/pages/ directory. These are ejs files which
call partials in ejs to include html in other pages.

## Static Files (CSS, Javascript)
/static/ directory

When an html page links to a stylesheet or some script, express serves the Static
files in the /static/ directory within the same direcory it is called inside
of the /views/pages/ direcory.

For example:

/views/pages/software/index.ejs     has a stylesheet href="css/index.css"

Since express serves our static files for us it actually grabs the css from

/static/software/css/page.css

This makes it easy to use relative addresses in hrefs of html files, so long
as you continue this directory structure of placing static files in /static
directory and the html in the views/pages/ directory and the reusable html
in the /views/partials/ directory

## Development
While in development, I am using server.js in the root to test the end points. I plan on switching to a class structure, where the module can be required in and used as functions, rather than just as api end points.

### NPM
`server.js` is the main entry point
```
"scripts": {
    "dev": "NODE_ENV=dev node server.js",
    "start": "NODE_ENV=prod node server.js"
  },
```


### .env files
`NODE_ENV` is set in package.json, can also just be exported.

The `NODE_ENV` corresponds to the suffix of a corresponding `.env` file.

> :warning: **Localhost for docker containers**: 127.0.01 refers to the network interface of the host. When mapping a docker container locally, use `0.0.0.0`. https://stackoverflow.com/a/59182290



Sample:

.env.dev:
```
HOST=0.0.0.0
PORT=8080
```

.env.prod:
```
HOST=127.0.0.1
PORT=80
```

