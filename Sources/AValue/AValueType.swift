import SwiftUI

/// `AValueType` 是一个表示 `AValue` 可以持有的值类型的枚举
public enum AValueType: String, RawRepresentable, Codable, Hashable, Sendable, CaseIterable, Identifiable {
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

    public var id: Self {
        self
    }

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
            return .calendar(.init(timeIntervalSinceNow: 0), timeZone: .current)
        case .dateDifference:
            return .dateDifference(.init())
        }
    }

    public func randomValue() -> AValue {
        switch self {
        case .number:
            return .number(.random(in: -10000 ... 10000))
        case .point:
            return .point(x: .random(in: -10000 ... 10000), y: .random(in: -10000 ... 10000))
        case .location:
            return .location(latitude: .random(in: -90 ..< 90), longitude: .random(in: -180 ..< 180))
        case .boolean:
            return .boolean(.random())
        case .string:
            // create a random string
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return .string(String((0 ..< 10).map { _ in letters.randomElement() ?? "a" }))
        case .groundWind:
            return .groundWind(limit: .b737)
        case .minutes:
            return .minutes(.random(in: -10000 ..< 10000))
        case .calendar:
            // create a random date
            return .calendar(.init(timeIntervalSinceNow: .random(in: -10000 ..< 10000)), timeZone: .current)
        case .dateDifference:
            // create a random date component
            let dateComponent = DateComponents(
                year: .random(in: -10000 ..< 10000),
                month: .random(in: -10000 ..< 10000),
                day: .random(in: -10000 ..< 10000),
                hour: .random(in: -10000 ..< 10000),
                minute: .random(in: -10000 ..< 10000),
                second: .random(in: -10000 ..< 10000)
            )
            return .dateDifference(dateComponent)
        }
    }

    public var symbolName: String {
        switch self {
        case .number:
            return "numbersign"
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
            return Color(red: 0.0, green: 0.0, blue: 0.5) // Navy Blue
        case .point:
            return Color(red: 0.0, green: 0.5, blue: 0.5) // Teal
        case .location:
            return Color(red: 0.0, green: 0.5, blue: 0.0) // Dark Green
        case .boolean:
            return Color(red: 0.5, green: 0.0, blue: 0.0) // Maroon
        case .string:
            return Color(red: 0.5, green: 0.0, blue: 0.5) // Purple
        case .groundWind:
            return Color(red: 0.3, green: 0.3, blue: 0.3) // Dark Gray
        case .minutes:
            return Color(red: 0.5, green: 0.5, blue: 0.0) // Olive
        case .calendar:
            return Color(red: 0.5, green: 0.25, blue: 0.0) // Brown
        case .dateDifference:
            return Color(red: 0.25, green: 0.0, blue: 0.5) // Indigo
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func colorForDarkTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 0.529, green: 0.808, blue: 0.922) // Sky Blue
        case .point:
            return Color(red: 0.678, green: 0.847, blue: 0.902) // Light Blue
        case .location:
            return Color(red: 0.498, green: 1.0, blue: 0.831) // Aquamarine
        case .boolean:
            return Color(red: 0.0, green: 1.0, blue: 0.0) // Lime
        case .string:
            return Color(red: 1.0, green: 0.647, blue: 0.0) // Orange
        case .groundWind:
            return Color(red: 1.0, green: 0.0, blue: 0.0) // Bright Red
        case .minutes:
            return Color(red: 0.933, green: 0.510, blue: 0.933) // Violet
        case .calendar:
            return Color(red: 1.0, green: 0.894, blue: 0.710) // Peach
        case .dateDifference:
            return Color(red: 0.627, green: 0.125, blue: 0.941) // Blue Violet
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func color(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return colorForLightTheme()
        case .dark:
            return colorForDarkTheme()
        @unknown default:
            return colorForLightTheme()
        }
    }
}
