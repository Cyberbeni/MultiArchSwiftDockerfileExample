ARG SWIFT_VERSION
FROM swift:${SWIFT_VERSION}

# If a default user exists, we have to delete it, so its uid:gid doesn't conflict with our own user.
# https://github.com/devcontainers/images/blob/466aac5d06c87841d257cac96dd876afb9b7a578/src/base-ubuntu/.devcontainer/Dockerfile
RUN if id "ubuntu" &>/dev/null; then \
		echo "Deleting user 'ubuntu'" && userdel -f -r ubuntu || echo "Failed to delete 'ubuntu' user"; \
	fi
