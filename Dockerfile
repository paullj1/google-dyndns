# Taken from gist:
# https://gist.github.com/drewchapin/57d7039e30e8cc49e30bdc56a194f5bf

FROM alpine:latest
RUN apk add --update --no-cache \
  curl

ADD dyndns.sh /
CMD ["/dyndns.sh"]
