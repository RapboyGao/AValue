
import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct AValueColorLabel: View {
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

    public init(_ value: Binding<AValue?>) {
        self._color = Binding {
            value.wrappedValue?.getColor() ?? .clear
        } set: { newColor in
            value.wrappedValue = .init(color: newColor)
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private struct Example: View {
    @State var color: AValue?
    var body: some View {
        List {
            AValueColorLabel($color)
        }
    }
}

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
#Preview {
    Example()
}
