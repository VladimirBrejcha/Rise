import CoreData

extension RiseLocation {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseLocation> {
    return NSFetchRequest<RiseLocation>(entityName: String(describing: RiseLocation.self))
  }

  @NSManaged public var latitude: String
  @NSManaged public var longitude: String
}
