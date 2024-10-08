import CoreLocation
import Foundation
import SwiftUI

/// `AValue` 是一个支持多种类型值的枚举
public enum AValue: Codable, Hashable, Sendable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, ExpressibleByBooleanLiteral {
    /// 表示一个数值 (例如: 42.0)
    case number(Double)

    /// 表示一个具有 X 和 Y 坐标的点
    case point(x: Double, y: Double)

    /// 表示一个具有纬度和经度的地理位置
    case location(latitude: Double, longitude: Double)

    /// 表示一个布尔值
    case boolean(Bool)

    /// 表示一个字符串
    case string(String)

    /// 表示具有AWindLimit的地面风限制
    case groundWind(limit: AWindLimit)

    /// 表示以分钟为单位的持续时间
    case minutes(Int)

    /// 表示一个以日历时间形式的特定日期和时间
    case calendar(Date)

    /// 表示两个日期之间的差异
    case dateDifference(DateComponents)
}

public extension AValue {
    /// 一个返回 AValue 类型的计算属性
    var type: AValueType {
        switch self {
        case .number: return .number
        case .point: return .point
        case .location: return .location
        case .boolean: return .boolean
        case .string: return .string
        case .groundWind: return .groundWind
        case .minutes: return .minutes
        case .calendar: return .calendar
        case .dateDifference: return .dateDifference
        }
    }

    var description: String {
        switch self {
        case let .number(value):
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return Int(value).description
            } else {
                return value.description
            }
        case let .point(x, y):
            return "(\(x), \(y))"
        case let .location(latitude, longitude):
            let latitudeStr = ALatitude(latitude).toDM()
            let longitudeStr = ALongitude(longitude).toDM()
            return "\(latitudeStr) \(longitudeStr)"
        case let .boolean(value):
            return value ? "✓" : "x"
        case let .string(value):
            return "`\(value)`".replacingOccurrences(of: "\n", with: "↵")
        case let .groundWind(limit):
            return "\(limit)"
        case let .minutes(value):
            return AHourMinuteValue(minutes: value).toFormat(.hourMinute).description
        case let .calendar(date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        case let .dateDifference(components):
            return "\(components)"
        }
    }

    @Sendable func add(_ value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            return .number(value1 + value2)
        case let (.point(x1, y1), .point(x2, y2)):
            return .point(x: x1 + x2, y: y1 + y2)
        case let (.minutes(value1), .minutes(value2)):
            return .minutes(value1 + value2)
        case let (.calendar(value1), .minutes(value2)):
            return try self.addMinutes(to: value1, minutes: value2)
        case let (.minutes(value1), .calendar(value2)):
            return try self.addMinutes(to: value2, minutes: value1)
        case let (.calendar(value1), .dateDifference(value2)):
            return try self.addDateDifference(to: value1, difference: value2)
        case let (.dateDifference(value1), .calendar(value2)):
            return try self.addDateDifference(to: value2, difference: value1)
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable private func addMinutes(to calendarValue: Date, minutes: Int) throws -> AValue {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: minutes, to: calendarValue) else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate)
    }

    @Sendable private func addDateDifference(to calendarValue: Date, difference: DateComponents) throws -> AValue {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: difference, to: calendarValue) else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate)
    }

    @Sendable func subtract(_ value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            return .number(value1 - value2)
        case let (.point(x1, y1), .point(x2, y2)):
            return .point(x: x1 - x2, y: y1 - y2)
        case let (.minutes(value1), .minutes(value2)):
            return .minutes(value1 - value2)
        case let (.calendar(value1), .minutes(value2)):
            return try self.subtractMinutes(from: value1, minutes: value2)
        case let (.calendar(value1), .dateDifference(value2)):
            return try self.subtractDateDifference(from: value1, difference: value2)
        case let (.dateDifference(value1), .calendar(value2)):
            return try self.subtractDateDifference(from: value2, difference: value1)
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable private func subtractMinutes(from calendarValue: Date, minutes: Int) throws -> AValue {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: -minutes, to: calendarValue) else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate)
    }

    @Sendable private func subtractDateDifference(from calendarValue: Date, difference: DateComponents) throws -> AValue {
        let calendar = Calendar.current
        var negativeComponents = DateComponents()
        negativeComponents.year = -(difference.year ?? 0)
        negativeComponents.month = -(difference.month ?? 0)
        negativeComponents.day = -(difference.day ?? 0)
        negativeComponents.hour = -(difference.hour ?? 0)
        negativeComponents.minute = -(difference.minute ?? 0)
        negativeComponents.second = -(difference.second ?? 0)
        guard let newDate = calendar.date(byAdding: negativeComponents, to: calendarValue) else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate)
    }

    @Sendable func multiply(by value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            return .number(value1 * value2)
        case let (.point(x1, y1), .number(value2)):
            return .point(x: x1 * value2, y: y1 * value2)
        case let (.number(value1), .point(x2, y2)):
            return .point(x: value1 * x2, y: value1 * y2)
        case let (.minutes(value1), .number(value2)):
            return .minutes(Int(Double(value1) * value2))
        case let (.number(value1), .minutes(value2)):
            return .minutes(Int(value1 * Double(value2)))
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable func divide(by value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            guard value2 != 0 else {
                throw AValueError.divisionByZero
            }
            return .number(value1 / value2)
        case let (.point(x1, y1), .number(value2)):
            guard value2 != 0 else {
                throw AValueError.divisionByZero
            }
            return .point(x: x1 / value2, y: y1 / value2)
        case let (.minutes(value1), .number(value2)):
            guard value2 != 0 else {
                throw AValueError.divisionByZero
            }
            return .minutes(Int(Double(value1) / value2))
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable func remainder(dividingBy value: AValue) throws -> AValue {
        guard case let .number(value1) = self,
              case let .number(value2) = value
        else {
            throw AValueError.invalidOperation
        }
        return .number(value1.truncatingRemainder(dividingBy: value2))
    }

    @Sendable func power(of value: AValue) throws -> AValue {
        guard case let .number(value1) = self,
              case let .number(value2) = value
        else {
            throw AValueError.invalidOperation
        }
        return .number(pow(value1, value2))
    }

    @Sendable func and(_ value: AValue) throws -> AValue {
        guard case let .boolean(value1) = self,
              case let .boolean(value2) = value
        else {
            throw AValueError.invalidOperation
        }
        return .boolean(value1 && value2)
    }

    @Sendable func or(_ value: AValue) throws -> AValue {
        guard case let .boolean(value1) = self,
              case let .boolean(value2) = value
        else {
            throw AValueError.invalidOperation
        }
        return .boolean(value1 || value2)
    }

    @Sendable func not() throws -> AValue {
        guard case let .boolean(value) = self else {
            throw AValueError.invalidOperation
        }
        return .boolean(!value)
    }

    @Sendable func isGreater(than value: AValue) throws -> Bool {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            return value1 > value2
        case let (.string(value1), .string(value2)):
            return value1 > value2
        case let (.minutes(value1), .minutes(value2)):
            return value1 > value2
        case let (.calendar(value1), .calendar(value2)):
            return value1 > value2
        default:
            throw AValueError.comparisonError
        }
    }

    @Sendable func isGreaterOrEqual(to value: AValue) throws -> Bool {
        try self.isGreater(than: value) || self == value
    }

    @Sendable func isLess(than value: AValue) throws -> Bool {
        try !self.isGreaterOrEqual(to: value)
    }

    @Sendable func isLessThanOrEqual(to value: AValue) throws -> Bool {
        try !self.isGreater(than: value)
    }

    /// 为这个 `AValue` 取负值
    ///
    /// - Returns: 取负结果作为一个新的 `AValue` 返回
    /// - Throws: 如果操作无效，则抛出 `AValueCalcError`
    @Sendable func negative() throws -> AValue {
        switch self {
        case let .number(value):
            return .number(-value)
        case let .point(x, y):
            return .point(x: -x, y: -y)
        case let .minutes(value):
            return .minutes(-value)
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable func groundWindComponents() throws -> AWindLimit {
        if case let .groundWind(limit) = self {
            return limit
        } else {
            throw AValueError.typeMismatch(expected: .groundWind, actual: self.type)
        }
    }

    @Sendable func absolute() throws -> AValue {
        switch self {
        case let .number(value):
            return .number(abs(value))
        case let .point(x, y):
            return .point(x: abs(x), y: abs(y))
        case let .minutes(value):
            return .minutes(abs(value))
        default:
            throw AValueError.invalidOperation
        }
    }

    init(floatLiteral value: Double) {
        self = .number(value)
    }

    init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }

    init(stringLiteral value: String) {
        self = .string(value)
    }

    init(integerLiteral value: Int) {
        self.init(floatLiteral: .init(value))
    }
}

extension AValue {
    /// Extracts the Double value if the AValue is of type `.number`
    func getNumber() -> Double? {
        guard case let .number(number) = self else {
            return nil
        }
        return number
    }

    /// Extracts the (x, y) tuple if the AValue is of type `.point`
    func getPoint() -> SIMD2<Double>? {
        guard case let .point(x, y) = self else {
            return nil
        }
        return SIMD2(x, y)
    }

    /// Extracts the (latitude, longitude) tuple if the AValue is of type `.location`
    func getLocation() -> CLLocationCoordinate2D? {
        guard case let .location(latitude, longitude) = self else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Extracts the Bool value if the AValue is of type `.boolean`
    func getBoolean() -> Bool? {
        guard case let .boolean(boolean) = self else {
            return nil
        }
        return boolean
    }

    /// Extracts the String value if the AValue is of type `.string`
    func getString() -> String? {
        guard case let .string(string) = self else {
            return nil
        }
        return string
    }

    /// Extracts the AWindLimit value if the AValue is of type `.groundWind`
    func getGroundWindLimit() -> AWindLimit? {
        guard case let .groundWind(limit) = self else {
            return nil
        }
        return limit
    }

    /// Extracts the Int value if the AValue is of type `.minutes`
    func getMinutes() -> Int? {
        guard case let .minutes(minutes) = self else {
            return nil
        }
        return minutes
    }

    /// Extracts the Date value if the AValue is of type `.calendar`
    func getCalendar() -> Date? {
        guard case let .calendar(date) = self else {
            return nil
        }
        return date
    }

    /// Extracts the DateComponents value if the AValue is of type `.dateDifference`
    func getDateDifference() -> DateComponents? {
        guard case let .dateDifference(components) = self else {
            return nil
        }
        return components
    }
}
