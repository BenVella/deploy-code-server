# Start from the code-server Debian base image
FROM codercom/code-server:latest

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# Add debian testing main APT source for gcc-9 and cmake 3.18
RUN sudo chown coder:coder /etc/apt/sources.list
RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list
RUN sudo apt update -y

# Build Essential includes C & CPP Compilers, GDB for debugging. -y as Yes to All
RUN sudo apt-get install build-essential gdb manpages-dev -y

# Code Server tool installation
RUN code-server --install-extension ms-vscode.cpptools
RUN code-server --install-extension ms-vscode.cmake-tools

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
