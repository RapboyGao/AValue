import Foundation

public enum AHourMinuteValue: Codable, Sendable, Hashable, CustomStringConvertible {
    case hourMinute(isNegative: Bool, hour: Int, minute: Int)
    case totalHours(isNegative: Bool, hour: Double)
    case totalMinutes(isNegative: Bool, totalMinutes: Int)
    case days24HM(day: Int, hour: Int, minute: Int)
}

public extension AHourMinuteValue {
    init(minutes: Int) {
        self = .totalMinutes(isNegative: minutes < 0, totalMinutes: abs(minutes))
    }
}

public extension AHourMinuteValue {
    /// - 130 或 0130 1:30 判断为 1小时30分钟
    /// - 321:23 或 32123 判断为 321小时30分钟
    /// - 3 判断为3分钟
    /// - 3: 判断为3小时
    /// - 12 判断为12分钟
    /// - 1:2 判断为1小时2分钟
    /// - :2 判断为2分钟
    /// - 以上内容如果前面有负号则判断为负，如果有加号或者没有则判断为正
    /// - 130+1d 判断为1小时30分钟+1天
    /// - -124+2d 判断为22:36+1天
    /// - +1d 判断为0小时0分钟+1天，必须带正负号
    /// - 12+1d 判断为0小时12分钟+1天
    init?(string: String?) {
        // 检查输入字符串是否为空或仅包含空白字符
        guard let input = string?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
            return nil
        }

        // 检查是否为负数
        let isNegative = input.hasPrefix("-")

        // 检查是否包含天数 (例如: "+1d", "-124+2d")
        if let dayRange = input.range(of: #"[+\-](\d+)d$"#, options: .regularExpression) { // 天数必须要包含正负号
            let dayString = input[dayRange]
            let days = Int(dayString.dropLast()) ?? 0

            // 移除天数部分以解析剩余的小时和分钟
            let remainingInput = input.replacingOccurrences(of: dayString, with: "")
            let result = AHourMinuteValue(string: remainingInput) ?? .hourMinute(isNegative: false, hour: 0, minute: 0)
            let totalNumber = result.toNumber() + days * 1440
            self = .init(minutes: totalNumber).toDHM()
            return
        }

        let cleanInput = input.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")

        // 解析 "HH:mm" 或 "HHmm" 格式
        let timeComponents = cleanInput.split(separator: ":")
        if timeComponents.count == 2 {
            if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
                self = .hourMinute(isNegative: isNegative, hour: hour, minute: minute)
                return
            }
        }

        // 解析 "HHmm" 格式
        if let intInput = Int(cleanInput) {
            if cleanInput.count > 2 {
                let hour = intInput / 100
                let minute = intInput % 100
                self = .hourMinute(isNegative: isNegative, hour: hour, minute: minute)
                return
            } else {
                // 输入为单个数字，视为分钟
                self = .totalMinutes(isNegative: isNegative, totalMinutes: intInput)
                return
            }
        }

        // 处理类似 "3:" 或 "12:" 格式
        if cleanInput.hasSuffix(":") {
            let hourString = cleanInput.dropLast()
            if let hour = Int(hourString) {
                self = .hourMinute(isNegative: isNegative, hour: hour, minute: 0)
                return
            }
        }

        // 处理类似 ":minutes" (例如: ":2")
        if cleanInput.hasPrefix(":") {
            let minuteString = cleanInput.dropFirst()
            if let minute = Int(minuteString) {
                self = .hourMinute(isNegative: isNegative, hour: 0, minute: minute)
                return
            }
        }

        // 如果输入格式无效，返回 nil
        return nil
    }
}

public extension AHourMinuteValue {
    func toNumber() -> Int {
        switch self {
        case .hourMinute(let isNegative, let hour, let minute):
            let result = hour * 60 + minute
            return isNegative ? -result : result
        case .totalHours(let isNegative, let hour):
            let result = hour * 60
            return Int(isNegative ? -result : result)
        case .totalMinutes(let isNegative, let totalMinutes):
            return Int(isNegative ? -totalMinutes : totalMinutes)
        case .days24HM(let days, let hour, let minute):
            return days * 1440 + hour * 60 + minute
        }
    }

    var description: String {
        switch self {
        case .hourMinute(let isNegative, let hour, let minute):
            return isNegative ? "-" + String(format: #"%02d:%02d"#, hour, minute) : String(format: #"%02d:%02d"#, hour, minute)
        case .totalHours(let isNegative, let hour):
            return isNegative ? "-" + String(format: #"%02.3fh"#, hour) : String(format: #"%02.3fh"#, hour)
        case .totalMinutes(let isNegative, let totalMinutes):
            return isNegative ? "-" + String(format: #"%dm"#, totalMinutes) : String(format: #"%dm"#, totalMinutes)
        case .days24HM(let day, let hour, let minute):
            let hourMinutePart = String(format: #"%02d:%02d"#, hour, minute)
            guard day != 0 else {
                return hourMinutePart
            }
            let dayPart = String(format: "%+1d", day) + "d"
            return hourMinutePart + dayPart
        }
    }
}

public extension AHourMinuteValue {
    enum Format: CaseIterable, Sendable, Hashable, Codable {
        case hourMinute, totalHours, totalMinutes, days24HM
    }

    var format: Format {
        switch self {
        case .hourMinute:
            return .hourMinute
        case .totalHours:
            return .totalHours
        case .totalMinutes:
            return .totalMinutes
        case .days24HM:
            return .days24HM
        }
    }

    @Sendable
    func toFormat(_ newFormat: Format) -> Self {
        switch newFormat {
        case .hourMinute:
            return toHM()
        case .totalHours:
            return toTotalHours()
        case .totalMinutes:
            return toTotalMinutes()
        case .days24HM:
            return toDHM()
        }
    }

    @Sendable
    func toHM() -> AHourMinuteValue {
        let totalMinutes = toNumber()
        let totalMinutesAbs = Double(abs(totalMinutes))
        var hour = (totalMinutesAbs / 60).rounded(.down)
        var minute = (totalMinutesAbs - hour * 60).rounded()
        if minute >= 60 {
            minute -= 60
            hour += 1
        }
        return .hourMinute(isNegative: totalMinutes < 0, hour: Int(hour), minute: Int(minute))
    }

    @Sendable
    func toDHM() -> AHourMinuteValue {
        let totalMinutes = Double(toNumber())
        var days = (totalMinutes / 1440).rounded(.down)
        let minutesLeft = totalMinutes - days * 1440
        var hour = (minutesLeft / 60).rounded(.down)
        var minute = (minutesLeft - hour * 60).rounded()
        if minute >= 60 {
            minute -= 60
            hour += 1
        }
        if hour >= 24 {
            hour -= 24
            days += 1
        }
        return .days24HM(day: Int(days), hour: Int(hour), minute: Int(minute))
    }

    @Sendable
    func toTotalHours() -> AHourMinuteValue {
        let totalMinutes = Double(toNumber())
        return .totalHours(isNegative: totalMinutes < 0, hour: abs(totalMinutes) / 60)
    }

    @Sendable
    func toTotalMinutes() -> AHourMinuteValue {
        let totalMinute = toNumber()
        return AHourMinuteValue(minutes: totalMinute)
    }
}

public extension Array where Element == AHourMinuteValue {
    func sum(format: AHourMinuteValue.Format) -> AHourMinuteValue {
        let totalNumber = reduce(0) { partialResult, nextValue in
            partialResult + nextValue.toNumber()
        }
        return AHourMinuteValue(minutes: totalNumber).toFormat(format)
    }

    /// 解析公式
    /// - 例如 "3+3:30-:20+3:+5d-23" 解析为 [ +00:03, +03:30,  -00:20, +3:00, +00:00+5d, -00:23]
    init?(_ expression: String?) {
        guard let expression = expression
        else {
            return nil
        }

        var result: [AHourMinuteValue] = []
        var currentIndex = expression.startIndex

        while currentIndex < expression.endIndex {
            let sign: String
            if expression[currentIndex] == "+" || expression[currentIndex] == "-" {
                sign = String(expression[currentIndex])
                currentIndex = expression.index(after: currentIndex)
            } else {
                sign = "+"
            }

            var nextIndex = currentIndex
            while nextIndex < expression.endIndex && expression[nextIndex] != "+" && expression[nextIndex] != "-" {
                nextIndex = expression.index(after: nextIndex)
            }

            let subExpression = String(expression[currentIndex ..< nextIndex])
            let signedExpression = sign + subExpression

            if let hourMinuteValue = AHourMinuteValue(string: signedExpression) {
                result.append(hourMinuteValue)
            } else {
                return nil
            }

            currentIndex = nextIndex
        }

        self = result
    }
}
