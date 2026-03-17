import XCTest
import Foundation
@testable import CocoaMQTTFramework

final class MQTTModelsTests: XCTestCase {
    func testMQTTConfigDefaultValues() {
        let config = MQTTConfig(host: "broker.emqx.io")
        XCTAssertEqual(config.host, "broker.emqx.io")
        XCTAssertEqual(config.port, 1883)
        XCTAssertTrue(config.cleanSession)
        XCTAssertEqual(config.keepAlive, 60)
    }
    
    func testMQTTMessageStringPayload() {
        let message = MQTTMessage(topic: "test/topic", string: "Hello MQTT")
        XCTAssertNotNil(message)
        XCTAssertEqual(message?.topic, "test/topic")
        XCTAssertEqual(message?.stringRepresentation, "Hello MQTT")
    }
}

final class CocoaMQTTManagerTests: XCTestCase {
    func testConnectionStateDisconnectedAtStart() {
        let manager = CocoaMQTTManager()
        XCTAssertEqual(manager.connectionState, .disconnected)
    }
    
    func testInitialConnectionState() {
        let manager = CocoaMQTTManager()
        let config = MQTTConfig(host: "broker.emqx.io", port: 1883)
        
        manager.connect(with: config)
        XCTAssertEqual(manager.connectionState, .connecting)
        
        // Cleanup
        manager.disconnect()
    }
}

// Mock Delegate for further testing if needed
class MockMQTTClientDelegate: MQTTClientDelegate {
    var stateChanges: [MQTTConnectionState] = []
    var receivedMessages: [MQTTMessage] = []
    var errors: [Error] = []
    
    func mqttClient(_ client: MQTTClient, didChangeState state: MQTTConnectionState) {
        stateChanges.append(state)
    }
    
    func mqttClient(_ client: MQTTClient, didReceiveMessage message: MQTTMessage) {
        receivedMessages.append(message)
    }
    
    func mqttClient(_ client: MQTTClient, didEncounterError error: Error) {
        errors.append(error)
    }
}
