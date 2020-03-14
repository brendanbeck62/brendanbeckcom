FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm i -g nodemon && npm i url && npm i ejs && npm i express && npm i express-favicon

# Bundle app source
COPY . .

EXPOSE 8080

CMD [ "nodemon", "server.js" ]

