import UIKit

public protocol HasPreventAppSleepUseCase {
    var preventAppSleep: PreventAppSleep { get }
}

public protocol PreventAppSleep {
    func callAsFunction(_ prevent: Bool)
}

final class PreventAppSleepImpl: PreventAppSleep {
    func callAsFunction(_ prevent: Bool) {
        UIApplication.shared.isIdleTimerDisabled = prevent
    }
}
