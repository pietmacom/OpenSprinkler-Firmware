FROM i386/alpine:latest as base

FROM base as build
RUN apk --no-cache add bash g++
COPY . /code
WORKDIR /code
RUN ./build.sh -s demo

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

EXPOSE 80

CMD [ "./OpenSprinkler" ]
