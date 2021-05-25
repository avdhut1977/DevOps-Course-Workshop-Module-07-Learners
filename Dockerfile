 FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

WORKDIR /App

# Copy csproj and restore as distinct layers
#COPY *.csproj ./

# Copy everything else and build
COPY . ./


RUN apt-get update && apt-get upgrade -y
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN dotnet build
WORKDIR /App/DotnetTemplate.Web

RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /App/DotnetTemplate.Web
COPY --from=build-env /App/DotnetTemplate.Web/out .
ENTRYPOINT ["dotnet", "DotnetTemplate.Web.dll"]