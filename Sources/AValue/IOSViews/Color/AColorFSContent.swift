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

@available(iOS 14, tvOS 14, watchOS 7, *)
private struct Example: View {
    @State private var color: Color? = nil
    
    var body: some View {
        AColorFSContent($color)
    }
}

@available(iOS 14, tvOS 14, watchOS 7, *)
#Preview {
    Example()
}
#endif
