import SwiftUI

/// `AValueType` 是一个表示 `AValue` 可以持有的值类型的枚举
public enum AValueType: String, RawRepresentable, Codable, Hashable, Sendable, CaseIterable {
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

    public func baseValue() -> AValue {
        switch self {
        case .number:
            return 0
        case .point:
            return .point(x: 0, y: 0)
        case .location:
            return .location(latitude: 0, longitude: 0)
        case .boolean:
            return .boolean(true)
        case .string:
            return .string("")
        case .groundWind:
            return .groundWind(limit: .b737)
        case .minutes:
            return .minutes(0)
        case .calendar:
            return .calendar(.init(timeIntervalSinceNow: 0))
        case .dateDifference:
            return .dateDifference(.init())
        }
    }

    public var symbolName: String {
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
    public func colorForLightTheme() -> Color {
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
    public func colorForDarkTheme() -> Color {
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
