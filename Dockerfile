# Base image with runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["FigueroaCrafts.WebSite.csproj", "./"]
RUN dotnet restore "./FigueroaCrafts.WebSite.csproj"
COPY . .
RUN dotnet build "FigueroaCrafts.WebSite.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "FigueroaCrafts.WebSite.csproj" -c Release -o /app/publish

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "FigueroaCrafts.WebSite.dll"]
