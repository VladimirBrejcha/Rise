import UIKit
import LoadingView
import Core
import Localization

final class PermissionViewController: UIViewController, ViewController {
    typealias View = PermissionView
    private let out: Out
    
    enum OutCommand {
        case goToSettings
        case skip
    }
    
    init(out: @escaping Out) {
        self.out = out
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = PermissionView(goToSettingsAction: { [weak self] in
            self?.out(.goToSettings)
        }, skipAction: { [weak self] in
            self?.out(.skip)
        })
    }
}
