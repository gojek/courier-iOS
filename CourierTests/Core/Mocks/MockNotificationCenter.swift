import Foundation

class MockNotificationCenter: NotificationCenter {
    var invokedPostNotificationName = false
    var invokedPostNotificationNameCount = 0
    var invokedPostNotificationNameParameters: (name: NSNotification.Name, Any?, Void)?
    var invokedPostNotificationNameParametersList = [(name: NSNotification.Name, Any?, Void)]()
    override func post(name aName: NSNotification.Name, object anObject: Any?) {
        invokedPostNotificationName = true
        invokedPostNotificationNameCount += 1
        invokedPostNotificationNameParameters = (aName, anObject, ())
        invokedPostNotificationNameParametersList.append((aName, anObject, ()))
    }

    var invokedPost = false
    var invokedPostCount = 0
    var invokedPostParameters: (notification: Notification, Void)?
    var invokedPostParametersList = [(notification: Notification, Void)]()
    override func post(_ notification: Notification) {
        invokedPost = true
        invokedPostCount += 1
        invokedPostParameters = (notification, ())
        invokedPostParametersList.append((notification, ()))
    }

    var invokedAddObserver = false
    var invokedAddObserverCount = 0
    var invokedAddObserverParameters: (observer: Any, Selector, NSNotification.Name?, Any?)?
    var invokedAddObserverParametersList = [(observer: Any, Selector, name: NSNotification.Name?, Any?)]()
    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        invokedAddObserver = true
        invokedAddObserverCount += 1
        invokedAddObserverParameters = (observer, aSelector, aName, anObject)
        invokedAddObserverParametersList.append((observer, aSelector, aName, anObject))
    }

    var invokedRemoveObserver = false
    var invokedRemoveObserverCount = 0
    var invokedRemoveObserverParameters: (observer: Any, Void)?
    var invokedRemoveObserverParametersList = [(observer: Any, Void)]()
    override func removeObserver(_ observer: Any) {
        invokedRemoveObserver = true
        invokedRemoveObserverCount += 1
        invokedRemoveObserverParameters = (observer, ())
        invokedRemoveObserverParametersList.append((observer, ()))
    }

    var invokedRemoveObserverWithName = false
    var invokedRemoveObserverWithNameCount = 0
    var invokedRemoveObserverWithNameParameters: (observer: Any, NSNotification.Name?, Any?)?
    var invokedRemoveObserverWithNameParametersList = [(observer: Any, name: NSNotification.Name?, Any?)]()
    override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        invokedRemoveObserverWithName = true
        invokedRemoveObserverWithNameCount += 1
        invokedRemoveObserverWithNameParameters = (observer, aName, anObject)
        invokedRemoveObserverWithNameParametersList.append((observer, aName, anObject))
    }
}
