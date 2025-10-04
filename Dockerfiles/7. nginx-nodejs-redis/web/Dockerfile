FROM node:current-alpine3.21 AS build
LABEL Author="Akshat"

WORKDIR /app

RUN apk update && apk add --no-cache git
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /app/awesome-compose/nginx-nodejs-redis/web/
RUN npm ci


FROM build
WORKDIR /app

COPY --from=build /app/awesome-compose/nginx-nodejs-redis/web .

CMD ["npm","start"]
