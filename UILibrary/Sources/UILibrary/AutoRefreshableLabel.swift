import UIKit
import Core

public final class AutoRefreshableLabel: UILabel, AutoRefreshable {

    public var timer: Timer?
    public var dataSource: (() -> String)?
    public var refreshInterval: Double = 1
    
    public func refresh(with data: String) { text = data }
}
