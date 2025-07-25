import Dispatch
import Foundation
#if canImport(SwiftGlibc)
	@preconcurrency import SwiftGlibc
#endif

// NOTE: Not necessary when using Logging
// https://github.com/apple/swift-log
// Make sure print() output is instant
setlinebuf(stdout)

print("Hello world")
print("This should be visible right after starting the application")

// NOTE: If you are using ServiceLifecycle, delete this
// https://github.com/swift-server/swift-service-lifecycle
// Documentation: https://swiftpackageindex.com/swift-server/swift-service-lifecycle/main/documentation/servicelifecycle/how-to-adopt-servicelifecycle-in-libraries#Graceful-shutdown
let signalHandlers = [
	SIGINT, // ctrl+C in interactive mode
	SIGTERM, // docker container stop container_name
].map { signalName in
	// https://github.com/swift-server/swift-service-lifecycle/blob/24c800fb494fbee6e42bc156dc94232dc08971af/Sources/UnixSignals/UnixSignalsSequence.swift#L80-L85
	#if canImport(Darwin)
		signal(signalName, SIG_IGN)
	#endif
	let signalSource = DispatchSource.makeSignalSource(signal: signalName, queue: .main)
	signalSource.setEventHandler {
		print("Got signal: \(signalName)")
		// Save state, close connections gracefully, etc.
		exit(0)
	}
	signalSource.resume()
	return signalSource
}

// NOTE: RunLoop is required for some classes, like Timer.
// If you don't want to import Foundation (to decrease binary size), you can use `dispatchMain()`
RunLoop.main.run()
