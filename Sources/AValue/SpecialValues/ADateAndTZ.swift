import Foundation

public struct ADateAndTZ: Codable, Sendable, Hashable, CustomStringConvertible {
    public var date: Date
    public var timeZone: TimeZone?
    
    public init(date: Date, timeZone: TimeZone? = nil) {
        self.date = date
        self.timeZone = timeZone
    }
    
    public var description: String {
        let timeZoneDescription = timeZone?.description ?? "nil"
        return "ADateAndTZ(date: \(date), timeZone: \(timeZoneDescription))"
    }
}
