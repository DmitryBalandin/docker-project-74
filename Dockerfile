FROM node:20.12.2

WORKDIR /app

COPY . .

CMD ["make", "test"]