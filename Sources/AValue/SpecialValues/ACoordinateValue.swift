import Foundation

/// 表示经纬度格式的枚举
public enum ACoordinateValue: Codable, Sendable, Hashable, CustomStringConvertible {
    case latitude(isNorth: Bool, degrees: Double)
    case latitudeDM(isNorth: Bool, degrees: Int, minutes: Double)
    case latitudeDMS(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)
    case longitude(isEast: Bool, degrees: Double)
    case longitudeDM(isEast: Bool, degrees: Int, minutes: Double)
    case longitudeDMS(isEast: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    @Sendable
    public init(latitude: Double) {
        self = .latitude(isNorth: latitude >= 0, degrees: abs(latitude))
    }
    
    @Sendable
    public init(latitude: Double, format: Format) {
        let someValue: ACoordinateValue = .latitude(isNorth: latitude >= 0, degrees: abs(latitude))
        self = someValue.toFormat(format)
    }
    
    @Sendable
    public init(longitude: Double) {
        self = .longitude(isEast: longitude >= 0, degrees: abs(longitude))
    }
    
    @Sendable
    public init(longitude: Double, format: Format) {
        let someValue: ACoordinateValue = .longitude(isEast: longitude >= 0, degrees: abs(longitude))
        self = someValue.toFormat(format)
    }
    
    @Sendable
    public func isLatitude() -> Bool {
        switch self {
        case .latitude, .latitudeDM, .latitudeDMS: return true
        default: return false
        }
    }
    
    @Sendable
    public func isLongitude() -> Bool {
        return !self.isLatitude()
    }
    
    @Sendable
    public func toNumber() -> Double {
        switch self {
        case .latitude(let isNorth, let degrees): return isNorth ? degrees : -degrees
        case .latitudeDM(let isNorth, let degrees, let minutes):
            return isNorth ? Double(degrees) + minutes / 60.0 : -Double(degrees) - minutes / 60.0
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            return isNorth ? Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0 :
                -Double(degrees) - Double(minutes) / 60.0 - seconds / 3600.0
        case .longitude(let isEast, let degrees): return isEast ? degrees : -degrees
        case .longitudeDM(let isEast, let degrees, let minutes):
            return isEast ? Double(degrees) + minutes / 60.0 : -Double(degrees) - minutes / 60.0
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            return isEast ? Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0 :
                -Double(degrees) - Double(minutes) / 60.0 - seconds / 3600.0
        }
    }
}

public extension ACoordinateValue {
    @Sendable
    func normalized(digits: Int) -> Self {
        let scale = pow(10.0, Double(digits))
        switch self {
        case .latitudeDM(let isNorth, var degrees, var minutes):
            minutes = (minutes * scale).rounded() / scale
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .latitudeDM(isNorth: isNorth, degrees: degrees, minutes: minutes)
        case .latitudeDMS(let isNorth, var degrees, var minutes, var seconds):
            seconds = (seconds * scale).rounded() / scale
            if seconds >= 60 { minutes += 1; seconds -= 60 }
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: seconds)
        case .longitudeDM(let isEast, var degrees, var minutes):
            minutes = (minutes * scale).rounded() / scale
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .longitudeDM(isEast: isEast, degrees: degrees, minutes: minutes)
        case .longitudeDMS(let isEast, var degrees, var minutes, var seconds):
            seconds = (seconds * scale).rounded() / scale
            if seconds >= 60 { minutes += 1; seconds -= 60 }
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds)
        default: return self
        }
    }
    
    @Sendable
    func toString(digits: Int) -> String {
        let result = self.normalized(digits: digits)
        switch result {
        case .latitude(let isNorth, let degrees):
            return "\(isNorth ? "N" : "S")\(String(format: "%0\(digits + 3).\(digits)f", degrees))°"
        case .latitudeDM(let isNorth, let degrees, let minutes):
            return "\(isNorth ? "N" : "S")\(String(format: "%02d", degrees))°\(String(format: "%0\(digits + 3).\(digits)f", minutes))'"
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            return "\(isNorth ? "N" : "S")\(String(format: "%02d", degrees))°\(String(format: "%02d", minutes))'\(String(format: "%0\(digits + 3).\(digits)f", seconds))\""
        case .longitude(let isEast, let degrees):
            return "\(isEast ? "E" : "W")\(String(format: "%0\(digits + 4).\(digits)f", degrees))°"
        case .longitudeDM(let isEast, let degrees, let minutes):
            return "\(isEast ? "E" : "W")\(String(format: "%03d", degrees))°\(String(format: "%0\(digits + 3).\(digits)f", minutes))'"
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            return "\(isEast ? "E" : "W")\(String(format: "%03d", degrees))°\(String(format: "%02d", minutes))'\(String(format: "%0\(digits + 3).\(digits)f", seconds))\""
        }
    }
    
    var description: String {
        switch self.format {
        case .degrees:
            return self.toString(digits: 6)
        case .degreesM:
            return self.toString(digits: 1)
        case .degreesMS:
            return self.toString(digits: 1)
        }
    }
}

// MARK: - Formats

public extension ACoordinateValue {
    enum Format: Codable, Hashable, Sendable, CaseIterable {
        case degrees, degreesM, degreesMS
    }
    
    var format: Format {
        switch self {
        case .latitude, .longitude: return .degrees
        case .latitudeDM, .longitudeDM: return .degreesM
        case .latitudeDMS, .longitudeDMS: return .degreesMS
        }
    }

    @Sendable
    func toFormat(_ newFormat: Format) -> Self {
        switch newFormat {
        case .degrees: return self.toD()
        case .degreesM: return self.toDM()
        case .degreesMS: return self.toDMS()
        }
    }
    
    @Sendable
    func toD() -> ACoordinateValue {
        switch self {
        case .latitudeDM(let isNorth, let degrees, let minutes):
            return .latitude(isNorth: isNorth, degrees: Double(degrees) + minutes / 60.0)
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            return .latitude(isNorth: isNorth, degrees: Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0)
        case .longitudeDM(let isEast, let degrees, let minutes):
            return .longitude(isEast: isEast, degrees: Double(degrees) + minutes / 60.0)
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            return .longitude(isEast: isEast, degrees: Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0)
        default: return self
        }
    }
    
    @Sendable
    func toDM() -> ACoordinateValue {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            return .latitudeDM(isNorth: isNorth, degrees: degreesInt, minutes: (degrees - Double(degreesInt)) * 60.0)
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            return .latitudeDM(isNorth: isNorth, degrees: degrees, minutes: Double(minutes) + seconds / 60.0)
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            return .longitudeDM(isEast: isEast, degrees: degreesInt, minutes: (degrees - Double(degreesInt)) * 60.0)
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            return .longitudeDM(isEast: isEast, degrees: degrees, minutes: Double(minutes) + seconds / 60.0)
        default: return self
        }
    }
    
    @Sendable
    func toDMS() -> ACoordinateValue {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            return .latitudeDMS(isNorth: isNorth, degrees: degreesInt, minutes: minutesInt, seconds: (minutesDouble - Double(minutesInt)) * 60.0)
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let minutesInt = Int(minutes)
            return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutesInt, seconds: (minutes - Double(minutesInt)) * 60.0)
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            return .longitudeDMS(isEast: isEast, degrees: degreesInt, minutes: minutesInt, seconds: (minutesDouble - Double(minutesInt)) * 60.0)
        case .longitudeDM(let isEast, let degrees, let minutes):
            let minutesInt = Int(minutes)
            return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutesInt, seconds: (minutes - Double(minutesInt)) * 60.0)
        default: return self
        }
    }
}
