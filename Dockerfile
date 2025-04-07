# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM docker.io/swift:6.1.0 AS build
WORKDIR /workspace
RUN swift sdk install \
	https://download.swift.org/swift-6.1-release/static-sdk/swift-6.1-RELEASE/swift-6.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
	--checksum 111c6f7d280a651208b8c74c0521dd99365d785c1976a6e23162f55f65379ac6

COPY ./Package.swift ./Package.resolved /workspace/
RUN --mount=type=cache,target=/workspace/.spm-cache,id=spm-cache \
	swift package \
		--cache-path /workspace/.spm-cache \
		--only-use-versions-from-resolved-file \
		resolve

COPY ./scripts /workspace/scripts
COPY ./Sources /workspace/Sources
ARG TARGETPLATFORM
RUN --mount=type=cache,target=/workspace/.build,id=build-$TARGETPLATFORM \
	--mount=type=cache,target=/workspace/.spm-cache,id=spm-cache \
	scripts/build-release.sh && \
	mkdir -p dist && \
	cp .build/release/ExampleApp dist

FROM scratch AS release
COPY --from=build /workspace/dist/ExampleApp /usr/local/bin/swift-example
ENTRYPOINT ["/usr/local/bin/swift-example"]
