//
//  Logger.swift
//  messager
//
//  Created by vladislav dudevich on 14.12.2020.
//

import UIKit

final class Logger {
    
    enum LogEvent: String {
        case error = "⚠️"
        case verbose = "💬"
        case important = "🔥"
        case veryImportant = "🔥🔥"
        case critical = "🔥🔥🔥"
        case development = "d"
    }
    
    // MARK: - Static members
    static var logLevel: LogEvent? = .verbose
    static var dateFormat = "HH:mm:ssSSS"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    /// Logs to console
    /// - Parameters:
    ///   - something: something to log
    ///   - event: event level
    ///   - fileName: filename where logging occures
    ///   - line: code line where logging occures
    ///   - column: code column where logging occures
    ///   - funcName: function name where logging occures
    
    static func log(_ something: Any?...,
                    event: LogEvent = .verbose,
                    fileName: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    funcName: String = #function) {
        
        let message: String
        if something.count == 1,
           let someString = something.first as? String {
            message = "\(now()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(funcName) -> \(someString)"
        } else {
            let description = String(describing: something)
            message = "\(now()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(funcName) -> \(description)"
        }
        #if DEBUG
        print(message)
        #endif
        if event == .important || event == .veryImportant || event == .critical {
            
        }
    }
    
    /// Log to firebase
    class func write(string: String) {
        
    }
    
    private class func sourceFileName(filePath: String) -> String {
        return (filePath as NSString).lastPathComponent
    }
    
    static func now() -> String {
        return dateFormatter.string(from: Date())
    }
}
