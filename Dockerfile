#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["FigueroaCrafts.WebSite/FigueroaCrafts.WebSite.csproj", "FigueroaCrafts.WebSite/"]
RUN dotnet restore "FigueroaCrafts.WebSite/FigueroaCrafts.WebSite.csproj"
COPY . .
WORKDIR "/src/FigueroaCrafts.WebSite"
RUN dotnet build "FigueroaCrafts.WebSite.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FigueroaCrafts.WebSite.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "FigueroaCrafts.WebSite.dll"]
