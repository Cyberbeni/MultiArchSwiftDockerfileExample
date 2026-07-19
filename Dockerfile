FROM --platform=$BUILDPLATFORM codeberg.org/cyberbeni/swift-builder:latest-musl-allocator AS swift-build
ARG BUILDPLATFORM
WORKDIR /workspace
COPY ./Package.swift ./Package.resolved /workspace/
RUN --mount=type=cache,target=/workspace/.build,id=build-$BUILDPLATFORM \
	--mount=type=cache,target=/workspace/.spm-cache,id=spm-cache \
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

FROM docker.io/alpine:latest AS release
RUN apk add --no-cache \
	tzdata
COPY --from=swift-build /workspace/dist/ExampleApp /usr/local/bin/ExampleApp
ENTRYPOINT ["/usr/local/bin/ExampleApp"]
