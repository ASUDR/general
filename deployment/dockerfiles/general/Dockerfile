FROM node:16-alpine3.12

RUN npm install -g pnpm && \
  apk add net-tools curl bash && \
  echo "alias l='ls -la'" >> ~/.bashrc

CMD sh -c "pnpm start"
