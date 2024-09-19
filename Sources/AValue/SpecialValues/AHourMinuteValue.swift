public enum AHourMinuteValue: Codable, Sendable, Hashable, CustomStringConvertible {
    case hourMinute(isNegative: Bool, hour: Int, minute: Int)
    case totalHours(isNegative: Bool, hour: Double)
    case totalMinutes(isNegative: Bool, totalMinutes: Int)
    /// days可以是负值
    case days24HM(day: Int, hour: Int, minute: Int)
}

public extension AHourMinuteValue {
    init(minutes: Int) {
        self = .totalMinutes(isNegative: minutes < 0, totalMinutes: abs(minutes))
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
            let dayPart = "" + String(format: "%+1d", day) + "d"
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
