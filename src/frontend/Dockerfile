# Copyright 2020 Google LLC
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
FROM golang:1.23.2-alpine@sha256:9dd2625a1ff2859b8d8b01d8f7822c0f528942fe56cfe7a1e7c38d3b8d72d679 AS builder
WORKDIR /src

# restore dependencies
COPY go.mod go.sum ./
RUN go mod download
COPY . .

# Skaffold passes in debug-oriented compiler flags
ARG SKAFFOLD_GO_GCFLAGS
RUN CGO_ENABLED=0 GOOS=linux go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /go/bin/frontend .

# ---------------------------------------------------------------
# Final runtime image with a shell
# ---------------------------------------------------------------
FROM alpine:3.19

# ✅ Install a minimal shell and basic tools for debugging
RUN apk add --no-cache bash curl procps

WORKDIR /src
COPY --from=builder /go/bin/frontend /src/server
COPY ./templates ./templates
COPY ./static ./static

# Skaffold debug variable
ENV GOTRACEBACK=single

EXPOSE 8080
ENTRYPOINT ["/src/server"]
