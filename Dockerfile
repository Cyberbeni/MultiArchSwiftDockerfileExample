# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM swift:6.0.1 AS build
WORKDIR /home
RUN swift sdk install \
	https://download.swift.org/swift-6.0.1-release/static-sdk/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
	--checksum d4f46ba40e11e697387468e18987ee622908bc350310d8af54eb5e17c2ff5481

COPY ./Package.swift ./Package.resolved /home/
RUN --mount=type=cache,target=/home/.spm-cache,id=spm-cache \
	swift package \
		--cache-path /home/.spm-cache \
		--only-use-versions-from-resolved-file \
		resolve

COPY ./scripts /home/scripts
COPY ./Sources /home/Sources
ARG TARGETPLATFORM
RUN --mount=type=cache,target=/home/.build,id=build-$TARGETPLATFORM \
	--mount=type=cache,target=/home/.spm-cache \
	scripts/build.sh && \
	mkdir -p dist && \
	cp .build/release/ExampleApp dist

FROM scratch AS release
COPY --from=build /home/dist/ExampleApp /bin/app
ENTRYPOINT ["/bin/app"]
