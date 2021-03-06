﻿FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000
ENV ASPNETCORE_URLS=http://*:5000
ENV PGDB_CONNECTION="Host=localhost;Username=postgres;Password=postgrespassword;Database=skeleton"

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY . .
RUN dotnet restore "src\Application\Skeleton.Api\Skeleton.Api.csproj"
RUN dotnet build "src\Application\Skeleton.Api\Skeleton.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src\Application\Skeleton.Api\Skeleton.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Skeleton.Api.dll"]