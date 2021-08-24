FROM openapitools/openapi-generator-cli:latest

WORKDIR /src

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION lts/erbium
ENV NODE_PATH $NVM_DIR/

RUN mkdir -p /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash  \
 && . $NVM_DIR/nvm.sh && nvm install lts/erbium && nvm alias default $NODE_VERSION && nvm use default

# Sets up alias required for step 2 of generation
RUN printf '#!/usr/bin/env bash\njava -jar /opt/openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar "$@"' >> /usr/bin/openapi-generator \
 && chmod +x /usr/bin/openapi-generator

COPY package.json package-lock.json .npmrc ./
RUN . $NVM_DIR/nvm.sh && npm install

COPY . .

#CMD bash
CMD . $NVM_DIR/nvm.sh && /src/scripts/utils/openapi-resources.sh
