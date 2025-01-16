import Foundation
import SwiftUI

public enum AColorSpace: Hashable, Sendable, Codable, Identifiable {
    /// The extended red, green, blue (sRGB) color space.
    ///
    /// For information about the sRGB colorimetry and nonlinear
    /// transform function, see the IEC 61966-2-1 specification.
    ///
    /// Standard sRGB color spaces clamp the red, green, and blue
    /// components of a color to a range of `0` to `1`, but SwiftUI colors
    /// use an extended sRGB color space, so you can use component values
    /// outside that range.
    case sRGB

    /// The extended sRGB color space with a linear transfer function.
    ///
    /// This color space has the same colorimetry as ``sRGB``, but uses
    /// a linear transfer function.
    ///
    /// Standard sRGB color spaces clamp the red, green, and blue
    /// components of a color to a range of `0` to `1`, but SwiftUI colors
    /// use an extended sRGB color space, so you can use component values
    /// outside that range.
    case sRGBLinear

    /// The Display P3 color space.
    ///
    /// This color space uses the Digital Cinema Initiatives - Protocol 3
    /// (DCI-P3) primary colors, a D65 white point, and the ``sRGB``
    /// transfer function.
    case displayP3

    public var id: AColorSpace {
        self
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension AColorSpace {
    var original: Color.RGBColorSpace {
        switch self {
        case .sRGB:
            return .sRGB
        case .sRGBLinear:
            return .sRGBLinear
        case .displayP3:
            return .displayP3
        }
    }

    init(_ colorSpace: Color.RGBColorSpace) {
        switch colorSpace {
        case .sRGB:
            self = .sRGB
        case .sRGBLinear:
            self = .sRGBLinear
        case .displayP3:
            self = .displayP3
        @unknown default:
            self = .sRGB
        }
    }
}
