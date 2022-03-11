import XCTest
@testable import CourierCore
@testable import CourierMQTT
class MQTTMessageReceiveListenerTests: XCTestCase {

    var sut: MqttMessageReceiverListener!
    var publishSubject: PublishSubject<MQTTPacket>!
    var dispatchQueue: DispatchQueue!
    private let disposeBag = DisposeBag()

    override func setUp() {
        publishSubject = PublishSubject<MQTTPacket>()
        dispatchQueue = .main

        sut = MqttMessageReceiverListener(publishSubject: publishSubject, publishSubjectDispatchQueue: dispatchQueue)
    }

    func testOnMessageArrived() {
        let exp = expectation(description: "messageArrived")
        let data = "hello".data(using: .utf8)!

        publishSubject
            .asObservable()
            .subscribe { event in
                let packet = event.element!
                XCTAssertEqual(String(data: packet.data, encoding: .utf8), "hello")
                XCTAssertEqual(packet.topic, "fbon")
                XCTAssertEqual(packet.qos, .two)
                exp.fulfill()
            }
            .disposed(by: disposeBag)

        sut.messageArrived(data: data, topic: "fbon", qos: .two)
        waitForExpectations(timeout: 0.1, handler: nil)
    }

}
