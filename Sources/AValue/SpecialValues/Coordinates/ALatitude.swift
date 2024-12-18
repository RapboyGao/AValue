import Foundation

// 定义初始化错误的枚举
public enum ALatitudeError: Error {
    case invalidDirection
    case invalidFormat
    case errorWhenParsingNumber
}

public enum ALatitude: Codable, Sendable, Hashable, CustomStringConvertible {
    case degrees(isNorth: Bool, degrees: Double)
    case degreesMinutes(isNorth: Bool, degrees: Int, minutes: Double)
    case degreesMinutesSeconds(isNorth: Bool, degrees: Int, minutes: Int, seconds: Double)

    // MARK: - 初始化器

    /// 通过 Double 初始化
    public init(_ latitude: Double) {
        self = .degrees(isNorth: latitude >= 0, degrees: abs(latitude))
    }

    /// 通过 Double 和格式初始化
    public init(_ latitude: Double, format: ACoordinateFormat) {
        self = ALatitude(latitude).toFormat(format)
    }

    // MARK: - 转换方法

    /// 将纬度转换为 Double
    @Sendable
    public func toNumber() -> Double {
        switch self {
        case .degrees(let isNorth, let degrees):
            return isNorth ? degrees : -degrees
        case .degreesMinutes(let isNorth, let degrees, let minutes):
            return isNorth ?
                Double(degrees) + minutes / 60.0
                : -Double(degrees) - minutes / 60.0
        case .degreesMinutesSeconds(let isNorth, let degrees, let minutes, let seconds):
            return isNorth ?
                Double(degrees) + Double(minutes) / 60.0 + seconds / 3600.0
                : -Double(degrees) - Double(minutes) / 60.0 - seconds / 3600.0
        }
    }

    /// 规范化纬度值，保留指定的小数位
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

    /// 规范化纬度值
    @Sendable
    public func normalized() -> Self {
        switch self {
        case .degreesMinutes(let isNorth, var degrees, var minutes):
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutes(isNorth: isNorth, degrees: degrees, minutes: minutes)
        case .degreesMinutesSeconds(let isNorth, var degrees, var minutes, var seconds):
            if seconds >= 60 { minutes += 1; seconds -= 60 }
            if minutes >= 60 { degrees += 1; minutes -= 60 }
            return .degreesMinutesSeconds(isNorth: isNorth, degrees: degrees, minutes: minutes, seconds: seconds)
        default:
            return self
        }
    }

    /// 将纬度转换为字符串，指定小数位数
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

    /// 自定义描述
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

    /// 获取当前坐标格式
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

    /// 转换为指定格式
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

    /// 转换为度格式
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

    /// 转换为度分格式
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

    /// 转换为度分秒格式
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

// MARK: - NSRegularExpression

public extension ALatitude {
    private init(raw string: String?) throws {
        // 确保输入字符串不为空并去除首尾空白字符
        guard let trimmedString = string?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedString.isEmpty else {
            throw ALatitudeError.invalidFormat
        }

        // 定义所有需要匹配的正则表达式模式及其对应的解析逻辑
        let patterns: [(pattern: String, parse: (NSTextCheckingResult) throws -> ALatitude)] = [
            // 1. Degrees (e.g., N2.15, N39.13354)
            (
                pattern: #"^(N|S)\s*(\d{1,2}(?:\.\d+)?)\s*°?$"#,
                parse: { result in
                    guard result.numberOfRanges == 3 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))

                    guard let degrees = Double(degreesString) else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degrees(isNorth: direction == "N", degrees: degrees)
                }
            ),
            // 2. Degrees and Minutes (e.g., N40° 14')
            (
                pattern: #"^(N|S)\s*(\d{1,2})\s*°\s*(\d{1,2}(?:\.\d+)?)\s*'$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isNorth: direction == "N", degrees: degrees, minutes: minutes)
                }
            ),
            // 3. Degrees, Minutes, and Seconds (e.g., N36° 13' 15.0")
            (
                pattern: #"^(N|S)\s*(\d{1,2})\s*°\s*(\d{1,2})\s*'\s*(\d{1,2}(?:\.\d+)?)\s*"$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isNorth: direction == "N", degrees: degrees, minutes: minutes, seconds: seconds)
                }
            ),
            // 4. Basic Pattern (e.g., N2.15, N39.13354)
            (
                pattern: #"^(N|S)(\d{1,2}\.\d+)\s*°?$"#,
                parse: { result in
                    guard result.numberOfRanges == 3 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))

                    guard let degrees = Double(degreesString) else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degrees(isNorth: direction == "N", degrees: degrees)
                }
            ),
            // 5. 4 Digits (e.g., N4014 -> N40 14.0)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesIntString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isNorth: direction == "N", degrees: degrees, minutes: minutes)
                }
            ),
            // 6. 5 Digits (e.g., N36135 -> N36 13.5)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d)(\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let minuteDigitString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Double("\(minutesIntString).\(minuteDigitString)")
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isNorth: direction == "N", degrees: degrees, minutes: minutes)
                }
            ),
            // 7. 6 Digits (e.g., N361350 -> N36 13 50)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d)([0-5]\d)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsIntString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsIntString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isNorth: direction == "N", degrees: degrees, minutes: minutes, seconds: Double(seconds))
                }
            ),
            // 8. 7 Digits (e.g., N3613502 -> N36 13 50.2)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d)(\d{2})$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesIntString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesIntString),
                          let seconds = Double(secondsString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isNorth: direction == "N", degrees: degrees, minutes: minutes, seconds: seconds / 10.0)
                }
            ),
            // 9. 4 Digits Before Decimal (e.g., N3613.502 -> N36 13.502)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d\.\d+)$"#,
                parse: { result in
                    guard result.numberOfRanges == 4 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))

                    guard let degrees = Int(degreesString),
                          let minutes = Double(minutesString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutes(isNorth: direction == "N", degrees: degrees, minutes: minutes)
                }
            ),
            // 10. 6 Digits Before Decimal (e.g., N361350.2 -> N36 1350.2)
            (
                pattern: #"^(N|S)(\d{2})([0-5]\d)([0-5]\d\.\d+)$"#,
                parse: { result in
                    guard result.numberOfRanges == 5 else { throw ALatitudeError.invalidFormat }

                    let direction = (trimmedString as NSString).substring(with: result.range(at: 1))
                    let degreesString = (trimmedString as NSString).substring(with: result.range(at: 2))
                    let minutesString = (trimmedString as NSString).substring(with: result.range(at: 3))
                    let secondsString = (trimmedString as NSString).substring(with: result.range(at: 4))

                    guard let degrees = Int(degreesString),
                          let minutes = Int(minutesString),
                          let seconds = Double(secondsString)
                    else {
                        throw ALatitudeError.errorWhenParsingNumber
                    }

                    return .degreesMinutesSeconds(isNorth: direction == "N", degrees: degrees, minutes: minutes, seconds: seconds)
                }
            )
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
        throw ALatitudeError.invalidFormat
    }

    init(_ string: String?) throws {
        let someValue = try ALatitude(raw: string)
        self = someValue.normalized()
    }
}

// MARK: - Swift Original Regex

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ALatitude {
    private init(raw2 string: String?) throws {
        // 检查输入字符串是否为空或仅包含空格
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else {
            throw ALatitudeError.invalidFormat
        }

        let patternOriginalD = #/
            (?<direction>N|S)
            \s*
            (?<degrees>\d{1,2} (\.\d+)? )
            \s*°
        /#
        if let match = try? patternOriginalD.wholeMatch(in: string) {
            let output = match.output
            guard let degrees = Double(output.degrees)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degrees(isNorth: output.direction == "N", degrees: degrees)
            return
        }

        let patternOriginalDM = #/
            (?<direction>N|S)
            \s*
            (?<degrees>\d{1,2})\s*°
            \s*
            (?<minutes>\d{1,2}(\.\d+)?)\s*'
        /#

        if let match = try? patternOriginalDM.wholeMatch(in: string) {
            let output = match.output
            guard let degrees = Int(output.degrees),
                  let minutes = Double(output.minutes)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isNorth: output.direction == "N", degrees: degrees, minutes: minutes)
            return
        }

        let patternOriginalDMS = #/
            (?<direction>N|S)
            \s*
            ((?<degrees>\d{1,2})\s*°)
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
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutesSeconds(isNorth: output.direction == "N", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        /// - N2.15
        /// - N39.13354
        let patterBasic = #/
            (?<direction>N|S)
            (?<number>\d{1,2}\.\d+)
            °?
        /#
        if let match = try? patterBasic.wholeMatch(in: string) {
            guard let number = Double(match.output.number)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degrees(isNorth: match.output.direction == "N", degrees: number)
            return
        }

        /// - N4014 -> N40 14.0
        let pattern4Digits = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
            \s*
            (?<minutesInt>[0-5]\d)
        /#
        if let match = try? pattern4Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes)
            return
        }

        /// - N36135 -> N36 13.5
        let pattern5Digits = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
            \s*
            (?<minutesInt>[0-5]\d)
            (?<minuteDigit>\d)
        /#
        if let match = try? pattern5Digits.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutesInt + "." + match.output.minuteDigit)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes)
            return
        }

        /// - N361315 -> N36 13 15
        let pattern6Digits = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
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
            self = .degreesMinutesSeconds(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        /// - N3613502 -> N36 13 50.2
        let pattern7Digits = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
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
            self = .degreesMinutesSeconds(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes, seconds: seconds / 10)
            return
        }

        /// - N3613.502 -> N36 13.502
        let pattern4BeforeDot = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
            \s*
            (?<minutes>[0-5]\d\.\d+)
        /#
        if let match = try? pattern4BeforeDot.wholeMatch(in: string) {
            guard let degrees = Int(match.output.degrees),
                  let minutes = Double(match.output.minutes)
            else { throw ALatitudeError.errorWhenParsingNumber }
            self = .degreesMinutes(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes)
            return
        }

        /// - N361350.2 -> N36 1350.2
        let pattern6BeforeDot = #/
            (?<direction>N|S)
            (?<degrees>\d\d)
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
            self = .degreesMinutesSeconds(isNorth: match.output.direction == "N", degrees: degrees, minutes: minutes, seconds: seconds)
            return
        }

        // 如果无法匹配任何已知格式，抛出错误
        throw ALatitudeError.invalidFormat
    }

    init(original string: String?) throws {
        let someValue = try ALatitude(raw: string)
        self = someValue.normalized()
    }
}
