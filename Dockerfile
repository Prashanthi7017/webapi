# Use the official .NET Core runtime image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET Core SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["WeatherForecastApi.csproj", "."]
RUN dotnet restore "./WeatherForecastApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WeatherForecastApi.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "WeatherForecastApi.csproj" -c Release -o /app/publish

# Create the final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WeatherForecastApi.dll"]
