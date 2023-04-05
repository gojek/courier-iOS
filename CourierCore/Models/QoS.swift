import Foundation

public enum QoS: Int {
    
    // http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html#_Toc398718100
    case zero = 0
    
    // http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html#_Toc398718100
    case one = 1
    
    // http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html#_Toc398718100
    case two = 2
    
    /** Like QoS1, Message delivery is acknowledged with Puback, but unlike Qos1 messages are
       nor persisted and neither retied at send after one attempt.
       The message arrives at the receiver either once or not at all **/
    case oneWithoutPersistenceAndNoRetry = 3
    
    /** Like QoS1, Message delivery is acknowledged with Puback, but unlike Qos1 messages are
         not persisted. The messages are retried within active connection if delivery is not acknowledged.**/
    case oneWithoutPersistenceAndRetry = 4
    
    // Used internally by the Courier for determinining publish persistence and subscribe payload behaviors
    var internalRawValue: (value: Int, type: Int) {
        switch self {
        case .zero: return (QoS.zero.rawValue, self.rawValue)
        case .one: return (QoS.one.rawValue, self.rawValue)
        case .two: return (QoS.one.rawValue, self.rawValue)
        case .oneWithoutPersistenceAndNoRetry: return (QoS.zero.rawValue, self.rawValue)
        case .oneWithoutPersistenceAndRetry: return (QoS.zero.rawValue, self.rawValue)
        }
    }
}
