# brendanbeck.com

## Frontend
server.js

### Routing
All api requests go through `/api/`

All front end and static requests go through `/`

Meaning if you go to `localhost:8080/software`  it will take you to the software page
with html, css, javascript etc.. but if you go to `localhost:8080/api/software`
it will not grab html.. the route assumes you are trying to access an api functionality

### HTML Pages
All html pages are in the `/views/pages/` directory. These are ejs files which
call partials in ejs to include html in other pages.

### Static Files (CSS, Javascript)
/static/ directory

When an html page links to a stylesheet or some script, express serves the Static
files in the `/static/` directory within the same direcory it is called inside
of the `/views/pages/` direcory.

For example:

```/views/pages/software/index.ejs```
has a stylesheet `href="css/index.css"`

Since express serves our static files for us it actually grabs the css from
```
/static/software/css/page.css
```
This makes it easy to use relative addresses in hrefs of html files, so long
as you continue this directory structure of placing static files in `/static`
directory and the html in the `views/pages/` directory and the reusable html
in the `/views/partials/` directory

## Deployment
Deployment occurs in 2 stages:
- packer builds an AMI
- terraform deploys and EC2 using that AMI

### Packer build
Very simple packer setup for now, that copies the `src` directory onto the instance and configures pm2 to start the node app using systemd.

### Terraform Deployment
Deploys the AMI created by packer onto an EC2. See the TODOs in `main.tf` for future work needed.

## Dev Resources

### Frontend
- https://crypton.trading/
- https://jsfiddle.net/hzfxp2L9/
- https://github.com/tameemsafi/typewriterjs
- https://brittanychiang.com/

### Deployment
