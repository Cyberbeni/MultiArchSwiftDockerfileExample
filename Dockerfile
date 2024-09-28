# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM swift:6.0.1 AS build
WORKDIR /workspace
RUN swift sdk install \
	https://download.swift.org/swift-6.0.1-release/static-sdk/swift-6.0.1-RELEASE/swift-6.0.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz \
	--checksum d4f46ba40e11e697387468e18987ee622908bc350310d8af54eb5e17c2ff5481

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
	--mount=type=cache,target=/workspace/.spm-cache \
	scripts/build.sh && \
	mkdir -p dist && \
	cp .build/release/ExampleApp dist

FROM scratch AS release
COPY --from=build /workspace/dist/ExampleApp /bin/app
ENTRYPOINT ["/bin/app"]
