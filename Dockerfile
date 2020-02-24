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
RUN ln -s /data/stns.dat && \
    ln -s /data/nvm.dat && \
    ln -s /data/ifkey.txt && \
    ln -s /data/logs
COPY --from=build /code/OpenSprinkler /OpenSprinkler/OpenSprinkler

VOLUME /data

EXPOSE 8080

CMD [ "./OpenSprinkler" ]
