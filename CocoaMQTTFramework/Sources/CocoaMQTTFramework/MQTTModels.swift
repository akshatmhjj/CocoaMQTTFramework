import Foundation

/// Represents the configuration for an MQTT connection.
public struct MQTTConfig {
    public let host: String
    public let port: UInt16
    public let clientId: String
    public let keepAlive: UInt16
    public let cleanSession: Bool
    public let username: String?
    public let password: String?
    public let useSSL: Bool
    
    public init(
        host: String,
        port: UInt16 = 1883,
        clientId: String = "SwiftMQTTClient-\(UUID().uuidString.prefix(8))",
        keepAlive: UInt16 = 60,
        cleanSession: Bool = true,
        username: String? = nil,
        password: String? = nil,
        useSSL: Bool = false
    ) {
        self.host = host
        self.port = port
        self.clientId = clientId
        self.keepAlive = keepAlive
        self.cleanSession = cleanSession
        self.username = username
        self.password = password
        self.useSSL = useSSL
    }
}

/// Represents a message received or to be published via MQTT.
public struct MQTTMessage {
    public let topic: String
    public let payload: Data
    public let qos: MQTTQoS
    public let retained: Bool
    
    public init(topic: String, payload: Data, qos: MQTTQoS = .atMostOnce, retained: Bool = false) {
        self.topic = topic
        self.payload = payload
        self.qos = qos
        self.retained = retained
    }
    
    public init?(topic: String, string: String, qos: MQTTQoS = .atMostOnce, retained: Bool = false) {
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(topic: topic, payload: data, qos: qos, retained: retained)
    }
    
    public var stringRepresentation: String? {
        return String(data: payload, encoding: .utf8)
    }
}

/// MQTT Quality of Service levels.
public enum MQTTQoS: UInt8 {
    case atMostOnce = 0
    case atLeastOnce = 1
    case exactlyOnce = 2
}

/// Represents the connection state of the MQTT client.
public enum MQTTConnectionState {
    case disconnected
    case connecting
    case connected
}
