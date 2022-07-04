import UIKit

public protocol ViewController: UIViewController {
  associatedtype Deps = Void
  associatedtype Params = Void
  associatedtype OutCommand = Void
  associatedtype Out = (OutCommand) -> Void
  associatedtype View: UIView
}

public extension ViewController {
  var rootView: View {
    view as! View
  }
}
