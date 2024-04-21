# Use the official Node.js 20.x Alpine image
FROM node:20.12.2-alpine3.19

# Set the working directory in the container
WORKDIR /app

# Install Vue CLI globally
RUN npm i -g @quasar/cli
# Install system dependencies
RUN apk update && apk add --no-cache git

RUN chmod -R 777 /app
# Clear cache
RUN rm -rf /var/cache/apk/*

# Run tail command, no close container
CMD ["tail", "-f", "/dev/null"]
