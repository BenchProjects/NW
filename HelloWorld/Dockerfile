FROM microsoft/aspnetcore:2.0 AS base
RUN echo "$PWD"
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src

COPY HelloWorld.csproj HelloWorld/

RUN dotnet restore HelloWorld/HelloWorld.csproj
COPY . .
WORKDIR /src/HelloWorld
RUN dotnet build HelloWorld.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish HelloWorld.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
