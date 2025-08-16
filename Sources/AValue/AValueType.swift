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

    /// 表示一个颜色类型
    case color

    public var id: Self {
        self
    }

    public var name: String {
        I18n.name(for: self)
    }

    public var introduction: String {
        I18n.introduction(for: self)
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
        case .color:
            return .color(color: AColor(colorSpace: .sRGB, red: 0, green: 0, blue: 0, alpha: 1))
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
        case .color:
            return .color(color: AColor(
                colorSpace: .sRGB,
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1),
                alpha: 1
            ))
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
        case .color:
            return "paintbrush"
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func colorForLightTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 25.0/255.0, green: 118.0/255.0, blue: 210.0/255.0) // Material Blue 700
        case .point:
            return Color(red: 0.0/255.0, green: 150.0/255.0, blue: 136.0/255.0) // Material Teal 500
        case .location:
            return Color(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0) // Material Green 500
        case .boolean:
            return Color(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0) // Material Red 500
        case .string:
            return Color(red: 156.0/255.0, green: 39.0/255.0, blue: 176.0/255.0) // Material Purple 500
        case .groundWind:
            return Color(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0) // Material Gray 600
        case .minutes:
            return Color(red: 255.0/255.0, green: 193.0/255.0, blue: 7.0/255.0) // Material Amber 500
        case .calendar:
            return Color(red: 205.0/255.0, green: 127.0/255.0, blue: 50.0/255.0) // Material Brown 500
        case .dateDifference:
            return Color(red: 103.0/255.0, green: 58.0/255.0, blue: 183.0/255.0) // Material Deep Purple 500
        case .color:
            return Color(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0) // Material Gray 900
        }
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func colorForDarkTheme() -> Color {
        switch self {
        case .number:
            return Color(red: 144.0/255.0, green: 202.0/255.0, blue: 249.0/255.0) // Material Blue 200
        case .point:
            return Color(red: 100.0/255.0, green: 221.0/255.0, blue: 23.0/255.0) // Material Teal 200
        case .location:
            return Color(red: 165.0/255.0, green: 214.0/255.0, blue: 167.0/255.0) // Material Green 200
        case .boolean:
            return Color(red: 239.0/255.0, green: 154.0/255.0, blue: 154.0/255.0) // Material Red 200
        case .string:
            return Color(red: 206.0/255.0, green: 147.0/255.0, blue: 216.0/255.0) // Material Purple 200
        case .groundWind:
            return Color(red: 189.0/255.0, green: 189.0/255.0, blue: 189.0/255.0) // Material Gray 300
        case .minutes:
            return Color(red: 255.0/255.0, green: 224.0/255.0, blue: 130.0/255.0) // Material Amber 200
        case .calendar:
            return Color(red: 215.0/255.0, green: 204.0/255.0, blue: 200.0/255.0) // Material Brown 200
        case .dateDifference:
            return Color(red: 179.0/255.0, green: 157.0/255.0, blue: 219.0/255.0) // Material Deep Purple 200
        case .color:
            return Color(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0) // Material Gray 100
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
