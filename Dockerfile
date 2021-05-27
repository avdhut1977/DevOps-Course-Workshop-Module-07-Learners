 FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

WORKDIR /app
COPY . ./

RUN apt-get update && apt-get upgrade -y
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN dotnet build
WORKDIR /app/DotnetTemplate.Web

RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app/DotnetTemplate.Web
COPY --from=build-env /app/DotnetTemplate.Web/out .
ENTRYPOINT ["dotnet", "DotnetTemplate.Web.dll"]