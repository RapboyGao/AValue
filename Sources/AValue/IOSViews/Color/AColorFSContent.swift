import AViewUI
import SwiftUI

#if canImport(UIKit)
@available(iOS 14, tvOS 14, watchOS 7, *)
public struct AColorFSContent: View {
    @Binding var color: Color?

    public var body: some View {
        AColorPickerView(color: $color, defaultColor: .accentColor) { newColor in
            color = newColor
        }
    }

    public init(_ color: Binding<Color?>) {
        self._color = color
    }

    public init(_ value: Binding<AValue?>) {
        _color = value.colorValue()
    }
}

#endif

#if canImport(UIKit) && DEBUG

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private struct Example: View {
    @State private var color: Color? = nil

    @Environment(\.colorScheme) private var colorScheme

    var aColor: AColor? {
        AColor(color)
    }

    var body: some View {
        VStack {
            AColorFSContent($color)
            if let aColor {
                Text(aColor.attributedString(for: colorScheme))
                Text("\(aColor.colorSpace)")
            }
        }
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
#Preview {
    Example()
}
#endif
