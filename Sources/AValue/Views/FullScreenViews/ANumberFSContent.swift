import AViewUI
import SwiftUI

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ANumberFSContent: View {
    @Binding var value: Double?
    var name: String
    var allowSet: Bool

    @FocusState private var isFocused
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        Group {
            if allowSet {
                TextField(name, value: $value, format: AMathFormatStyle.fractionLength(20))
                #if os(iOS)
                    .aKeyboardView { uiTextField in
                        AMathExpressionKeyboard(uiTextField, AMathFormatStyle.fractionLength(20))
                    }
                #endif
                    .font(.largeTitle)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        dismiss()
                    }

            } else if let value = value {
                Text(value, format: .number.precision(.significantDigits(0 ... 10)))
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

    public init(_ valueBinding: Binding<Double?>, name: String, allowSet: Bool) {
        self._value = valueBinding
        self.name = name
        self.allowSet = allowSet
    }

    public init(aValue valueBinding: Binding<AValue?>, name: String, allowSet: Bool) {
        self._value = valueBinding.doubleValue()
        self.name = name
        self.allowSet = allowSet
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct Example: View {
    @State private var aValue: AValue? = 45

    var body: some View {
        ANumberFSContent(aValue: $aValue, name: "hello", allowSet: true)
    }
}

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    Example()
}
