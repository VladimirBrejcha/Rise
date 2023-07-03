import Foundation
import Core
import Combine

public protocol ScheduleRepository {

    func get(for date: Date) -> Schedule?

    func getLatest() -> Schedule?

    func save(_ schedule: Schedule)

    func deleteAll()

    func publisher() -> AnyPublisher
    <([(LocalDataSourceObjectChange, Schedule)]), Never>
}
