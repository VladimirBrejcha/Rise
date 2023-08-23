import CoreData
import Core
import Combine

public enum LocalDataSourceObjectChange { case insert, update, delete }

class LocalDataSource<Object: NSManagedObject> {

    lazy var container: PersistentContainer<Object> = {
        guard let url = Bundle.module.url(forResource: containerName, withExtension: "momd") else {
            fatalError("Failed to locate momd bundle in application")
        }
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to initialize mom from URL: \(String(describing: url))")
        }
        let container = PersistentContainer<Object>(
            name: containerName, managedObjectModel: mom
        )
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        // Only initialize the schema when building the app with the
        // Debug build configuration.
        #if DEBUG
//        do {
//            try container.initializeCloudKitSchema(options: [])
//        } catch let error {
//            assertionFailure("Unable to initCloudKitSchema: \(error.localizedDescription)")
//        }
        #endif
        return container
    }()

    private let containerName: String

    var context: NSManagedObjectContext { container.viewContext }
    let entityName: String = String(describing: Object.self)

    required init(containerName: String) {
        self.containerName = containerName
    }

    func insertObject() -> Object {
        NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Object
    }

    func deleteAll() throws {
        log(.info)
        let fetchRequest = NSFetchRequest<Object>(entityName: entityName)
        let objects = try context.fetch(fetchRequest)
        for object in objects {
            context.delete(object)
        }
        try container.saveContext()
    }

    func publisher<T: NSManagedObject>(
        for managedObjectType: T.Type
    ) -> AnyPublisher<([(LocalDataSourceObjectChange, T)]), Never> {
        let notification = NSManagedObjectContext.didChangeObjectsNotification
        return NotificationCenter.default.publisher(
            for: notification,
            object: context
        )
        .compactMap({ notification in
            var result: [(LocalDataSourceObjectChange, T)] = []
            if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? Set<T> {
                result.append(
                    contentsOf: updated.map {
                        (LocalDataSourceObjectChange.update, $0)
                    }
                )
            }
            if let deleted = notification.userInfo?[NSDeletedObjectsKey] as? Set<T> {
                result.append(
                    contentsOf: deleted.map {
                        (LocalDataSourceObjectChange.delete, $0)
                    }
                )
            }
            if let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<T> {
                result.append(
                    contentsOf: inserted.map {
                        (LocalDataSourceObjectChange.insert, $0)
                    }
                )
            }
            return result
        })
        .eraseToAnyPublisher()
    }
}
