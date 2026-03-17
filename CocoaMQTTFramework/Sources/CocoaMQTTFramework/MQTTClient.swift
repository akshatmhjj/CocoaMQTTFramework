import Foundation

/// Delegate protocol for MQTT client events.
public protocol MQTTClientDelegate: AnyObject {
    /// Called when the connection state changes.
    func mqttClient(_ client: MQTTClient, didChangeState state: MQTTConnectionState)
    
    /// Called when a message is received on a subscribed topic.
    func mqttClient(_ client: MQTTClient, didReceiveMessage message: MQTTMessage)
    
    /// Called when an error occurs.
    func mqttClient(_ client: MQTTClient, didEncounterError error: Error)
}

/// Core protocol for the MQTT reusable framework.
public protocol MQTTClient: AnyObject {
    /// The current connection state.
    var connectionState: MQTTConnectionState { get }
    
    /// The delegate to receive events.
    var delegate: MQTTClientDelegate? { get set }
    
    /// Connect to the MQTT broker using the provided configuration.
    func connect(with config: MQTTConfig)
    
    /// Disconnect from the MQTT broker.
    func disconnect()
    
    /// Subscribe to a topic with a specific QoS.
    func subscribe(to topic: String, qos: MQTTQoS)
    
    /// Unsubscribe from a topic.
    func unsubscribe(from topic: String)
    
    /// Publish a message to a topic.
    func publish(_ message: MQTTMessage)
}
