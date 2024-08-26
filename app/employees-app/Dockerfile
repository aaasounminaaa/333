FROM alpine:latest
# ENV MYSQL_USER=admin
# ENV MYSQL_PASSWORD=Skill53##
# ENV MYSQL_HOST=apdev-rds-proxy.proxy-cmuopdm8krmm.ap-northeast-2.rds.amazonaws.com
# ENV MYSQL_PORT=3306
# ENV MYSQL_DBNAME=dev

WORKDIR /app
COPY ./employees /app/employees
RUN apk add --no-cache libc6-compat libstdc++ libgcc openssl && \
        apk upgrade --no-cache busybox && \
        chmod +x /app/employees && \
        adduser -D -H -s /bin/sh employee
USER employee
EXPOSE 8080

CMD ["/app/employees"]
