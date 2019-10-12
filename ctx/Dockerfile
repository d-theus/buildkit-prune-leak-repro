FROM node:11-alpine

RUN mkdir /app
WORKDIR /app

RUN npm install -g webpack webpack-cli
ADD package.json /app
RUN yarn install 

ADD . /app
RUN yarn build

