import CoreLocation
import Foundation
import SwiftUI

/// `AValue` 是一个支持多种类型值的枚举
public enum AValue: Codable, Hashable, Sendable, ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral, ExpressibleByStringLiteral, ExpressibleByStringInterpolation,
    ExpressibleByBooleanLiteral
{
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
    case calendar(Date, timeZone: TimeZone?)

    /// 表示两个日期之间的差异
    case dateDifference(DateComponents)

    /// 表示一个颜色
    case color(color: AColor)
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
        case .color: return .color
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
            // 保留最0-3位小数
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 3
            let xStr = formatter.string(from: NSNumber(value: x)) ?? ""
            let yStr = formatter.string(from: NSNumber(value: y)) ?? ""
            return "(\(xStr),\(yStr))"
        case let .location(latitude, longitude):
            let latitudeStr = ALatitude(latitude).toDM()
            let longitudeStr = ALongitude(longitude).toDM()
            return "\(latitudeStr) \(longitudeStr)"
        case let .boolean(value):
            return value ? "Yes" : "No"
        case let .string(value):
            return "`\(value)`".replacingOccurrences(of: "\n", with: "↵")
        case let .groundWind(limit):
            return "\(limit)"
        case let .minutes(value):
            let result = AHourMinuteValue(minutes: value).toFormat(.hourMinute).description
            guard result != "" else { return "00:00" }
            return result
        case let .calendar(date, timeZone):
            return ADateAndTZ(date: date, timeZone: timeZone).description
        // Fix in description property
        case let .dateDifference(components):
            let result = "\(components)"
            guard result != "" else { return "No Diff" }
            return result
        case let .color(color):
            // 将 RGB 值转换为 0-255 的整数并格式化为十六进制
            let rInt = Int(color.red * 255)
            let gInt = Int(color.green * 255)
            let bInt = Int(color.blue * 255)
            let alphaInt = Int(color.alpha * 255)
            let hexString = String(format: "#%02X%02X%02X%02X", rInt, gInt, bInt, alphaInt)
            return hexString
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
        case let (.calendar(value1, timezone), .minutes(value2)):
            return try addMinutes(to: value1, minutes: value2, timeZone: timezone)
        case let (.minutes(value1), .calendar(value2, timezone)):
            return try addMinutes(to: value2, minutes: value1, timeZone: timezone)
        case let (.calendar(value1, timezone), .dateDifference(value2)):
            return try addDateDifference(to: value1, difference: value2, timeZone: timezone)
        case let (.dateDifference(value1), .calendar(value2, timezone)):
            return try addDateDifference(to: value2, difference: value1, timeZone: timezone)
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable private func addMinutes(to calendarValue: Date, minutes: Int, timeZone: TimeZone?)
        throws -> AValue
    {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: minutes, to: calendarValue)
        else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate, timeZone: timeZone)
    }

    @Sendable private func addDateDifference(
        to calendarValue: Date, difference: DateComponents, timeZone: TimeZone?
    ) throws -> AValue {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: difference, to: calendarValue) else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate, timeZone: timeZone)
    }

    @Sendable func subtract(_ value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.number(value1), .number(value2)):
            return .number(value1 - value2)
        case let (.point(x1, y1), .point(x2, y2)):
            return .point(x: x1 - x2, y: y1 - y2)
        case let (.minutes(value1), .minutes(value2)):
            return .minutes(value1 - value2)
        case let (.calendar(value1, timezone), .minutes(value2)):
            return try subtractMinutes(from: value1, minutes: value2, timeZone: timezone)
        case let (.calendar(value1, timezone), .dateDifference(value2)):
            return try subtractDateDifference(from: value1, difference: value2, timeZone: timezone)
        case let (.dateDifference(value1), .calendar(value2, timezone)):
            return try subtractDateDifference(from: value2, difference: value1, timeZone: timezone)
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable private func subtractMinutes(
        from calendarValue: Date, minutes: Int, timeZone: TimeZone?
    ) throws -> AValue {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .minute, value: -minutes, to: calendarValue)
        else {
            throw AValueError.invalidOperation
        }
        return .calendar(newDate, timeZone: timeZone)
    }

    @Sendable private func subtractDateDifference(
        from calendarValue: Date, difference: DateComponents, timeZone: TimeZone?
    ) throws -> AValue {
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
        return .calendar(newDate, timeZone: timeZone)
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
        case (.color, .color):
            return try colorMultiply(value)
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
        case let (.calendar(value1, _), .calendar(value2, _)):
            return value1 > value2
        default:
            throw AValueError.comparisonError
        }
    }

    @Sendable func isGreaterOrEqual(to value: AValue) throws -> Bool {
        try isGreater(than: value) || self == value
    }

    @Sendable func isLess(than value: AValue) throws -> Bool {
        try !isGreaterOrEqual(to: value)
    }

    @Sendable func isLessThanOrEqual(to value: AValue) throws -> Bool {
        try !isGreater(than: value)
    }

    /// 为这个 `AValue` 取负值
    ///
    /// - Returns: 取负结果作为一个新的 `AValue` 返回
    /// - Throws: 如果操作无效，则抛出 `AValueCalcError`
    @Sendable func negative() throws -> AValue {
        // Fix in negative() function
        switch self {
        case let .number(value):
            return .number(-value)
        case let .point(x, y):
            return .point(x: -x, y: -y)
        case let .minutes(value):
            return .minutes(-value)
        case let .color(color):
            // 颜色取反: (1 - r, 1 - g, 1 - b)
            return .color(color: AColor(colorSpace: color.colorSpace, red: 1 - color.red, green: 1 - color.green, blue: 1 - color.blue, alpha: color.alpha))
        default:
            throw AValueError.invalidOperation
        }
    }

    @Sendable func groundWindComponents() throws -> AWindLimit {
        if case let .groundWind(limit) = self {
            return limit
        } else {
            throw AValueError.typeMismatch(expected: .groundWind, actual: type)
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

    // Fix in colorMultiply() function
    @Sendable func colorMultiply(_ value: AValue) throws -> AValue {
        switch (self, value) {
        case let (.color(color1), .color(color2)):
            // 直接对 RGB 相乘，alpha 也可相乘
            let space = color1.colorSpace == color2.colorSpace ? color1.colorSpace : .sRGB
            return .color(color: AColor(
                colorSpace: space,
                red: color1.red * color2.red,
                green: color1.green * color2.green,
                blue: color1.blue * color2.blue,
                alpha: color1.alpha * color2.alpha
            ))
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
    func getCalendar() -> ADateAndTZ? {
        guard case let .calendar(date, timeZone) = self else {
            return nil
        }
        return ADateAndTZ(date: date, timeZone: timeZone)
    }

    /// Extracts the DateComponents value if the AValue is of type `.dateDifference`
    func getDateDifference() -> DateComponents? {
        guard case let .dateDifference(components) = self else {
            return nil
        }
        return components
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension AValue {
    func formatted(precision: NumberFormatStyleConfiguration.Precision) -> String {
        let format: FloatingPointFormatStyle<Double> = .number.precision(precision).grouping(.never)
        switch self {
        case let .number(double):
            return double.formatted(format)
        case let .point(x, y):
            return "(\(x.formatted(format)), \(y.formatted(format)))"
        case let .location(latitude, longitude):
            return latitude.formatted(ALatitudeFormat.dM(digits: 1))
                + longitude.formatted(ALongitudeFormat.dM(digits: 1))
        case let .boolean(bool):
            return bool ? "✓" : "x"
        case .string, .groundWind, .minutes, .calendar, .dateDifference, .color:
            return description
        }
    }
}

#if os(macOS) || os(iOS)

    @available(iOS 14.0, macOS 11, *)
    public extension AValue {
        func getColor() -> Color? {
            guard case let .color(color) = self else {
                return nil
            }
            return color.original
        }

        init?(color: Color?) {
            guard let colorValue = AColor(color)
            else { return nil }
            self = .color(color: colorValue)
        }
    }

#endif
