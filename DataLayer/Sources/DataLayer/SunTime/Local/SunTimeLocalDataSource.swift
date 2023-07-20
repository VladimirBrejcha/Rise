import Foundation
import Core

protocol SunTimeLocalDataSource {
  func getSunTimes(for dates: [Date]) throws -> [SunTime]
  func save(sunTimes: [SunTime]) throws
  func deleteAll() throws
  func delete(before date: Date) throws
}
