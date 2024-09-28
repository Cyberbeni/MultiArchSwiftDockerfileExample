import Foundation
import MQTTNIO

// Set stdout to be line buffered
#if canImport(Darwin)
#elseif canImport(Musl)
	import Musl
	setlinebuf(stdout)
#elseif canImport(Glibc)
	import Glibc
	// error: reference to var 'stdout' is not concurrency-safe because it involves shared mutable state
	// setlinebuf(stdout)
	#warning("print() output might be buffered")
#endif

print("Hello world")
print("Hello \(MQTTClient.self)")

let signalHandlers = [
	SIGINT, // ctrl+C in interactive mode
	SIGTERM, // docker container stop container_name
].map { signalName in
	signal(signalName, SIG_IGN)
	let signalSource = DispatchSource.makeSignalSource(signal: signalName, queue: .main)
	signalSource.setEventHandler {
		print("Got signal: \(signalName)")
		exit(0)
	}
	signalSource.resume()
	return signalSource
}

RunLoop.main.run()
