import Foundation

public struct AColor: Codable, Sendable, Hashable, CustomStringConvertible {
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
            guard let newColor = AColor(newValue)
            else { return }
            self = newColor
        }
    }
    
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
    public var solidColor: Color {
        get {
            Color(colorSpace.original, red: red, green: green, blue: blue)
        }
        set {
            guard let newColor = AColor(newValue)
            else { return }
            // 保留当前的alpha值，只更新RGB值
            let currentAlpha = alpha
            self = newColor
            alpha = currentAlpha
        }
    }
    
    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    public init?(_ color: Color?) {
        guard let color = color else {
            return nil
        }
        
#if canImport(UIKit)
        self.init(fromUIColor: UIColor(color))
#elseif canImport(AppKit)
        self.init(fromNSColor: NSColor(color))
#elseif canImport(CoreGraphics) && canImport(SwiftUI)
        self.init(fromCGColor: color.cgColor)
#else
        return nil
#endif
    }
    
// UIKit平台专用初始化方法
#if canImport(UIKit)
    @available(iOS 14, tvOS 14, watchOS 7, *)
    public init?(fromUIColor uiColor: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // 尝试获取RGB组件
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // 尝试将颜色转换为RGB颜色空间
            if let rgbColor = uiColor.cgColor.converted(
                to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
            {
                if let components = rgbColor.components, components.count >= 4 {
                    r = CGFloat(components[0])
                    g = CGFloat(components[1])
                    b = CGFloat(components[2])
                    a = CGFloat(components[3])
                } else {
                    return nil
                }
            }
            return nil
        }
        
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.alpha = Double(a)
        
        // 尝试找到匹配的颜色空间
        for myColorSpace in AColorSpace.allCases {
            let someColor = Color(myColorSpace.original, red: r, green: g, blue: b, opacity: a)
            if someColor == Color(uiColor) {
                self.colorSpace = myColorSpace
                return
            }
        }
        
        // 如果找不到匹配的颜色空间，使用默认的sRGB
        self.colorSpace = .sRGB
    }
#endif
    
// AppKit平台专用初始化方法
#if canImport(AppKit)
    @available(macOS 11, *)
    public init?(fromNSColor nsColor: NSColor) {
        let converted = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
        let r = converted.redComponent
        let g = converted.greenComponent
        let b = converted.blueComponent
        let a = converted.alphaComponent
        
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.alpha = Double(a)
        
        // 尝试找到匹配的颜色空间
        for myColorSpace in AColorSpace.allCases {
            let someColor = Color(myColorSpace.original, red: r, green: g, blue: b, opacity: a)
            if someColor == Color(nsColor) {
                self.colorSpace = myColorSpace
                return
            }
        }
        
        // 如果找不到匹配的颜色空间，使用默认的sRGB
        self.colorSpace = .sRGB
    }
#endif
    
// CoreGraphics+SwiftUI平台专用初始化方法
#if canImport(CoreGraphics) && canImport(SwiftUI)
    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    public init?(fromCGColor cgColor: CGColor?) {
        guard let cgColor = cgColor else {
            return nil
        }
        
        if let components = cgColor.components, components.count >= 3 {
            self.red = Double(components[0])
            self.green = Double(components[1])
            self.blue = Double(components[2])
            self.alpha = components.count >= 4 ? Double(components[3]) : 1.0
            self.colorSpace = .sRGB
            return
        }
        
        return nil
    }
    
#endif
    
    public init(colorSpace: AColorSpace, red: Double, green: Double, blue: Double, alpha: Double) {
        self.colorSpace = colorSpace
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public var description: String {
        // Convert color components from Double (0.0-1.0) to UInt8 (0-255)
        let r = UInt8(clamping: Int(red * 255.0))
        let g = UInt8(clamping: Int(green * 255.0))
        let b = UInt8(clamping: Int(blue * 255.0))
        let a = UInt8(clamping: Int(alpha * 255.0))
        
        // Format as hexadecimal string in the format #RRGGBBAA
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
    
    // Calculate relative luminance based on WCAG formula
    private var relativeLuminance: Double {
        // Normalize RGB values using gamma correction
        func adjust(_ value: Double) -> Double {
            return value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        
        let r = adjust(red)
        let g = adjust(green)
        let b = adjust(blue)
        
        // Apply standard coefficients for relative luminance
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    // Calculate contrast ratio between two colors
    private func contrastRatio(with otherLuminance: Double) -> Double {
        let luminance1 = max(relativeLuminance, otherLuminance)
        let luminance2 = min(relativeLuminance, otherLuminance)
        
        // WCAG contrast ratio formula
        return (luminance1 + 0.05) / (luminance2 + 0.05)
    }
    
    // Boolean indicating if color is hard to see in dark mode (against black background)
    public var isHardToSeeInDarkMode: Bool {
        // Black has relative luminance of 0
        let contrast = contrastRatio(with: 0.0)
        // WCAG AA standard requires minimum contrast of 4.5:1 for normal text
        return contrast < 4.5
    }
    
    // Boolean indicating if color is hard to see in light mode (against white background)
    public var isHardToSeeInLightMode: Bool {
        // White has relative luminance of 1
        let contrast = contrastRatio(with: 1.0)
        // WCAG AA standard requires minimum contrast of 4.5:1 for normal text
        return contrast < 4.5
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public func attributedString(for colorScheme: ColorScheme) -> AttributedString {
        var string = AttributedString(description)
        string.foregroundColor = solidColor
        switch colorScheme {
        case .dark:
            if isHardToSeeInDarkMode {
                string.backgroundColor = .white.opacity(0.7)
            }
        case .light:
            if isHardToSeeInLightMode {
                string.backgroundColor = .black.opacity(0.7)
            }
        @unknown default:
            break
        }
        return string
    }
}
