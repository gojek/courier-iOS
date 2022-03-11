import Foundation

@testable import CourierCore
@testable import CourierMQTT
class MockMulticastDelegate: MulticastDelegate<ICourierEventHandler> {

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: ICourierEventHandler?
    var invokedAddParametersList = [ICourierEventHandler]()
    override func add(_ delegate: ICourierEventHandler) {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = delegate
        invokedAddParametersList.append(delegate)
    }

    var invokedRemove = false
    var invokedRemoveCount = 0
    var invokedRemoveParameters: ICourierEventHandler?
    var invokedRemoveParametersList = [ICourierEventHandler]()
    override func remove(_ delegateToRemove: ICourierEventHandler) {
        invokedRemove = true
        invokedRemoveCount += 1
        invokedRemoveParameters = delegateToRemove
        invokedRemoveParametersList.append(delegateToRemove)
    }

    var invokedInvoke = false
    var invokedInvokeCount = 0
    var stubbedInvokeCourierEventHandler: ICourierEventHandler!
    override func invoke(_ invocation: @escaping (ICourierEventHandler) -> Void) {
        invokedInvoke = true
        invokedInvokeCount += 1
        invocation(stubbedInvokeCourierEventHandler)

    }

}
