FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["CodeRunnerAksDemo/CodeRunnerAksDemo.csproj", "CodeRunnerAksDemo/"]
RUN dotnet restore "CodeRunnerAksDemo/CodeRunnerAksDemo.csproj"
COPY . .
WORKDIR "/src/CodeRunnerAksDemo"
RUN dotnet build "CodeRunnerAksDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CodeRunnerAksDemo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CodeRunnerAksDemo.dll"]