import Foundation

public struct ALatFormat: ParseableFormatStyle {
    public var preferredFormat: ACoordinateFormat
    public var digits: Int
    public var parseStrategy = Strategy()

    public func format(_ value: Double) -> String {
        ALatitude(value, format: preferredFormat).toString(digits: digits)
    }

    public static func degrees(digits: Int = 7) -> Self {
        .init(preferredFormat: .degrees, digits: digits)
    }

    public static func dM(digits: Int = 1) -> Self {
        .init(preferredFormat: .degreesM, digits: digits)
    }

    public static func dMS(digits: Int = 1) -> Self {
        .init(preferredFormat: .degreesMS, digits: digits)
    }
}

public extension ALatFormat {
    struct Strategy: Codable, Hashable, ParseStrategy {
        public func parse(_ value: String) throws -> Double {
            let result = try ALatitude(value)
            let number = result.toNumber()
            guard number <= 90, number >= -90
            else {
                throw ACoordinateParsingError.notWithinRange
            }
            return result.toNumber()
        }
    }

    init(preferredFormat: ACoordinateFormat, digits: Int) {
        self.preferredFormat = preferredFormat
        self.digits = digits
    }

    init(_ preferredFormat: ACoordinateFormat) {
        switch preferredFormat {
        case .degrees:
            self = .degrees()
        case .degreesM:
            self = .dM()
        case .degreesMS:
            self = .dMS()
        }
    }
}
