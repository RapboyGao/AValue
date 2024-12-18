import Foundation

public enum AHMParseError: Error {
    case failedToParse
}

public struct AHMFormat: ParseableFormatStyle {
    public var format: AHourMinuteValue.Format
    public var parseStrategy: Strategy

    public func format(_ value: Int) -> String {
        guard value != 0 else { return "" }
        return AHourMinuteValue(minutes: value).toFormat(format).description
    }

    public struct Strategy: ParseStrategy {
        public func parse(_ value: String) throws -> Int {
            guard let parsed = [AHourMinuteValue](value)
            else {
                throw AHMParseError.failedToParse
            }
            return parsed.sum(format: .days24HM).toNumber()
        }
    }

    public init(format: AHourMinuteValue.Format) {
        self.format = format
        self.parseStrategy = Strategy()
    }
}
