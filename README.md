# CocoaMQTTFramework

A reusable, protocol-oriented MQTT framework for Swift based on `CocoaMQTT`.

## Features

- **Protocol-Oriented**: Core logic is abstracted behind the `MQTTClient` protocol.
- **Simplified API**: Easy to use `MQTTConfig` and `MQTTMessage` models.
- **Thread-Safe**: Built-in handling for connection state and message delivery.
- **SSL/TLS Support**: Configurable security settings.

## Installation

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "/path/to/CocoaMQTTFramework", from: "1.0.0")
]
```

## Usage

### 1. Initialize the Client

```swift
import CocoaMQTTFramework

let config = MQTTConfig(
    host: "broker.emqx.io",
    port: 1883,
    clientId: "MyClient"
)

let mqttClient: MQTTClient = CocoaMQTTManager()
mqttClient.delegate = self
mqttClient.connect(with: config)
```

### 2. Implement the Delegate

```swift
extension MyService: MQTTClientDelegate {
    func mqttClient(_ client: MQTTClient, didChangeState state: MQTTConnectionState) {
        print("MQTT State: \(state)")
    }

    func mqttClient(_ client: MQTTClient, didReceiveMessage message: MQTTMessage) {
        print("Received: \(message.stringRepresentation ?? "") on \(message.topic)")
    }

    func mqttClient(_ client: MQTTClient, didEncounterError error: Error) {
        print("Error: \(error)")
    }
}
```

### 3. Subscribe and Publish

```swift
mqttClient.subscribe(to: "home/sensors/temp", qos: .atLeastOnce)

let message = MQTTMessage(topic: "home/commands", string: "ping")
mqttClient.publish(message)
```

## Testing

Run tests using:
```bash
swift test
```

## Architecture

The framework encapsulates `CocoaMQTT` within a manager class, allowing you to swap out the underlying library easily if needed by providing a new implementation of the `MQTTClient` protocol.
