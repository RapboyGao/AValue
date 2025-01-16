
import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AColorFSContent: View {
    @Binding var color: Color

    public var body: some View {
        ColorPicker("Color", selection: $color, supportsOpacity: true)
            .labelsHidden()
    }

    public init(_ color: Binding<Color>) {
        self._color = color
    }

    public init(_ color: Binding<Color?>) {
        self._color = Binding {
            color.wrappedValue ?? .clear
        } set: { newColor in
            color.wrappedValue = newColor
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct Example: View {
    @State var color: Color?
    var body: some View {
        List {
            AColorFSContent($color)
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
#Preview {
    Example()
}
