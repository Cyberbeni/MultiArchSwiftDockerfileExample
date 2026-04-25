FROM --platform=$BUILDPLATFORM docker.io/cyberbeni/swift-builder:latest-musl-allocator AS swift-build
WORKDIR /workspace
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
COPY --from=swift-build /workspace/dist/ExampleApp /usr/local/bin/swift-example
ENTRYPOINT ["/usr/local/bin/swift-example"]
