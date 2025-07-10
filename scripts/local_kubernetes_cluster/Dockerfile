# Use a base Ubuntu image
FROM ubuntu:22.04

# Install curl, xz-utils, bash, and any dependencies we might need
RUN apt-get update && apt-get install -y \
    sudo \
    curl;

RUN ls /var/run

# Define the build argument for selecting which tool to install
ARG INSTALL

# Set the working directory in the container
WORKDIR /app

# Copy the run.sh script into the container
COPY ./run.sh /app/
COPY ./k3d_nix.sh /app/
COPY ./kind_nix.sh /app/
COPY ./resources/ /app/resources

# Make run.sh executable
RUN chmod +x /app/run.sh

# kind by default
ENTRYPOINT [ "/bin/bash", "./run.sh", "test", "kind"]
