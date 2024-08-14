import Foundation

/// 枚举定义，表示经纬度的不同格式
public enum ACoordinateValue: Codable, Sendable, Hashable {
    /// 仅度数表示的纬度
    case latitude(isNorth: Bool, degrees: Double)
    /// 度分表示的纬度
    case latitudeDM(isNorth: Bool, degrees: Int, minutes: Double)
    /// 度分秒表示的纬度
    case latitudeDMS(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    /// 仅度数表示的经度
    case longitude(isEast: Bool, degrees: Double)
    /// 度分表示的经度
    case longitudeDM(isEast: Bool, degrees: Int, minutes: Double)
    /// 度分秒表示的经度
    case longitudeDMS(isEast: Bool, degrees: Int, minutes: Int, seconds: Double)
    
    /// 使用十进制度数初始化纬度
    @Sendable
    public init(latitude: Double) {
        self = .latitude(isNorth: latitude >= 0, degrees: abs(latitude))
    }
    
    /// 使用十进制度数初始化经度
    @Sendable
    public init(longitude: Double) {
        self = .longitude(isEast: longitude >= 0, degrees: abs(longitude))
    }
    
    /// 判断当前是否为纬度
    @Sendable
    public func isLatitude() -> Bool {
        switch self {
        case .latitude, .latitudeDM, .latitudeDMS:
            return true
        case .longitude, .longitudeDM, .longitudeDMS:
            return false
        }
    }
    
    /// 判断当前是否为经度
    @Sendable
    public func isLongitude() -> Bool {
        !isLatitude()
    }
    
    /// 将当前坐标转换为十进制度数格式
    @Sendable
    public func toD() -> ACoordinateValue {
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
    
    /// 将当前坐标转换为度分格式
    @Sendable
    public func toDM() -> ACoordinateValue {
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
    
    /// 将当前坐标转换为度分秒格式
    @Sendable
    public func toDMS() -> ACoordinateValue {
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
    
    /// 将坐标格式转换为十进制度数，并返回结果
    @Sendable
    public func toNumber() -> Double {
        switch self {
        /// 处理纬度格式
        case .latitude(let isNorth, let degrees):
            return isNorth ? degrees : -degrees
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let degreesDouble = Double(degrees) + minutes / 60.0
            return isNorth ? degreesDouble : -degreesDouble
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            let degreesDouble = Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
            return isNorth ? degreesDouble : -degreesDouble
        /// 处理经度格式
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
    
    /// 规范化处理经纬度值，将分钟或秒的值调整到指定的小数位数
    /// - Parameter digits: 保留的小数位数
    /// - Returns: 返回处理后的坐标值，如果分钟或秒的值超过了60，则会将其转换成相应的度数
    @Sendable
    func normalized(digits: Int) -> Self {
        switch self {
        case .latitude:
            // 对于只有度数的纬度，直接返回原值，无需规范化处理
            return self
        case .latitudeDM(let isNorth, var degrees, var lastValue):
            // 计算需要保留的小数位数的缩放因子
            let scale = pow(10.0, Double(digits))
            // 对分钟进行四舍五入处理
            lastValue = (lastValue * scale).rounded() / scale
            // 如果分钟值小于60，则返回原值
            guard lastValue >= 60 else {
                return .latitudeDM(isNorth: isNorth, degrees: degrees, minutes: lastValue)
            }
            // 如果分钟值大于等于60，则将多余的部分转换为度数
            lastValue -= 60
            degrees += 1
            return .latitudeDM(isNorth: isNorth, degrees: degrees, minutes: lastValue)
        case .latitudeDMS(let isNorth, var degrees, var minutes, var lastValue):
            // 计算需要保留的小数位数的缩放因子
            let scale = pow(10.0, Double(digits))
            // 对秒进行四舍五入处理
            lastValue = (lastValue * scale).rounded() / scale
            // 如果秒值小于60，则返回原值
            guard lastValue >= 60 else {
                return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: lastValue)
            }
            // 如果秒值大于等于60，则将多余的部分转换为分钟
            lastValue -= 60
            minutes += 1
            // 如果分钟值大于等于60，则将多余的部分转换为度数
            guard minutes >= 60 else {
                return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: lastValue)
            }
            minutes -= 60
            degrees += 1
            return .latitudeDMS(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: lastValue)
        case .longitude:
            // 对于只有度数的经度，直接返回原值，无需规范化处理
            return self
        case .longitudeDM(let isEast, var degrees, var lastValue):
            // 计算需要保留的小数位数的缩放因子
            let scale = pow(10.0, Double(digits))
            // 对分钟进行四舍五入处理
            lastValue = (lastValue * scale).rounded() / scale
            // 如果分钟值小于60，则返回原值
            guard lastValue >= 60 else {
                return .longitudeDM(isEast: isEast, degrees: degrees, minutes: lastValue)
            }
            // 如果分钟值大于等于60，则将多余的部分转换为度数
            lastValue -= 60
            degrees += 1
            return .longitudeDM(isEast: isEast, degrees: degrees, minutes: lastValue)
        case .longitudeDMS(let isEast, var degrees, var minutes, var lastValue):
            // 计算需要保留的小数位数的缩放因子
            let scale = pow(10.0, Double(digits))
            // 对秒进行四舍五入处理
            lastValue = (lastValue * scale).rounded() / scale
            // 如果秒值小于60，则返回原值
            guard lastValue >= 60 else {
                return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutes, seconds: lastValue)
            }
            // 如果秒值大于等于60，则将多余的部分转换为分钟
            lastValue -= 60
            minutes += 1
            // 如果分钟值大于等于60，则将多余的部分转换为度数
            guard minutes >= 60 else {
                return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutes, seconds: lastValue)
            }
            minutes -= 60
            degrees += 1
            return .longitudeDMS(isEast: isEast, degrees: degrees, minutes: minutes, seconds: lastValue)
        }
    }
    
    @Sendable
    func toString(digits: Int) -> String {
        let result = normalized(digits: digits) // 规范化处理经纬度值
        switch result {
        case .latitude(let isNorth, let degrees):
            let prefix = isNorth ? "N" : "S" // 纬度的前缀，北纬用“N”，南纬用“S”
            let degreeString = String(format: "%0\(digits + 3).\(digits)f", degrees) // 格式化度数，保留指定的小数位
            return "\(prefix)\(degreeString)°" // 返回格式化后的纬度字符串
            
        case .latitudeDM(let isNorth, let degrees, let minutes):
            let prefix = isNorth ? "N" : "S" // 纬度的前缀
            let degreeString = String(format: "%02d", degrees) // 格式化整数度数部分
            let minuteString = String(format: "%0\(digits + 3).\(digits)f", minutes) // 格式化分钟部分，保留指定的小数位
            return "\(prefix)\(degreeString)°\(minuteString)'" // 返回格式化后的度分格式纬度字符串
            
        case .latitudeDMS(let isNorth, let degrees, let minutes, let seconds):
            let prefix = isNorth ? "N" : "S" // 纬度的前缀
            let degreeString = String(format: "%02d", degrees) // 格式化度数
            let minuteString = String(format: "%02d", minutes) // 格式化分钟部分
            let secondString = String(format: "%0\(digits + 3).\(digits)f", seconds) // 格式化秒数部分，保留指定的小数位
            return "\(prefix)\(degreeString)°\(minuteString)'\(secondString)\"" // 返回格式化后的度分秒格式纬度字符串
            
        case .longitude(let isEast, let degrees):
            let prefix = isEast ? "E" : "W" // 经度的前缀，东经用“E”，西经用“W”
            let degreeString = String(format: "%0\(digits + 4).\(digits)f", degrees) // 格式化度数，保留指定的小数位
            return "\(prefix)\(degreeString)°" // 返回格式化后的经度字符串
            
        case .longitudeDM(let isEast, let degrees, let minutes):
            let prefix = isEast ? "E" : "W" // 经度的前缀
            let degreeString = String(format: "%03d", degrees) // 格式化整数度数部分
            let minuteString = String(format: "%0\(digits + 3).\(digits)f", minutes) // 格式化分钟部分，保留指定的小数位
            return "\(prefix)\(degreeString)°\(minuteString)'" // 返回格式化后的度分格式经度字符串
            
        case .longitudeDMS(let isEast, let degrees, let minutes, let seconds):
            let prefix = isEast ? "E" : "W" // 经度的前缀
            let degreeString = String(format: "%03d", degrees) // 格式化度数
            let minuteString = String(format: "%02d", minutes) // 格式化分钟部分
            let secondString = String(format: "%0\(digits + 3).\(digits)f", seconds) // 格式化秒数部分，保留指定的小数位
            return "\(prefix)\(degreeString)°\(minuteString)'\(secondString)\"" // 返回格式化后的度分秒格式经度字符串
        }
    }
}
