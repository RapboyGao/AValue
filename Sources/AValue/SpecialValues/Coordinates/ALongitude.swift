import Foundation

public enum ALongitudeError: Error {
    case invalidDirection
    case invalidFormat
    case invalidDegree
    case invalidMinute
    case invalidSecond
}

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
    public func normalized() -> Self {
        switch self {
        case .degreesMinutes(let isEast, var degrees, var minutes):
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutes(isEast: isEast, degrees: degrees, minutes: minutes)
        case .degreesMinutesSeconds(let isEast, var degrees, var minutes, var seconds):
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

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ALongitude {
    init(raw string: String?) throws {
        // 检查输入字符串是否为空或仅包含空格
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else {
            throw ALatitudeError.invalidFormat
        }

        let patternOriginal = #/
            (?<direction>E|W)
            \s*
            ((?<degrees>\d{1,3} (\.\d+)? )°)
            (
                (?<minutes>\d{1,2} (\.\d+)? )'
                ((?<seconds>\d{1,2} (\.\d+)? )")?
            )?
        /#
        if let match = try? patternOriginal.wholeMatch(in: string) {
            let output = match.output
            if let minuteStr = output.minutes {
                if let secondStr = output.seconds { // 度分秒
                    guard let degrees = Int(output.degrees),
                          let minutes = Int(minuteStr),
                          let seconds = Double(secondStr)
                    else { throw ALatitudeError.errorWhenParsingNumber }
                    self = .degreesMinutesSeconds(isEast: output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)

                } else { // 度分
                    guard let degrees = Int(output.degrees),
                          let minutes = Double(minuteStr)
                    else { throw ALatitudeError.errorWhenParsingNumber }
                    self = .degreesMinutes(isEast: output.direction == "E", degrees: degrees, minutes: minutes)
                }
            } else { // 度
                guard let degrees = Double(output.degrees)
                else { throw ALatitudeError.errorWhenParsingNumber }
                self = .degrees(isEast: output.direction == "E", degrees: degrees)
            }
            return
        }

        let patterBasic = #/
            (?<direction>E|W)
            (?<number>\d{1,3}\.\d+)
            °?
        /#
        if let match = try? patterBasic.wholeMatch(in: string) {
            guard let number = Double(match.output.number)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degrees(isEast: match.output.direction == "E", degrees: number)
            return
        }

        let pattern4Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
        /#
        if let match = try? pattern4Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        /// - N36135 -> N36 13.5
        let pattern5Digits = #/
            (?<direction>E|W)
        (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            (?<minuteDigit>\d)
        /#
        if let match = try? pattern5Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt + "." + match.output.minuteDigit)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        /// - N361350-> N36 13 15.0
        let pattern6Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            \s*
            (?<secondsInt>[0-5]\d)
        /#
        if let match = try? pattern6Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutesInt),
                  let seconds = Double(match.output.secondsInt)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        /// - N3613502 -> N36 13 50.2
        let pattern7Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            \s*
            (?<seconds>[0-5]\d\d)
        /#
        if let match = try? pattern7Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutesInt),
                  let seconds = Double(match.output.seconds)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds / 10)
            return
        }

        /// - N3613.502 -> N36 13.502
        let pattern4BeforeDot = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutes>[0-5]\d\.\d+)
        /#
        if let match = try? pattern4BeforeDot.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutes)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        /// - N361350.2 -> N36 1350.2
        let pattern6BeforeDot = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutes>[0-5]\d)
            \s*
            (?<seconds>[0-5]\d\.\d+)
        /#
        if let match = try? pattern6BeforeDot.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutes),
                  let seconds = Double(match.output.seconds)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        // 如果无法匹配任何已知格式，抛出错误
        throw ALatitudeError.invalidFormat
    }

    init(_ string: String?) throws {
        let someValue = try ALongitude(raw: string)
        self = someValue.normalized()
    }
}
