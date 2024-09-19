# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM swift:6.0.0 AS build
WORKDIR /home
RUN swift sdk install \
	https://download.swift.org/swift-6.0-release/static-sdk/swift-6.0-RELEASE/swift-6.0-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
	--checksum 7984c2cf175bde52ba6ea1fcbe27fc4a148a6237c41c719209c9288ed3ceb652

COPY ./Package.* /home/
RUN --mount=type=cache,target=/home/.spm-cache \
	swift package --cache-path /home/.spm-cache resolve

COPY . /home
ARG TARGETPLATFORM
RUN --mount=type=cache,target=/home/.build,id=build-$TARGETPLATFORM \
	--mount=type=cache,target=/home/.spm-cache \
	scripts/build.sh && \
	mkdir -p dist && \
	cp .build/release/ExampleApp dist

FROM scratch
COPY --from=build /home/dist/ExampleApp /bin/app
ENTRYPOINT ["/bin/app"]
