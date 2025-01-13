import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ABoolFSContent: View {
    @Binding var value: Bool?

    private var systemName: String {
        if value == true {
            return "checkmark"
        } else if value == false {
            return "xmark"
        } else {
            return "questionmark"
        }
    }

    private var thisColor: Color {
        if value == true {
            return .green
        } else if value == false {
            return .orange
        } else {
            return .gray
        }
    }

    private var bindBool: Binding<Bool> {
        Binding {
            value == true
        } set: {
            value = $0
        }
    }

    private var clickGesture: some Gesture {
        TapGesture().onEnded {
            withAnimation {
                value = value == true ? false : true
            }
        }
    }

    public var body: some View {
        Toggle(isOn: bindBool) {
            Image(systemName: systemName)
        }
        .toggleStyle(.switch)
        .labelsHidden()
        .scaleEffect(4)
        .rotationEffect(.degrees(-90))
    }

    public init(_ value: Binding<Bool?>) {
        self._value = value
    }

    public init(_ value: Binding<AValue?>) {
        self._value = value.booleanValue()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State var value: Bool?

    var body: some View {
        ABoolFSContent($value)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
