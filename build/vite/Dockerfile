FROM node:21
RUN npm install -g bun@1.0.36
RUN git config --global --add safe.directory /github/workspace
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
