import Foundation

public protocol Refreshable {
    associatedtype DataType
    func refresh(with data: DataType)
}

public protocol AutoRefreshable: AnyObject, Refreshable {
    var timer: Timer? { get set }
    var dataSource: (() -> DataType)? { get set }
    var refreshInterval: Double { get set }
}

public extension AutoRefreshable {
    func beginRefreshing() {
        guard let dataSource = dataSource else {
            log(.error, "AutoRefreshable.beginRefreshing failed, dataSource was nil")
            return
        }
        if timer != nil { releaseTimer() }
        refresh(with: dataSource())
        timer = Timer.scheduledTimer(
            withTimeInterval: refreshInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.refresh(with: dataSource())
        }
    }

    func stopRefreshing() {
        releaseTimer()
    }

    private func releaseTimer() {
        timer?.invalidate()
        timer = nil
    }
}
