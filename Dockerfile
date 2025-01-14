FROM node:17.4-alpine3.15

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install --quiet

COPY index.js .

USER node
ENTRYPOINT [ "npm" ]
CMD [ "run", "prod" ]