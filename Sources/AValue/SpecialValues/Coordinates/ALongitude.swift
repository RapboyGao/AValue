import Foundation

public enum ALongitude: Codable, Sendable, Hashable, CustomStringConvertible {
    case degrees(isEast: Bool, degrees: Double)
    case degreesMinutes(isEast: Bool, degrees: Int, minutes: Double)
    case degreesMinutesSeconds(isEast: Bool, degrees: Int, minutes: Int, seconds: Double)

    @Sendable
    public init(_ longitude: Double) {
        self = .degrees(isEast: longitude >= 0, degrees: abs(longitude))
    }

    @Sendable
    public init(_ longitude: Double, format: ACoordinateFormat) {
        let someValue: ALongitude = .degrees(isEast: longitude >= 0, degrees: abs(longitude))
        self = someValue.toFormat(format)
    }

    public init?(_ string: String?) {
        // 检查输入字符串是否为 nil 或仅包含空格
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else {
            return nil
        }

        // 根据第一个字符确定方向（东或西）
        let isEast: Bool
        if string.first == "E" {
            isEast = true
        } else if string.first == "W" {
            isEast = false
        } else {
            return nil
        }

        // 去掉方向字符并处理后面的数字部分
        let numericPart = string.dropFirst()

        // 格式解析：E122453 -> E122°45.3'
        if numericPart.range(of: #"^(\d{3})(\d{3})$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.suffix(3)
            if let degrees = Int(degreesStr), let minutes = Double(minutesStr) {
                self = .degreesMinutes(isEast: isEast, degrees: degrees, minutes: minutes / 10.0)
                return
            }
        }

        // 格式解析：W12230.5 -> W122°30.5'
        if numericPart.range(of: #"^(\d{3})(\d{2})\.(\d+)$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(3)
            if let degrees = Int(degreesStr), let minutes = Double(minutesStr) {
                self = .degreesMinutes(isEast: isEast, degrees: degrees, minutes: minutes)
                return
            }
        }

        // 格式解析：E1223045 -> E122°30'45"
        if numericPart.range(of: #"^(\d{3})(\d{2})(\d{2})$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(3).prefix(2)
            let secondsStr = numericPart.suffix(2)
            if let degrees = Int(degreesStr), let minutes = Int(minutesStr), let seconds = Double(secondsStr) {
                self = .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds)
                return
            }
        }

        // 格式解析：E12230453 -> E122°30'45.3"
        if numericPart.range(of: #"^(\d{3})(\d{2})(\d{3})$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(3).prefix(2)
            let secondsStr = numericPart.suffix(3)
            if let degrees = Int(degreesStr), let minutes = Int(minutesStr), let seconds = Double(secondsStr) {
                self = .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds / 10.0)
                return
            }
        }

        // 格式解析：E1223045.3 -> E122°30'45.3"
        if numericPart.range(of: #"^(\d{3})(\d{2})(\d{2})\.(\d+)$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(3).prefix(2)
            let secondsStr = numericPart.dropFirst(5)
            if let degrees = Int(degreesStr), let minutes = Int(minutesStr), let seconds = Double(secondsStr) {
                self = .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds)
                return
            }
        }

        // 格式解析：W122.456 -> W122.456°
        if numericPart.range(of: #"^(\d{3})(\.(\d+))?$"#, options: .regularExpression) != nil {
            if let degrees = Double(numericPart) {
                self = .degrees(isEast: isEast, degrees: degrees)
                return
            }
        }

        // 格式解析：E122°30.5' -> 仅度和分
        if numericPart.range(of: #"^(\d{3})°(\d{1,2})\.(\d+)'$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(4).dropLast()
            if let degrees = Int(degreesStr), let minutes = Double(minutesStr) {
                self = .degreesMinutes(isEast: isEast, degrees: degrees, minutes: minutes)
                return
            }
        }

        // 格式解析：W122°30'45" -> 度、分和秒
        if numericPart.range(of: #"^(\d{3})°(\d{2})'(\d{2}(\.\d+)?)"$"#, options: .regularExpression) != nil {
            let degreesStr = numericPart.prefix(3)
            let minutesStr = numericPart.dropFirst(4).prefix(2)
            let secondsStr = numericPart.dropFirst(7).dropLast()
            if let degrees = Int(degreesStr), let minutes = Int(minutesStr), let seconds = Double(secondsStr) {
                self = .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds)
                return
            }
        }

        // 如果没有匹配到任何已知格式，返回 nil
        return nil
    }

    @Sendable
    public func toNumber() -> Double {
        switch self {
        case .degrees(let isEast, let degrees):
            return isEast ? degrees : -degrees
        case .degreesMinutes(let isEast, let degrees, let minutes):
            return isEast ? Double(degrees) + minutes / 60.0 : -Double(degrees) - minutes / 60.0
        case .degreesMinutesSeconds(let isEast, let degrees, let minutes, let seconds):
            return isEast ? Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0 :
                -Double(degrees) - Double(minutes) / 60.0 - seconds / 3600.0
        }
    }

    @Sendable
    public func normalized(digits: Int) -> Self {
        let scale = pow(10.0, Double(digits))
        switch self {
        case .degreesMinutes(let isEast, var degrees, var minutes):
            minutes = (minutes * scale).rounded() / scale
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutes(isEast: isEast, degrees: degrees, minutes: minutes)
        case .degreesMinutesSeconds(let isEast, var degrees, var minutes, var seconds):
            seconds = (seconds * scale).rounded() / scale
            if seconds >= 60 { minutes += 1; seconds -= 60 }
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutes, seconds: seconds)
        default:
            return self
        }
    }

    @Sendable
    public func toString(digits: Int) -> String {
        let result = self.normalized(digits: digits)
        switch result {
        case .degrees(let isEast, let degrees):
            return "\(isEast ? "E" : "W")\(String(format: "%0\(digits + 4).\(digits)f", degrees))°"
        case .degreesMinutes(let isEast, let degrees, let minutes):
            return "\(isEast ? "E" : "W")\(String(format: "%03d", degrees))°\(String(format: "%0\(digits + 3).\(digits)f", minutes))'"
        case .degreesMinutesSeconds(let isEast, let degrees, let minutes, let seconds):
            return "\(isEast ? "E" : "W")\(String(format: "%03d", degrees))°\(String(format: "%02d", minutes))'\(String(format: "%0\(digits + 3).\(digits)f", seconds))\""
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
    public func toD() -> ALongitude {
        switch self {
        case .degreesMinutes(let isEast, let degrees, let minutes):
            return .degrees(isEast: isEast, degrees: Double(degrees) + minutes / 60.0)
        case .degreesMinutesSeconds(let isEast, let degrees, let minutes, let seconds):
            return .degrees(isEast: isEast, degrees: Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0)
        default:
            return self
        }
    }

    @Sendable
    public func toDM() -> ALongitude {
        switch self {
        case .degrees(let isEast, let degrees):
            let degreesInt = Int(degrees)
            return .degreesMinutes(isEast: isEast, degrees: degreesInt, minutes: (degrees - Double(degreesInt)) * 60.0)
        case .degreesMinutesSeconds(let isEast, let degrees, let minutes, let seconds):
            return .degreesMinutes(isEast: isEast, degrees: degrees, minutes: Double(minutes) + seconds / 60.0)
        default:
            return self
        }
    }

    @Sendable
    public func toDMS() -> ALongitude {
        switch self {
        case .degrees(let isEast, let degrees):
            let degreesInt = Int(degrees)
            let minutesDouble = (degrees - Double(degreesInt)) * 60.0
            let minutesInt = Int(minutesDouble)
            return .degreesMinutesSeconds(isEast: isEast, degrees: degreesInt, minutes: minutesInt, seconds: (minutesDouble - Double(minutesInt)) * 60.0)
        case .degreesMinutes(let isEast, let degrees, let minutes):
            let minutesInt = Int(minutes)
            return .degreesMinutesSeconds(isEast: isEast, degrees: degrees, minutes: minutesInt, seconds: (minutes - Double(minutesInt)) * 60.0)
        default:
            return self
        }
    }
}
