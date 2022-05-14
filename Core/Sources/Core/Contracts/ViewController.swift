import UIKit

public protocol ViewController: UIViewController {
  associatedtype Deps
  associatedtype Params
  associatedtype OutCommand
  typealias Out = (OutCommand) -> Void
  associatedtype View: UIView
}

public extension ViewController {
  var rootView: View {
    view as! View
  }
}
