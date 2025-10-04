FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
LABEL Author="Akshat"

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone -b master https://github.com/docker/awesome-compose.git

WORKDIR /app/awesome-compose/nginx-aspnet-mysql/backend/

RUN dotnet build aspnetapp.csproj -c Release && dotnet publish aspnetapp.csproj -c Release -o out

FROM build

WORKDIR /app
COPY --from=build /app/awesome-compose/nginx-aspnet-mysql/backend .

WORKDIR /app/out

ENV ASPNETCORE_URLS=http://+:5000

CMD ["dotnet","aspnetapp.dll"]