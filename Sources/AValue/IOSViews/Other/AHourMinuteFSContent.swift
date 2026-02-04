import AViewUI
import SwiftUI

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AHourMinuteFSContent: View {
    @Binding var value: Int?
    var name: String
    var allowSet: Bool

    @FocusState private var isFocused
    @Environment(\.dismiss) private var dismiss

    @State private var format: AHourMinuteValue.Format = .hourMinute

    public var body: some View {
        Group {
            if allowSet {
                #if os(iOS)
                ACustomKeyboardOptionalFormatField(
                    name,
                    value: $value,
                    format: AHMFormat(format: format),
                    focused: Binding(
                        get: { isFocused },
                        set: { isFocused = $0 }
                    )
                ) { context, _ in
                    AHMKeyboard(context, format: $format)
                        .frame(height: 260)
                }
                .font(.largeTitle)
                .submitLabel(.done)
                .onSubmit {
                    dismiss()
                }
                #else
                TextField(name, value: $value, format: AHMFormat(format: format))
                    .font(.largeTitle)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        dismiss()
                    }
                #endif

            } else if let value = value {
                Text(value, format: AHMFormat(format: format))
                    .font(.largeTitle)
            } else {
                Text("-")
                    .font(.largeTitle)
            }
        }
        .padding()
        .onAppear {
            isFocused = true
        }
    }

    public init(_ valueBinding: Binding<Int?>, name: String, allowSet: Bool) {
        self._value = valueBinding
        self.name = name
        self.allowSet = allowSet
    }

    public init(aValue valueBinding: Binding<AValue?>, name: String, allowSet: Bool) {
        self._value = valueBinding.minutesValue()
        self.name = name
        self.allowSet = allowSet
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var aValue: AValue? = 45

    var body: some View {
        List {
            AHourMinuteFSContent(aValue: $aValue, name: "hello", allowSet: true)
            AHourMinuteFSContent(aValue: $aValue, name: "hello", allowSet: false)
        }
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
