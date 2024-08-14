import Foundation

// 枚举定义，表示经纬度的不同格式
enum ACoordinateFormat: Codable, Sendable, Hashable {
    // 仅度数表示的纬度
    case latitude(isNorth: Bool, degrees: Double)
    // 度分表示的纬度
    case latitudeDM(isNorth: Bool, degrees: Int, minutes: Double)
    // 度分秒表示的纬度
    case latitudeDMS(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    // 仅度数表示的经度
    case longitude(isEast: Bool, degrees: Double)
    // 度分表示的经度
    case longitudeDM(isEast: Bool, degrees: Int, minutes: Double)
    // 度分秒表示的经度
    case longitudeDMS(isEast: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    // 使用十进制度数初始化纬度
    public init(latitude: Double) {
        self = .latitude(isNorth: latitude >= 0, degrees: abs(latitude))
    }
    
    // 使用十进制度数初始化经度
    public init(longitude: Double) {
        self = .longitude(isEast: longitude >= 0, degrees: abs(longitude))
    }
    
    // 判断当前是否为纬度
    func isLatitude() -> Bool {
        switch self {
        case .latitude, .latitudeDM, .latitudeDMS:
            return true
        case .longitude, .longitudeDM, .longitudeDMS:
            return false
        }
    }
    
    // 判断当前是否为经度
    func isLongitude() -> Bool {
        !isLatitude()
    }
    
    // 将当前坐标转换为十进制度数格式
    func toD() -> ACoordinateFormat {
        switch self {
        case .latitude, .longitude:
            return self
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return .latitude(isNorth: isNorth, degrees: degreesDouble)
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
            return .latitude(isNorth: isNorth, degrees: degreesDouble)
        case .longitudeDM(let isEast, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return .longitude(isEast: isEast, degrees: degreesDouble)
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
            return .longitude(isEast: isEast, degrees: degreesDouble)
        }
    }
    
    // 将当前坐标转换为度分格式
    func toDM() -> ACoordinateFormat {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutes = (degrees - Double(degreesInt)) * 60.0
            return .latitudeDM(isNorth: isNorth, degrees: degreesInt, minutes: minutes)
        case .latitudeDM, .longitudeDM:
            return self
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            let totalMinutes = Double(minutes) + seconds / 60.0
            return .latitudeDM(isNorth: isNorth, degrees: degrees, minutes: totalMinutes)
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutes = (degrees - Double(degreesInt)) * 60.0
            return .longitudeDM(isEast: isEast, degrees: degreesInt, minutes: minutes)
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            let totalMinutes = Double(minutes) + seconds / 60.0
            return .longitudeDM(isEast: isEast, degrees: degrees, minutes: totalMinutes)
        }
    }
    
    // 将当前坐标转换为度分秒格式
    func toDMS() -> ACoordinateFormat {
        switch self {
        case .latitude(let isNorth, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            let seconds = (minutesDouble - Double(minutesInt)) * 60.0
            return .latitudeDMS(isNorth: isNorth, degrees: degreesInt, minutes: minutesInt, seconds: seconds)
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let minutesInt = Int(minutes)
            let seconds = (minutes - Double(minutesInt)) * 60.0
            return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutesInt, seconds: seconds)
        case .latitudeDMS, .longitudeDMS:
            return self
        case .longitude(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            let seconds = (minutesDouble - Double(minutesInt)) * 60.0
            return .longitudeDMS(isEast: isEast, degrees: degreesInt, minutes: minutesInt, seconds: seconds)
        case .longitudeDM(let isEast, let degrees, let minutes):
            let minutesInt = Int(minutes)
            let seconds = (minutes - Double(minutesInt)) * 60.0
            return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutesInt, seconds: seconds)
        }
    }
    
    // 将坐标格式转换为十进制度数，并返回结果
    func toNumber() -> Double {
        switch self {
        // 处理纬度格式
        case .latitude(let isNorth, let degrees):
            return isNorth ? degrees : -degrees
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return isNorth ? degreesDouble : -degreesDouble
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
            return isNorth ? degreesDouble : -degreesDouble
        // 处理经度格式
        case .longitude(let isEast, let degrees):
            return isEast ? degrees : -degrees
        case .longitudeDM(let isEast, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return isEast ? degreesDouble : -degreesDouble
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
            return isEast ? degreesDouble : -degreesDouble
        }
    }
}
