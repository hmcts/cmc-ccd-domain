FROM hmctspublic.azurecr.io/base/node:22-alpine as base
USER hmcts
COPY --chown=hmcts:hmcts package.json yarn.lock .yarnrc.yml ./
COPY --chown=hmcts:hmcts .yarn/releases ./.yarn/releases
RUN corepack yarn install --immutable --mode=skip-build && corepack yarn cache clean
COPY index.js ./
ENV NODE_CONFIG_DIR="/config"
CMD ["corepack", "yarn", "start"]
EXPOSE 3000
