//
//  Log.swift
//  agent-iOS
//
//  Created by Matt on 2021/3/3.
//  Copyright © 2021 深圳市看房网科技有限公司. All rights reserved.
//

import Foundation

/// 日志级别
public enum LogLevel: Int {
    /// 无，打印任何信息
    case none
    /// 只打印错误信息
    case error
    /// 打印警告和错误信息
    case warn
    /// 打印警告、错误、调试信息
    case verbose
}


public struct Logger {
    
    public init(lowerLevel level: LogLevel, prefixMap: [LogLevel : String]) {
        self.level = level
        self.prefixMap = prefixMap
    }
    
    public var level: LogLevel
    public var prefixMap: [LogLevel: String]
    
    var prefix: String {
        return prefixMap[self.level] ?? ""
    }
    
    public func log(_ level: LogLevel = .verbose, args: Any...) {
        if level <= self.level && level != .none {
            let text: String = {
                if args.count == 1 {
                    if let items = args[0] as? [Any] {
                        if items.count == 1 {
                            return "\(items[0])"
                        }
                    }
                    return "\(args[0])"
                }
                return "\(args)"
            }()
            
            Swift.print("\(self.prefix) \(text)")
        }
    }
}

// MARK: - - prefix text
fileprivate let defaultPrefixMap: [LogLevel: String] = [
    .none: "",
    .error: "❌❌ ==> ",
    .warn: "⚠️⚠️ ==> ",
    .verbose: "📝📝 ==> "
]

// MARK: - - equalable
extension LogLevel {
    static func <= (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
}


/// 打印信息
public func logInfo(by logger: Logger? = nil, _ text: Any...) {
    let logger = logger ?? Logger(lowerLevel: .verbose, prefixMap: defaultPrefixMap)
    logger.log(.verbose, args: text)
}

/// 打印警告
public func logWarning(by logger: Logger? = nil, _ text: Any...) {
    let logger = logger ?? Logger(lowerLevel: .warn, prefixMap: defaultPrefixMap)
    logger.log(.warn, args: text)
}

/// 打印错误
public func logError(by logger: Logger? = nil, _ text: Any...) {
    let logger = logger ?? Logger(lowerLevel: .error, prefixMap: defaultPrefixMap)
    logger.log(.error, args: text)
}
