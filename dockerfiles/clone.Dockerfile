# syntax=docker/dockerfile:experimental
FROM alpine AS build

# Install ssh client and git
RUN apk add --no-cache openssh-client git

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone private repository
RUN --mount=type=ssh git clone git@github.com:hudl/baskerville.git /usr/app/baskerville

WORKDIR /usr/app/baskerville
RUN ls

FROM scratch
COPY --from=build /usr/app/baskerville /