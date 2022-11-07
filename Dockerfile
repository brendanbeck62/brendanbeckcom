FROM node:18

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

# TODO: get webpack working. npm i is slow for dev
RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080

CMD [ "npm", "run", "dev"]


