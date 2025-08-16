import Foundation

public struct AColor: Codable, Sendable, Hashable {
    public var colorSpace: AColorSpace
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double

    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
    public var original: Color {
        get {
            Color(colorSpace.original, red: red, green: green, blue: blue, opacity: alpha)
        }
        set {
            let color = newValue
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            #if canImport(UIKit)
                let uiColor = UIColor(color)
                uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
                red = r
                green = g
                blue = b
                alpha = a
                for myColorSpace in AColorSpace.allCases {
                    let someColor = Color(
                        myColorSpace.original, red: r, green: g, blue: b, opacity: a)
                    guard someColor == color else {
                        continue
                    }
                    colorSpace = myColorSpace
                }
            #elseif canImport(AppKit)
                let nsColor = NSColor(color)
                let converted = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
                r = converted.redComponent
                g = converted.greenComponent
                b = converted.blueComponent
                a = converted.alphaComponent
                red = r
                green = g
                blue = b
                alpha = a
                for myColorSpace in AColorSpace.allCases {
                    let someColor = Color(
                        myColorSpace.original, red: r, green: g, blue: b, opacity: a)
                    guard someColor == color else {
                        continue
                    }
                    colorSpace = myColorSpace
                    return
                }
            #else
                // 没有可用的 UIKit 或 AppKit，仅使用默认
            #endif
        }
    }

    public init(colorSpace: AColorSpace, red: Double, green: Double, blue: Double, alpha: Double) {
        self.colorSpace = colorSpace
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
