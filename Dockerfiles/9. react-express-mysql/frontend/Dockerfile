FROM node:lts AS build
LABEL Author="Akshat Verma"

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /src/awesome-compose/react-express-mysql/frontend
RUN npm ci

FROM build
WORKDIR /app

COPY --from=build /src/awesome-compose/react-express-mysql/frontend .

CMD ["npm","start"]