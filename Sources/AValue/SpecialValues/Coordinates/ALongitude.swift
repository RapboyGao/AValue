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

// MARK: - NSRegularExpression

public extension ALongitude {
    // Helper function to handle regular expressions more efficiently
    private static func matchPattern(_ pattern: String, in string: String) -> NSTextCheckingResult? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        return regex?.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
    }

    init(raw string: String?) throws {
        // 确保输入字符串不为空并去除首尾空白字符
        guard let trimmedString = string?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedString.isEmpty else {
            throw ACoordinateParsingError.invalidFormat
        }

        // 定义所有需要匹配的正则表达式模式及其对应的解析逻辑
        let patterns: [(pattern: String, parse: (NSTextCheckingResult) throws -> ALongitude)] = [
            // MARK: - Degrees, Minutes, and Seconds (e.g., E036° 13' 15.0")

            (
                pattern: #"^(E|W)\s*(\d{1,3})\s*°\s*(\d{1,2})\s*'\s*(\d{1,2}(?:\.\d+)?)\s*"$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isEast: direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
                }
            ),

            // MARK: - 7 Digits Before Decimal (e.g., E0361350.2 -> E036 1350.2)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d)([0-5]\d\.\d+)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isEast: direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
                }
            ),

            // MARK: - 8 Digits (e.g., E03613502 -> E036 13 50.2)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d)(\d{3})$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesIntString),
                          let seconds = Double(secondsString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isEast: direction == "E", degrees: degrees, minutes: minutes, seconds: seconds / 10)
                }
            ),

            // MARK: -  7 Digits (e.g., E0361350 -> E036 13 50)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d)([0-5]\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsIntString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsIntString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isEast: direction == "E", degrees: degrees, minutes: minutes, seconds: Double(seconds))
                }
            ),

            // MARK: - Degrees and Minutes (e.g., E040° 14')

            (
                pattern: #"^(E|W)\s*(\d{1,3})\s*°\s*(\d{1,2}(?:\.\d+)?)\s*'$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isEast: direction == "E", degrees: degrees, minutes: minutes)
                }
            ),

            // MARK: - 5 Digits Before Decimal (e.g., E03613.502 -> E036 13.502)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d\.\d+)$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isEast: direction == "E", degrees: degrees, minutes: minutes)
                }
            ),

            // MARK: - 6 Digits (e.g., W036135 -> W036 13.5)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d)(\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let minuteDigitString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Double("\(minutesIntString).\(minuteDigitString)")
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isEast: direction == "E", degrees: degrees, minutes: minutes)
                }
            ),

            // MARK: - 5 Digits (e.g., W04014 -> W040 14.0)

            (
                pattern: #"^(E|W)(\d{3})([0-5]\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesIntString)
                    else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isEast: direction == "E", degrees: degrees, minutes: minutes)
                }
            ),

            // MARK: - Degrees (e.g., W2.15, W39.13354)

            (
                pattern: #"^(E|W)\s*(\d{1,3}(?:\.\d+)?)\s*°?$"#,
                parse: { result in
                    guard result.numberOfRanges == 3 else { throw ACoordinateParsingError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))

                    guard let degrees = Double(degreesString) else {
                        throw ACoordinateParsingError.errorWhenParsingNumber
                    }

                    return .degrees(isEast: direction == "E", degrees: degrees)
                }
            ),
        ]

        // 遍历所有模式并尝试匹配
        for (pattern, parse) in patterns {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: trimmedString.utf16.count)
            if let match = regex.firstMatch(in: trimmedString, options: [], range: range) {
                // 尝试解析匹配结果
                let latitude = try parse(match)
                self = latitude.normalized()
                return
            }
        }

        // 如果所有模式都不匹配，则抛出格式错误
        throw ACoordinateParsingError.invalidFormat
    }

    init(_ string: String?) throws {
        let someValue = try ALongitude(raw: string)
        self = someValue.normalized()
    }
}

// MARK: - Swift Original Regex

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ALongitude {
    init(raw2 string: String?) throws {
        // 检查输入字符串是否为空或仅包含空格
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else {
            throw ACoordinateParsingError.stringNotProvided
        }

        // MARK: - 完整格式

        let patternOriginalDMS = #/
            (?<direction>E|W)
            \s*
            ((?<degrees>\d{1,3})\s*°)
            \s*
            (?<minutes>\d{1,2})\s*'
            \s*
            (?<seconds>\d{1,2}(\.\d+)?)\s*"
        /#

        if let match = try? patternOriginalDMS.wholeMatch(in: string) {
            let output = match.output
            guard let degrees = Int(output.degrees),
                  let minutes = Int(output.minutes),
                  let seconds = Double(output.seconds)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        // MARK: - 在小数点前有 7 位数

        // - E012 34 56.7
        let pattern7BeforeDot = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutes>[0-5]\d)
            \s*
            (?<seconds>[0-5]\d\.\d+)
        /#
        if let match = try? pattern7BeforeDot.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutes),
                  let seconds = Double(match.output.seconds)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        // MARK: - 一共 8 位数

        // - E012 34 567
        let pattern8Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            \s*
            (?<seconds>[0-5]\d\d)
        /#
        if let match = try? pattern8Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutesInt),
                  let seconds = Double(match.output.seconds)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds / 10)
            return
        }

        // MARK: - 一共 7 位数

        // - W012 34 56
        let pattern7Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            \s*
            (?<secondsInt>[0-5]\d)
        /#
        if let match = try? pattern7Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Int(match.output.minutesInt),
                  let seconds = Double(match.output.secondsInt)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        // MARK: - 度分

        let patternOriginalDM = #/
            (?<direction>E|W)
            \s*
            (?<degrees>\d{1,3})\s*°
            \s*
            (?<minutes>\d{1,2}(\.\d+)?)\s*'
        /#

        if let match = try? patternOriginalDM.wholeMatch(in: string) {
            let output = match.output
            guard let degrees = Int(output.degrees),
                  let minutes = Double(output.minutes)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        // MARK: - 在小数点前有 5 位数

        // - W012 34.5
        let pattern5BeforeDot = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutes>[0-5]\d\.\d+)
        /#
        if let match = try? pattern5BeforeDot.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutes)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        // MARK: - 一共 6 位数

        // - W012 345
        let pattern6Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d))
            \s*
            (?<minutesInt>[0-5]\d)
            (?<minuteDigit>\d)
        /#
        if let match = try? pattern6Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt + "." + match.output.minuteDigit)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        // MARK: - 一共 5 位数

        // - W012 34
        let pattern5Digits = #/
            (?<direction>E|W)
            (?<degrees>(0\d\d|1[0-8]\d)) // 三位数023 或者 135
            \s*
            (?<minutesInt>[0-5]\d) // 0-59 范围
        /#
        if let match = try? pattern5Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degreesMinutes(isEast: match.output.direction == "E", degrees: degrees, minutes: minutes)
            return
        }

        // MARK: - 度

        let patterBasic = #/
            (?<direction>E|W)
            \s*
            (?<number>\d{1,3}\.\d+)
            °?
        /#
        if let match = try? patterBasic.wholeMatch(in: string) {
            guard let number = Double(match.output.number)
            else { throw ACoordinateParsingError.errorWhenParsingNumber }
            self = .degrees(isEast: match.output.direction == "E", degrees: number)
            return
        }

        // 如果无法匹配任何已知格式，抛出错误
        throw ACoordinateParsingError.invalidFormat
    }

    init(original string: String?) throws {
        let someValue = try ALongitude(raw2: string)
        self = someValue.normalized()
    }
}
