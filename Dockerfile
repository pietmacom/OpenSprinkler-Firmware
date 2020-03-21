FROM --platform=$TARGETPLATFORM alpine:latest as base

FROM base as build
RUN apk --no-cache add bash g++
COPY . /code
WORKDIR /code

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] || [ "$TARGETPLATFORM" = "linux/386" ]; then \
    ./build.sh -s demo; \
    else \
    ./build.sh -s ospi; \
    fi

FROM base
RUN apk --no-cache add libstdc++ && \
    mkdir /OpenSprinkler && \
    mkdir -p /data/logs
WORKDIR /OpenSprinkler

COPY --from=build /code/OpenSprinkler /OpenSprinkler/OpenSprinkler

VOLUME /data

EXPOSE 8080

CMD [ "./OpenSprinkler", "-d", "/data" ]
