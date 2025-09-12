# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ---------------------------------------------------------------
# Build stage
# ---------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:9.0.100-noble@sha256:bd0365368f46274500ebb086f491703052b8ce23e3d52d3233a23b2020730057 AS builder
WORKDIR /app
COPY cartservice.csproj .
RUN dotnet restore cartservice.csproj -r linux-x64
COPY . .
RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -r linux-x64 \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice

# ---------------------------------------------------------------
# Final runtime image with a shell
# ---------------------------------------------------------------
# NOTE: The original image uses the *chiseled* variant, which is
# extremely minimal and has no package manager or shell.
# To support `kubectl exec -- sh`, switch to the regular runtime-deps
# image so we can install a shell.
FROM mcr.microsoft.com/dotnet/runtime-deps:9.0.0-noble@sha256:16b7018b56cb04e11e6ff924236d5588ec51e64d62ea66abcb9fc2e79f50eb74

# ✅ Install a minimal shell and useful tools
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
