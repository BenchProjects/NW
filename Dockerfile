ARG CACHEBUST=103
#1Take the following BASE image either from local copy or repository (hub.docker.com etc) and use as base image
FROM microsoft/aspnetcore-build:2.0 AS build

#2 Set container working directory to app
WORKDIR /app

#3 moves sln to app folder
COPY *.sln .  

#4 moves dotnetapp csproj to root/HelloWorld
COPY HelloWorld/HelloWorld.csproj ./HelloWorld/ 

#5 moves utils csproj to root/utils
COPY HelloWorldClassLibrary/HelloWorldClassLibrary.csproj ./HelloWorldClassLibrary/ 

#6 Moves test csproj to root/tests
COPY HelloWorldTests/HelloWorldTests.Tests/HelloWorldTests.Tests.csproj ./Tests/ 

#7 Get the dependencies for all projects in container
RUN dotnet restore ./HelloWorldClassLibrary/HelloWorldClassLibrary.csproj
RUN dotnet restore ./HelloWorld/HelloWorld.csproj
RUN dotnet restore ./Tests/HelloWorldTests.Tests.csproj

#8 copy all contents of the HelloWorld file (- dockerignore files) to HelloWorld folder
COPY HelloWorld/. ./HelloWorld/ 

#9 copy all util files (- dockerignore files) to utils folder
COPY HelloWorldClassLibrary/. ./HelloWorldClassLibrary/

#10 copy all test files (- dockerignore files) to test folder
COPY HelloWorldTests/HelloWorldTests.Tests/. ./Tests/

#BUILD THE APP
RUN dotnet build ./HelloWorldClassLibrary/HelloWorldClassLibrary.csproj -c Release
RUN dotnet build ./HelloWorld/HelloWorld.csproj -c Release
RUN dotnet build ./Tests/HelloWorldTests.Tests.csproj -c Release

FROM build AS testrunner
WORKDIR /app/tests
ENTRYPOINT ["dotnet", "test","--logger:trx"]

FROM build AS test
WORKDIR /app/Tests
RUN dotnet test

FROM test AS publish
WORKDIR /app/HelloWorld
RUN dotnet publish -c Release -o out

FROM microsoft/aspnetcore:2.0 AS runtime
WORKDIR /app
COPY --from=publish /app/HelloWorld/out ./
ENTRYPOINT ["dotnet", "HelloWorld.dll"]
