# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM docker.io/swift:6.2.0 AS build
WORKDIR /workspace
RUN swift sdk install \
	https://download.swift.org/swift-6.2-release/static-sdk/swift-6.2-RELEASE/swift-6.2-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
	--checksum d2225840e592389ca517bbf71652f7003dbf45ac35d1e57d98b9250368769378

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
