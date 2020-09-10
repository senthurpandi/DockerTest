FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim as base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1.402-buster AS build
WORKDIR /src
COPY ["myWebApp.csproj",""]
RUN dotnet restore "./myWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "myWebApp.csproj" -c Release -o /app/build

From build as publish
RUN dotnet publish "myWebApp.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet","myWebApp.dll"]
