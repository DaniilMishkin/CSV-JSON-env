FROM node:20

ARG UID
ARG GID

RUN usermod -u $UID -o node && groupmod -g $GID -o node

WORKDIR '/var/www'

COPY ./ ./

RUN yarn install

USER node

CMD [ "yarn", "build"]
