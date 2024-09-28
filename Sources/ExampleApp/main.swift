import Foundation
import MQTTNIO

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
