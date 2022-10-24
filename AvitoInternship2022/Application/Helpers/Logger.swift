//
//  Logger.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import Foundation
import os

final class DebugLogger {
    private static let osLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "AvitoInternshipApp", category: "DebugLogs")

    static func log(type: OSLogType, message: String) {
        os_log(type, log: osLog, "%{public}@", type.emoji() + " " + message)
    }
}

extension OSLogType {
    func emoji() -> String {
        switch self {
        case .debug:
            return "🔬"
        case .info:
            return "💡"
        case .error:
            return "💥"
        case .fault:
            return "⚠️"
        default:
            return "🔵"
        }
    }
}
