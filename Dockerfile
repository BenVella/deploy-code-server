FROM codercom/code-server:3.10.1
USER ben
COPY settings.json .local/share/code-server/User/settings.json
ENV SHELL=/bin/bash
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash
RUN sudo chown -R ben:ben /home/coder/.local
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install build-essential gdb -y
RUN code-server --install-extension ms-vscode.cpptools
RUN git config --global user.name "ben"
RUN git config --global user.email "bennetvella@gmail.com"
ENV PORT=8080
COPY entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
