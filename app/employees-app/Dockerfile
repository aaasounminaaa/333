FROM alpine:latest
WORKDIR /app
RUN apk update && apk add --no-cache \
    libc6-compat \
    libstdc++ \
    libgcc
RUN apk upgrade --no-cache busybox
RUN apk --no-cache add curl
COPY ./employees /app/employees
RUN chmod +x /app/employees

# ENV MYSQL_USER=admin
# ENV MYSQL_PASSWORD=Skill53##
# ENV MYSQL_HOST=apdev-rds-instance.cmjijxwdspmf.ap-northeast-2.rds.amazonaws.com
# ENV MYSQL_PORT=3306
# ENV MYSQL_DBNAME=dev

EXPOSE 8080

CMD ["/app/employees"]