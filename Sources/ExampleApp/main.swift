import Foundation
import MQTTNIO

print("Hello world")
print("Hello \(MQTTClient.self)")

for aSignal in [
	SIGINT, // ctrl+C in interactive mode
	SIGTERM, // docker container stop container_name
] {
	signal(aSignal, SIG_IGN)
	let signalSource = DispatchSource.makeSignalSource(signal: aSignal, queue: .main)
	signalSource.setEventHandler {
		print("Got \(aSignal)")
		exit(0)
	}
	signalSource.resume()
}

RunLoop.main.run()
