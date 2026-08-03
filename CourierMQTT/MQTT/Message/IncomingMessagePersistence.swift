import CourierCore
import Foundation
@preconcurrency import CoreData

protocol IncomingMessagePersistenceProtocol {
    
    func saveMessage(_ message: MQTTPacket) throws
    func getAllMessages(_ topics: [String]) -> [MQTTPacket]
    func deleteAllMessages()
    func deleteMessages(_ ids: [String])
    func deleteMessagesWithOlderTimestamp(_ timestamp: Date)
}

final class IncomingMessagePersistence: IncomingMessagePersistenceProtocol {

    /// When `true`, message deletion on a non-SQLite (in-memory fallback) store uses a
    /// fetch-and-delete loop instead of `NSBatchDeleteRequest`. `NSBatch*Request` is only
    /// supported by SQLite stores; running it against the in-memory fallback store throws an
    /// uncatchable `NSInternalInconsistencyException` ("Unknown command type") and crashes.
    /// Set to `false` to restore the previous (crashing) behaviour.
    private let useSafeDeleteForNonSQLiteStore: Bool

    /// The store type the coordinator actually initialised with. `nil` until `coordinator`
    /// is first resolved. Used to decide whether batch deletes are safe.
    private var resolvedStoreType: String?

    init(useSafeDeleteForNonSQLiteStore: Bool) {
        self.useSafeDeleteForNonSQLiteStore = useSafeDeleteForNonSQLiteStore
    }

    private var _managedObjectContext: NSManagedObjectContext?
    var managedObjectContext: NSManagedObjectContext {
        let managedObjectContext: NSManagedObjectContext
        if let _managedObjectContext = _managedObjectContext {
            managedObjectContext = _managedObjectContext
        } else {
            managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = self.coordinator
            self._managedObjectContext = managedObjectContext
        }
        return managedObjectContext
    }
    
    private var _coordinator: NSPersistentStoreCoordinator?
    var coordinator: NSPersistentStoreCoordinator? {
        var coordinator: NSPersistentStoreCoordinator
        if let _coordinator = _coordinator {
            coordinator = _coordinator
        } else {
            let persistentStoreURL = applicationDocumentsDirectory.appendingPathComponent("CourierMessage")
            printDebug("COURIER Message store at \(persistentStoreURL)")
            coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.createManagedObjectModel())
            let options: [String: Any] = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true,
                NSSQLiteManualVacuumOption: true,
                NSSQLiteAnalyzeOption: true
            ]
            
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
                self.resolvedStoreType = NSSQLiteStoreType
                self._coordinator = coordinator
            } catch {
                printDebug("COURIER Message Store -  Failed to initialize coordinator with SQLLiteStore type, fallback to inMemory instead")
                do {
                    coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.createManagedObjectModel())
                    try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: options)
                    self.resolvedStoreType = NSInMemoryStoreType
                    self._coordinator = coordinator
                } catch {
                    printDebug("COURIER Message Store -  Failed to initialize coordinator with inMemory store type")
                    return nil
                }
            }
        }
        return coordinator
    }
    
    func saveMessage(_ message: MQTTPacket) throws {
        var row: IncomingMessage?
        self.managedObjectContext.performAndWait {
            row =  NSEntityDescription.insertNewObject(forEntityName: "IncomingMessage", into: self.managedObjectContext) as? IncomingMessage
            row?.topic = message.topic
            row?.timestamp = message.timestamp
            row?.data = message.data
            row?.id = message.id
            row?.qosLevel = NSNumber(value: message.qos.rawValue)
        }
        
        if row == nil {
            throw CourierError.messageSaveError.asNSError
        }
            
        try self.sync()
        printDebug("COURIER Incoming Message - Successfully Saved message id: \(row?.id ?? "") topic: \(row?.topic ?? "") qos: \(row?.qosLevel.intValue ?? 0)")
    }
    
    func getAllMessages(_ topics: [String]) -> [MQTTPacket] {
        let fetchRequest = NSFetchRequest<IncomingMessage>(entityName: "IncomingMessage")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        if !topics.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "SELF.topic IN %@", topics)
        }
        var messages: [MQTTPacket] = []
        
        self.managedObjectContext.performAndWait {
            do {
                let results = try self.managedObjectContext.fetch(fetchRequest)
                messages = results.map {
                    MQTTPacket(id: $0.id, data: $0.data, topic: $0.topic, qos: QoS(rawValue: $0.qosLevel.intValue) ?? .zero, timestamp: $0.timestamp)
                }
                printDebug("COURIER Incoming Message - Successfully Fetched \(messages.count) message(s)")
            } catch {
                printDebug("COURIER Incoming Message - Failed to fetch messages \(error.localizedDescription)")
            }
        }
        return messages
    }
    
    func deleteMessages(_ ids: [String]) {
        guard !ids.isEmpty else {
            printDebug("COURIER Incoming Message - Cancel Deleting message as IDs are empty")
            return
        }
        deleteMessages(predicate: !ids.isEmpty ? NSPredicate(format: "SELF.id IN %@", ids) : nil)
    }
    
    func deleteMessagesWithOlderTimestamp(_ timestamp: Date) {
        deleteMessages(predicate: NSPredicate(format: "SELF.timestamp < %@", timestamp as CVarArg))
    }
    
    func deleteAllMessages() {
        deleteMessages(predicate: nil)
    }
}


extension IncomingMessagePersistence {
    
    private var applicationDocumentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func createManagedObjectModel() -> NSManagedObjectModel {
        let managedObjectModel = NSManagedObjectModel()
        var entities = [NSEntityDescription]()
        var properties = [NSAttributeDescription]()
        
        let qosAttributeDescription = NSAttributeDescription()
        qosAttributeDescription.name = "qosLevel"
        qosAttributeDescription.attributeType = .integer16AttributeType
        qosAttributeDescription.attributeValueClassName = "NSNumber"
        properties.append(qosAttributeDescription)
        
        let idAttributeDescription = NSAttributeDescription()
        idAttributeDescription.name = "id"
        idAttributeDescription.attributeType = .stringAttributeType
        idAttributeDescription.attributeValueClassName = "NSString"
        properties.append(idAttributeDescription)
        
        let topicAttributeDescription = NSAttributeDescription()
        topicAttributeDescription.name = "topic"
        topicAttributeDescription.attributeType = .stringAttributeType
        topicAttributeDescription.attributeValueClassName = "NSString"
        properties.append(topicAttributeDescription)
        
        let dataAttributeDescription = NSAttributeDescription()
        dataAttributeDescription.name = "data"
        dataAttributeDescription.attributeType = .binaryDataAttributeType
        dataAttributeDescription.attributeValueClassName = "NSData"
        properties.append(dataAttributeDescription)
        
        let timestampAttributeDescription = NSAttributeDescription()
        timestampAttributeDescription.name = "timestamp"
        timestampAttributeDescription.attributeType = .dateAttributeType;
        timestampAttributeDescription.attributeValueClassName = "NSDate"
        properties.append(timestampAttributeDescription)
        
        let entityDescription = NSEntityDescription()
        entityDescription.name = "IncomingMessage"
        entityDescription.managedObjectClassName = "IncomingMessage"
        entityDescription.isAbstract = false
        entityDescription.properties = properties
        
        entities.append(entityDescription)
        managedObjectModel.entities = entities
        return managedObjectModel
    }
    
    private func deleteMessages(predicate: NSPredicate?) {
        // Resolve the coordinator/context (populates `resolvedStoreType`) before deciding
        // which delete strategy is safe for the underlying store.
        let context = self.managedObjectContext

        if useSafeDeleteForNonSQLiteStore, resolvedStoreType != NSSQLiteStoreType {
            deleteMessagesUsingFetch(predicate: predicate, in: context)
        } else {
            deleteMessagesUsingBatchRequest(predicate: predicate, in: context)
        }
    }

    /// Original deletion path. `NSBatchDeleteRequest` is only supported by SQLite stores;
    /// executing it against the in-memory fallback store throws an uncatchable
    /// `NSInternalInconsistencyException` and crashes the app.
    private func deleteMessagesUsingBatchRequest(predicate: NSPredicate?, in context: NSManagedObjectContext) {
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            fetchRequest = NSFetchRequest(entityName: "IncomingMessage")
            if let predicate = predicate {
                fetchRequest.predicate = predicate
            }

            let deleteRequest = NSBatchDeleteRequest(
                fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs
            do {
                let batchDelete = try context.execute(deleteRequest) as? NSBatchDeleteResult
                guard let deleteResult = batchDelete?.result
                    as? [NSManagedObjectID]
                    else { return }

                let deletedObjects: [AnyHashable: Any] = [
                    NSDeletedObjectsKey: deleteResult
                ]

                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: deletedObjects,
                    into: [context]
                )
                try self.sync()
                printDebug("COURIER Incoming Message - Successfully deleted \(deleteResult.count) message(s)")
            } catch {
                printDebug("COURIER Incoming Message - Failed to delete")
            }
        }
    }

    /// Safe deletion path that works on every store type (used for the in-memory fallback
    /// store). Fetches matching objects and deletes them individually, then saves.
    private func deleteMessagesUsingFetch(predicate: NSPredicate?, in context: NSManagedObjectContext) {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<IncomingMessage>(entityName: "IncomingMessage")
            if let predicate = predicate {
                fetchRequest.predicate = predicate
            }
            do {
                let results = try context.fetch(fetchRequest)
                results.forEach { context.delete($0) }
                try self.sync()
                printDebug("COURIER Incoming Message - Successfully deleted \(results.count) message(s)")
            } catch {
                printDebug("COURIER Incoming Message - Failed to delete")
            }
        }
    }
    
    private func sync() throws {
        var _error: NSError?
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                } catch {
                    printDebug("COURIER Incoming Message - Failed to save \(error.localizedDescription)")
                    _error = error as NSError
                }
            }
        }
        
        if let error = _error {
            throw error
        }
    }
}

@objc(IncomingMessage)
final class IncomingMessage: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var qosLevel: NSNumber
    @NSManaged var topic: String
    @NSManaged var data: Data
    @NSManaged var timestamp: Date
}

