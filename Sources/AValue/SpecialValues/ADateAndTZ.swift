import Foundation

public struct ADateAndTZ: Codable, Sendable, Hashable, CustomStringConvertible {
    public var date: Date
    public var timeZone: TimeZone?

    public init(date: Date, timeZone: TimeZone? = nil) {
        self.date = date
        self.timeZone = timeZone
    }

    public var description: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.timeZone = timeZone
        let dateString = formatter.string(from: date)
        if let timeZone = timeZone {
            let timeZoneOffset = timeZone.secondsFromGMT(for: date) / 3600
            return "\(dateString) (\(timeZoneOffset >= 0 ? "+" : "")\(timeZoneOffset))"
        } else {
            return dateString
        }
    }
}
