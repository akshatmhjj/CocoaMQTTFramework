import Foundation
import CocoaMQTT

/// Implementation of MQTTClient using the CocoaMQTT library.
public final class CocoaMQTTManager: NSObject, MQTTClient {
    
    // MARK: - Properties
    
    private var mqtt: CocoaMQTT?
    public private(set) var connectionState: MQTTConnectionState = .disconnected
    public weak var delegate: MQTTClientDelegate?
    
    // MARK: - MQTTClient Implementation
    
    public func connect(with config: MQTTConfig) {
        let clientID = config.clientId
        let host = config.host
        let port = config.port
        
        mqtt = CocoaMQTT(clientID: clientID, host: host, port: port)
        mqtt?.keepAlive = config.keepAlive
        mqtt?.username = config.username
        mqtt?.password = config.password
        mqtt?.cleanSession = config.cleanSession
        mqtt?.delegate = self
        
        // SSL Support
        if config.useSSL {
            mqtt?.enableSSL = true
            mqtt?.allowUntrustCACertificate = true
        }
        
        updateState(.connecting)
        _ = mqtt?.connect()
    }
    
    public func disconnect() {
        mqtt?.disconnect()
    }
    
    public func subscribe(to topic: String, qos: MQTTQoS) {
        mqtt?.subscribe(topic, qos: convertQoS(qos))
    }
    
    public func unsubscribe(from topic: String) {
        mqtt?.unsubscribe(topic)
    }
    
    public func publish(_ message: MQTTMessage) {
        mqtt?.publish(
            message.topic,
            withString: message.stringRepresentation ?? "",
            qos: convertQoS(message.qos),
            retained: message.retained
        )
    }
    
    // MARK: - Private Methods
    
    private func updateState(_ newState: MQTTConnectionState) {
        guard connectionState != newState else { return }
        connectionState = newState
        delegate?.mqttClient(self, didChangeState: newState)
    }
    
    private func convertQoS(_ qos: MQTTQoS) -> CocoaMQTTQoS {
        switch qos {
        case .atMostOnce: return .qos0
        case .atLeastOnce: return .qos1
        case .exactlyOnce: return .qos2
        }
    }
}

// MARK: - CocoaMQTTDelegate

extension CocoaMQTTManager: CocoaMQTTDelegate {
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            updateState(.connected)
        } else {
            updateState(.disconnected)
            let error = NSError(domain: "CocoaMQTTManager", code: Int(ack.rawValue), userInfo: [NSLocalizedDescriptionKey: "Connection failed with status: \(ack)"])
            delegate?.mqttClient(self, didEncounterError: error)
        }
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        // Optional: Could notify delegate about successful publish
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let internalMessage = MQTTMessage(
            topic: message.topic,
            payload: Data(message.payload),
            qos: MQTTQoS(rawValue: UInt8(message.qos.rawValue)) ?? .atMostOnce,
            retained: message.retained
        )
        delegate?.mqttClient(self, didReceiveMessage: internalMessage)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        updateState(.disconnected)
        if let error = err {
            delegate?.mqttClient(self, didEncounterError: error)
        }
    }
}
