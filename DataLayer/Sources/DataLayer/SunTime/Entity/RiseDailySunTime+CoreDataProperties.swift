import CoreData

extension RiseSunTime {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseSunTime> {
    NSFetchRequest<RiseSunTime>(entityName: String(describing: RiseSunTime.self))
  }
  @NSManaged public var sunrise: Date
  @NSManaged public var sunset: Date
}
