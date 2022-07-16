import CoreData
import Core

class LocalDataSource<Object: NSManagedObject> {
  
  lazy var container: PersistentContainer<Object> = {
    guard let url = Bundle.module.url(forResource: containerName, withExtension: "momd") else {
      fatalError("Failed to locate momd bundle in application")
    }
    guard let mom = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to initialize mom from URL: \(String(describing: url))")
    }
    let container = PersistentContainer<Object>(name: containerName, managedObjectModel: mom)
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Unable to load persistent stores: \(error)")
      }
    }
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
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    try context.execute(deleteRequest)
    try context.save()
  }
}
