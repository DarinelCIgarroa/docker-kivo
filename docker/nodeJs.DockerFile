# Use the official Node.js 20.x Alpine image
FROM node:20.12.2-alpine3.19
# Aceptar argumentos de nombre de usuario y UID
ARG USER
ARG UID

RUN apk add sudo

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies
RUN apk update && apk add --no-cache linux-headers
RUN apk add zsh
RUN npm install -g @quasar/cli --no-cache

# Clear cache
RUN rm -rf /var/cache/apk/*

# Cambiar el nombre del usuario
RUN OLD_USER=$(getent passwd $UID | cut -d: -f1) && deluser $OLD_USER && adduser -D -u $UID $USER
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Cambiar al usuario proporcionado
USER $USER

# Run tail command, no close container
CMD ["tail", "-f", "/dev/null"]
