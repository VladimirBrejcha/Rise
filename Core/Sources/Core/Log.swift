import Foundation

public enum LogType {
  case error
  case warning
  case info
  
  var prefix: String {
    switch self {
    case .error:
      return "R_E"
    case .warning:
      return "R_W"
    case .info:
      return "R_I"
    }
  }
}

public func log(
  _ type: LogType,
  _ message: String? = nil,
  _ file: String = #file,
  _ line: Int = #line,
  _ function: String = #function
) {
  if let message = message {
    print("\(file.onlyFileName):\(line) - \(function) \n\(message) \n")
  } else {
    print("\(file.onlyFileName):\(line) - \(function)")
  }
}

extension String {
  var onlyFileName: String {
    URL(fileURLWithPath: self, isDirectory: false).lastPathComponent
  }
}
