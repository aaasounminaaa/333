FROM alpine:latest
WORKDIR /app
RUN apk update && apk add --no-cache \
    libc6-compat \
    libstdc++ \
    libgcc
RUN apk upgrade --no-cache busybox
COPY ./token /app/token
RUN chmod +x /app/token
EXPOSE 8080

CMD ["/app/token"]