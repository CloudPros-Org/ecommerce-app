FROM mcr.microsoft.com/dotnet/sdk:9.0.100-noble AS builder
WORKDIR /app
COPY src/cartservice.csproj .
RUN dotnet restore cartservice.csproj -r linux-x64
COPY src/ .
RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -r linux-x64 \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice

FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-noble

RUN apt-get update && apt-get install -y --no-install-recommends \
      bash curl procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /cartservice .
EXPOSE 7070
ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070
USER 1000
ENTRYPOINT ["/app/cartservice"]
