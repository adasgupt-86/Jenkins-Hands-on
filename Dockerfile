FROM alpine:3.19

WORKDIR /app
COPY app.sh .

RUN chmod +x app.sh

CMD ["./app.sh"]
