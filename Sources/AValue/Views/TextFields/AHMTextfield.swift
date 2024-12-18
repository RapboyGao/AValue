import SwiftUI

#if os(iOS)

@available(iOS 16, *)
public struct AHMTextfield: View {
    @Binding var value: Int?
    @State var format: AHourMinuteValue.Format = .hourMinute
    var allowSet: Bool
    var placeholder: String

    public var body: some View {
        TextField(placeholder, value: $value, format: AHMFormat(format: format))
            .aKeyboardView { uiTextfield in
                AHMKeyboard(uiTextfield, format: $format)
            }
    }

    public init(_ value: Binding<Int?>, allowSet: Bool, placeholder: String) {
        self._value = value
        self.allowSet = allowSet
        self.placeholder = placeholder
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool, placeholder: String) {
        self._value = value.minutesValue()
        self.allowSet = allowSet
        self.placeholder = placeholder
    }
}

@available(iOS 16, *)

private struct Example: View {
    @State var value: Int?
    var body: some View {
        AHMTextfield($value, allowSet: true, placeholder: "Time")
    }
}

@available(iOS 16, *)
#Preview {
    List {
        Example()
    }
}

#endif
