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

FROM eclipse-temurin:21@sha256:b5fc642f67dbbd1c4ce811388801cb8480aaca8aa9e56fd6dcda362cfea113f1 AS builder

WORKDIR /app

COPY ["build.gradle", "gradlew", "./"]
COPY gradle gradle
RUN chmod +x gradlew
RUN ./gradlew downloadRepos

COPY . .
RUN chmod +x gradlew
RUN ./gradlew installDist

# ---------------------------------------------------------------
# ✅ Final runtime image with a usable shell
# ---------------------------------------------------------------
FROM eclipse-temurin:21.0.4_7-jre-alpine@sha256:8cc1202a100e72f6e91bf05ab274b373a5def789ab6d9e3e293a61236662ac27

# ✅ Add a minimal shell and basic tools for kubectl exec
RUN apk add --no-cache bash curl procps

WORKDIR /app
COPY --from=builder /app .

EXPOSE 9555
ENTRYPOINT ["/app/build/install/hipstershop/bin/AdService"]
