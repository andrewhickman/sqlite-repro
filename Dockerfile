FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy and publish app and libraries
COPY Program.cs .
RUN dotnet publish -c release -o /app --no-restore

FROM mcr.microsoft.com/windows/servercore:ltsc2019 as vcinstall

ADD https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe /vc_redist.x64.exe
RUN C:\vc_redist.x64.exe /quiet /install

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=build /app .
COPY --from=vcinstall C:/Windows/System32/mscoree.dll C:/Windows/System32

ENTRYPOINT ["dotnet", "sqlite-repro.dll"]