FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["asp-docker.csproj", "./"]
RUN dotnet restore "asp-docker.csproj"
COPY . .
RUN dotnet build "asp-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "asp-docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "asp-docker.dll"]
