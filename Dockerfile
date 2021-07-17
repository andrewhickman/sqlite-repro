FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy and publish app and libraries
COPY Program.cs .
RUN dotnet publish -c release -o /app --no-restore

FROM mcr.microsoft.com/windows/servercore:ltsc2019 as vcinstall

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=build /app .
COPY --from=vcinstall C:/Windows/System32/mscoree.dll C:/Windows/System32

ENTRYPOINT ["dotnet", "sqlite-repro.dll"]