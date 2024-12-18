import Foundation

public enum ACoordinateFormat: Codable, Hashable, Sendable, CaseIterable {
    case degrees, degreesM, degreesMS

    public var nextFormat: Self {
        switch self {
        case .degrees:
            return .degreesM
        case .degreesM:
            return .degreesMS
        case .degreesMS:
            return .degrees
        }
    }
}

// 定义初始化错误的枚举
public enum ACoordinateParsingError: Error {
    case invalidFormat
    case errorWhenParsingNumber
    case notWithinRange
    case stringNotProvided
}
