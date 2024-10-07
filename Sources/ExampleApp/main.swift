import Foundation

// Make sure print() output is instant
#if canImport(SwiftGlibc)
	@preconcurrency import SwiftGlibc
#endif
setlinebuf(stdout)

print("Hello world")
print("This should be visible right after starting the application")

let signalHandlers = [
	SIGINT, // ctrl+C in interactive mode
	SIGTERM, // docker container stop container_name
].map { signalName in
	signal(signalName, SIG_IGN)
	let signalSource = DispatchSource.makeSignalSource(signal: signalName, queue: .main)
	signalSource.setEventHandler {
		print("Got signal: \(signalName)")
		// Save state, close connections gracefully, etc.
		exit(0)
	}
	signalSource.resume()
	return signalSource
}

RunLoop.main.run()
