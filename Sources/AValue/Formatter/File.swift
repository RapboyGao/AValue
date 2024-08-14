import Foundation

enum ACoordinateFormat: Codable, Sendable, Hashable {
    case latitude(isNorth: Bool, degrees: Double)
    case latitudeWithMinutes(isNorth: Bool, degrees: Int, minutes: Double)
    case latitudeWithDMS(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    case longitude(isEast: Bool, degrees: Double)
    case longitudeWithMinutes(isEast: Bool, degrees: Int, minutes: Double)
    case longitudeWithDMS(isEast: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    public init(latitude: Double) {
        self = .latitude(isNorth: latitude >= 0, degrees: abs(latitude))
    }
    
    public init(longitude: Double) {
        self = .longitude(isEast: longitude >= 0, degrees: abs(longitude))
    }
    
    func isLatitude() -> Bool {
        switch self {
        case .latitude, .latitudeWithMinutes, .latitudeWithDMS:
            return true
        case .longitude, .longitudeWithMinutes, .longitudeWithDMS:
            return false
        }
    }
    
    func isLongitude() -> Bool {
        !isLatitude()
    }
    
    func toD() -> ACoordinateFormat {
        switch self {
        case .latitude(let isNorth, let degrees):
            return .latitude(isNorth: isNorth, degrees: degrees)
        case .latitudeWithMinutes(let isNorth, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return .latitude(isNorth: isNorth, degrees: degreesDouble)
        case .latitudeWithDMS(let isNorth, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes / 60) + (seconds / 3600.0)
            return .latitude(isNorth: isNorth, degrees: degreesDouble)
        case .longitude(let isEast, let degrees):
            return self
        case .longitudeWithMinutes(let isEast, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return .longitude(isEast: isEast, degrees: degreesDouble)
        case .longitudeWithDMS(let isEast, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes / 60) + (seconds / 3600.0)
            return self
        }
    }
    
    func toDM() -> ACoordinateFormat {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutes = (degrees - Double(degreesInt)) * 60.0
            return .latitudeWithMinutes(isNorth: isNorth, degrees: degreesInt, minutes: minutes)
        case .latitudeWithMinutes(let isNorth, let degrees, let minutes):
            return self
        case .latitudeWithDMS(let isNorth, let degrees, let minutes, let seconds):
            let totalMinutes = Double(minutes) + seconds / 60.0
            return .latitudeWithMinutes(isNorth: isNorth, degrees: degrees, minutes: totalMinutes)
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutes = (degrees - Double(degreesInt)) * 60.0
            return .longitudeWithMinutes(isEast: isEast, degrees: degreesInt, minutes: minutes)
        case .longitudeWithMinutes(let isEast, let degrees, let minutes):
            return self
        case .longitudeWithDMS(let isEast, let degrees, let minutes, let seconds):
            let totalMinutes = Double(minutes) + seconds / 60.0
            return .longitudeWithMinutes(isEast: isEast, degrees: degrees, minutes: totalMinutes)
        }
    }
    
    func toDMS() -> ACoordinateFormat {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            let seconds = (minutesDouble - Double(minutesInt)) * 60.0
            return .latitudeWithDMS(isNorth: isNorth, degrees: degreesInt, minutes: minutesInt, seconds: seconds)
        case .latitudeWithMinutes(let isNorth, let degrees, let minutes):
            let minutesInt = Int(minutes)
            let seconds = (minutes - Double(minutesInt)) * 60.0
            return .latitudeWithDMS(isNorth: isNorth, degrees: degrees, minutes: minutesInt, seconds: seconds)
        case .latitudeWithDMS(let isNorth, let degrees, let minutes, let seconds):
            return self
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            let seconds = (minutesDouble - Double(minutesInt)) * 60.0
            return .longitudeWithDMS(isEast: isEast, degrees: degreesInt, minutes: minutesInt, seconds: seconds)
        case .longitudeWithMinutes(let isEast, let degrees, let minutes):
            let minutesInt = Int(minutes)
            let seconds = (minutes - Double(minutesInt)) * 60.0
            return .longitudeWithDMS(isEast: isEast, degrees: degrees, minutes: minutesInt, seconds: seconds)
        case .longitudeWithDMS(let isEast, let degrees, let minutes, let seconds):
            return self
        }
    }
}
