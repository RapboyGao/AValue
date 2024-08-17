import Foundation

public enum ALatitude: Codable, Sendable, Hashable, CustomStringConvertible {
    case degrees(isNorth: Bool, degrees: Double)
    case degreesMinutes(isNorth: Bool, degrees: Int, minutes: Double)
    case degreesMinutesSeconds(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)

    @Sendable
    public init(_ latitude: Double) {
        self = .degrees(isNorth: latitude >= 0, degrees: abs(latitude))
    }

    @Sendable
    public init(_ latitude: Double, format: ACoordinateFormat) {
        let someValue: ALatitude = .degrees(isNorth: latitude >= 0, degrees: abs(latitude))
        self = someValue.toFormat(format)
    }

    @Sendable
    public func toNumber() -> Double {
        switch self {
        case .degrees(let isNorth, let degrees):
            return isNorth ? degrees : -degrees
        case .degreesMinutes(let isNorth, let degrees, let minutes):
            return isNorth ? Double(degrees) + minutes / 60.0 : -Double(degrees) - minutes / 60.0
        case .degreesMinutesSeconds(let isNorth, let degrees, let minutes, let seconds):
            return isNorth ? Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0 :
                -Double(degrees) - Double(minutes) / 60.0 - seconds / 3600.0
        }
    }

    @Sendable
    public func normalized(digits: Int) -> Self {
        let scale = pow(10.0, Double(digits))
        switch self {
        case .degreesMinutes(let isNorth, var degrees, var minutes):
            minutes = (minutes * scale).rounded() / scale
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutes(isNorth: isNorth, degrees: degrees, minutes: minutes)
        case .degreesMinutesSeconds(let isNorth, var degrees, var minutes, var seconds):
            seconds = (seconds * scale).rounded() / scale
            if seconds >= 60 { minutes += 1; seconds -= 60 }
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutesSeconds(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: seconds)
        default:
            return self
        }
    }

    @Sendable
    public func toString(digits: Int) -> String {
        let result = self.normalized(digits: digits)
        switch result {
        case .degrees(let isNorth, let degrees):
            return "\(isNorth ? "N" : "S")\(String(format: "%0\(digits + 3).\(digits)f", degrees))°"
        case .degreesMinutes(let isNorth, let degrees, let minutes):
            return "\(isNorth ? "N" : "S")\(String(format: "%02d", degrees))°\(String(format: "%0\(digits + 3).\(digits)f", minutes))'"
        case .degreesMinutesSeconds(let isNorth, let degrees, let minutes, let seconds):
            return "\(isNorth ? "N" : "S")\(String(format: "%02d", degrees))°\(String(format: "%02d", minutes))'\(String(format: "%0\(digits + 3).\(digits)f", seconds))\""
        }
    }

    public var description: String {
        switch self.format {
        case .degrees:
            return self.toString(digits: 6)
        case .degreesM:
            return self.toString(digits: 1)
        case .degreesMS:
            return self.toString(digits: 1)
        }
    }

    public var format: ACoordinateFormat {
        switch self {
        case .degrees:
            return .degrees
        case .degreesMinutes:
            return .degreesM
        case .degreesMinutesSeconds:
            return .degreesMS
        }
    }

    @Sendable
    public func toFormat(_ newFormat: ACoordinateFormat) -> Self {
        switch newFormat {
        case .degrees:
            return self.toD()
        case .degreesM:
            return self.toDM()
        case .degreesMS:
            return self.toDMS()
        }
    }

    @Sendable
    public func toD() -> ALatitude {
        switch self {
        case .degreesMinutes(let isNorth, let degrees, let minutes):
            return .degrees(isNorth: isNorth, degrees: Double(degrees) + minutes / 60.0)
        case .degreesMinutesSeconds(let isNorth, let degrees, let minutes, let seconds):
            return .degrees(isNorth: isNorth, degrees: Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0)
        default:
            return self
        }
    }

    @Sendable
    public func toDM() -> ALatitude {
        switch self {
        case .degrees(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            return .degreesMinutes(isNorth: isNorth, degrees: degreesInt, minutes: (degrees - Double(degreesInt)) * 60.0)
        case .degreesMinutesSeconds(let isNorth, let degrees, let minutes, let seconds):
            return .degreesMinutes(isNorth: isNorth, degrees: degrees, minutes: Double(minutes) + seconds / 60.0)
        default:
            return self
        }
    }

    @Sendable
    public func toDMS() -> ALatitude {
        switch self {
        case .degrees(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            return .degreesMinutesSeconds(isNorth: isNorth, degrees: degreesInt, minutes: minutesInt, seconds: (minutesDouble - Double(minutesInt)) * 60.0)
        case .degreesMinutes(let isNorth, let degrees, let minutes):
            let minutesInt = Int(minutes)
            return .degreesMinutesSeconds(isNorth: isNorth, degrees: degrees, minutes: minutesInt, seconds: (minutes - Double(minutesInt)) * 60.0)
        default:
            return self
        }
    }
}
