FROM node:lts AS dev
LABEL Author="Akshat Verma"

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /src/awesome-compose/react-nginx
RUN npm ci

CMD ["npm","start"]


FROM dev as build

RUN npm run build



FROM nginx:alpine
COPY --from=build /src/awesome-compose/react-nginx/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

COPY --from=build /src/awesome-compose/react-nginx/build .

EXPOSE 80