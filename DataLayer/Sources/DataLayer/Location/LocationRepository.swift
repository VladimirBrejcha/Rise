import Core

public protocol LocationRepository {
  func get(
    permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
    _ completion: @escaping (Result<Location, Error>) -> Void
  )
  func deleteAll()
}
