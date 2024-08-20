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
            return .calendar(.init(timeIntervalSinceNow: 0))
        case .dateDifference:
            return .dateDifference(.init())
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
            return Color(red: 0.255, green: 0.412, blue: 0.882) // Royal Blue
        case .point:
            return Color(red: 0.678, green: 0.847, blue: 0.902) // Light Blue
        case .location:
            return Color(red: 0.125, green: 0.698, blue: 0.667) // Teal
        case .boolean:
            return Color(red: 0.0, green: 0.502, blue: 0.0) // Green
        case .string:
            return Color(red: 0.8, green: 0.4, blue: 0.0) // Dark Orange
        case .groundWind:
            return Color(red: 0.545, green: 0.0, blue: 0.0) // Dark Red
        case .minutes:
            return Color(red: 0.933, green: 0.510, blue: 0.933) // Violet
        case .calendar:
            return Color(red: 0.870, green: 0.721, blue: 0.529) // Tan
        case .dateDifference:
            return Color(red: 0.502, green: 0.0, blue: 0.502) // Purple
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func colorForDarkTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 0.678, green: 0.847, blue: 0.902) // Light Blue
        case .point:
            return Color(red: 0.392, green: 0.584, blue: 0.929) // Cornflower Blue
        case .location:
            return Color(red: 0.372, green: 0.619, blue: 0.627) // Cadet Blue
        case .boolean:
            return Color(red: 0.196, green: 0.804, blue: 0.196) // Lime Green
        case .string:
            return Color(red: 0.914, green: 0.588, blue: 0.478) // Coral
        case .groundWind:
            return Color(red: 0.8, green: 0.0, blue: 0.0) // Red
        case .minutes:
            return Color(red: 0.678, green: 0.282, blue: 0.847) // Medium Purple
        case .calendar:
            return Color(red: 0.588, green: 0.439, blue: 0.294) // Sienna
        case .dateDifference:
            return Color(red: 0.627, green: 0.125, blue: 0.941) // Blue Violet
        }
    }
}
