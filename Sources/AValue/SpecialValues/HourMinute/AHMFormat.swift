import Foundation

public enum AHMParseError: Error {
    case failedToParse
}

public struct AHMFormat: ParseableFormatStyle {
    public var format: AHourMinuteValue.Format
    public var parseStrategy: Strategy
    public var emptyWhenZero = true

    public func format(_ value: Int) -> String {
        if emptyWhenZero && value == 0 {
            return ""
        } else {
            return AHourMinuteValue(minutes: value).toFormat(format).description
        }
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

    public static func notEmpty(_ format: AHourMinuteValue.Format) -> Self {
        var result = AHMFormat(format: format)
        result.emptyWhenZero = false
        return result
    }
}
