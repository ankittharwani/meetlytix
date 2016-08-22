FROM node:argon

# Create app directory
RUN mkdir -p /apps/meetlytix/middleware/api
WORKDIR /apps/meetlytix/middleware/api

# Install app dependencies
COPY package.json /apps/meetlytix/middleware/api/
RUN npm install

# Bundle app source
COPY . /apps/meetlytix/middleware/api/

EXPOSE 8080

CMD [ "npm", "start" ]
