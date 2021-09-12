FROM node:16-alpine3.12

RUN npm install -g typescript pm2 && \
  apk add net-tools curl bash && \
  echo "alias l='ls -la'" >> ~/.bashrc

CMD sh -c "cd /opt/app/; npm start"
