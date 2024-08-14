import SwiftUI

/// `AValueType` 是一个表示 `AValue` 可以持有的值类型的枚举
enum AValueType: Codable, Hashable, Sendable, CaseIterable {
    /// 表示一个数值类型
    case number

    /// 表示一个具有 X 和 Y 坐标的点类型
    case point

    /// 表示一个具有纬度和经度的地理位置类型
    case location

    /// 表示一个布尔值类型
    case boolean

    /// 表示一个字符串类型
    case string

    /// 表示一个具有AWindLimit组件的地面风类型
    case groundWind

    /// 表示以分钟为单位的持续时间类型
    case minutes

    /// 表示一个以日历时间形式的特定日期类型
    case calendar

    /// 表示两个日期之间的差异（以时间戳形式）类型
    case dateDifference

    func randomValue() -> AValue {
        switch self {
        case .number:
            return .number(Double.random(in: -1000.0...1000.0))
        case .point:
            let x = Double.random(in: -1000.0...1000.0)
            let y = Double.random(in: -1000.0...1000.0)
            return .point(x: x, y: y)
        case .location:
            let latitude = Double.random(in: -90.0...90.0)
            let longitude = Double.random(in: -180.0...180.0)
            return .location(latitude: latitude, longitude: longitude)
        case .boolean:
            return .boolean(Bool.random())
        case .string:
            let randomString = UUID().uuidString
            return .string(randomString)
        case .groundWind:
            let limit = AWindLimit(headWind: Double.random(in: 0...50),
                                   tailWind: Double.random(in: 0...50),
                                   crossWind: Double.random(in: 0...50))
            return .groundWind(limit: limit)
        case .minutes:
            return .minutes(Int.random(in: 0...1440)) // Random value within 24 hours
        case .calendar:
            let randomTimeInterval = TimeInterval.random(in: -1000000000...1000000000)
            let randomDate = Date(timeIntervalSince1970: randomTimeInterval)
            return .calendar(randomDate)
        case .dateDifference:
            let components = DateComponents(year: Int.random(in: -10...10),
                                            month: Int.random(in: -12...12),
                                            day: Int.random(in: -31...31),
                                            hour: Int.random(in: -23...23),
                                            minute: Int.random(in: -59...59),
                                            second: Int.random(in: -59...59))
            return .dateDifference(components)
        }
    }

    var symbolName: String {
        switch self {
        case .number:
            return "number"
        case .point:
            return "chart.xyaxis.line"
        case .location:
            return "location"
        case .boolean:
            return "switch.2"
        case .string:
            return "textformat"
        case .groundWind:
            return "tropicalstorm"
        case .minutes:
            return "clock"
        case .calendar:
            return "calendar"
        case .dateDifference:
            return "calendar.badge.minus"
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func colorForLightTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 0.188, green: 0.498, blue: 0.0)
        case .point, .location, .groundWind, .minutes, .calendar, .dateDifference:
            return Color(red: 0.424, green: 0.215, blue: 0.541)
        case .string:
            return Color(red: 0.75, green: 0.52, blue: 0.045)
        case .boolean:
            return Color(red: 0.0, green: 0.502, blue: 0.502)
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    func colorForDarkTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 0.866, green: 0.866, blue: 0.586) // Light Yellow
        case .point, .location, .groundWind, .minutes, .calendar, .dateDifference:
            return Color(red: 0.729, green: 0.549, blue: 0.788) // Plum
        case .string:
            return Color(red: 0.568, green: 0.78, blue: 0.482) // Light Green
        case .boolean:
            return Color(red: 0.627, green: 0.886, blue: 0.886) // Light Teal
        }
    }
}
