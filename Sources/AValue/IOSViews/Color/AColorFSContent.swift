import AViewUI
import SwiftUI
import UIKit

#if canImport(UIKit)
@available(iOS 14, tvOS 14, watchOS 7, *)
public struct AColorFSContent: View {
    @Binding var color: UIColor?

    public var body: some View {
        AColorPickerView(color: $color, defaultColor: UIColor(Color.accentColor)) { newColor in
            color = newColor
        }
    }

    public init(_ color: Binding<UIColor?>?) {
        if let colorBinding = color {
            self._color = colorBinding
        } else {
            // 默认值
            self._color = .constant(nil)
        }
    }

    public init(_ color: Binding<Color?>) {
        self._color = Binding {
            color.wrappedValue.map { UIColor($0) }
        } set: {
            color.wrappedValue = $0.map { Color($0) }
        }
    }

    public init(_ value: Binding<AValue?>) {
        self._color = Binding {
            value.wrappedValue?.getColor().map { UIColor($0) }
        } set: {
            value.wrappedValue = $0.flatMap { AValue(color: Color($0)) }
        }
    }
}

#endif

#if canImport(UIKit) && DEBUG

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
private struct Example: View {
    @State private var color: UIColor? = nil

    @Environment(\.colorScheme) private var colorScheme

    var aColor: AColor? {
        color.flatMap { AColor(Color($0)) }
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
