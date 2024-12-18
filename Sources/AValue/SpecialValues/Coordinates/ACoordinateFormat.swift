import Foundation

public enum ACoordinateFormat: Codable, Hashable, Sendable, CaseIterable {
    case degrees, degreesM, degreesMS
}

// 定义初始化错误的枚举
public enum ACoordinateParsingError: Error {
    case invalidFormat
    case errorWhenParsingNumber
    case notWithinRange
}
