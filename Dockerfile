FROM node:lts-alpine

# Install git for bower compatibility
RUN apk add --no-cache git python2 build-base git
RUN npm i -g --force yarn
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
