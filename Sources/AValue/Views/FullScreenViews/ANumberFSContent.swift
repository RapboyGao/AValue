import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ANumberFSContent: View {
    @Binding var value: Double?
    var name: String
    var allowSet: Bool

    @FocusState private var isFocused

    public var body: some View {
        Group {
            if allowSet {
                TextField(name, value: $value, format: .number.precision(.significantDigits(0 ... 10)))
                    .focused($isFocused)
                    .modifier(NumberKeyboardModifier(value: $value, digits: 10))
            } else if let value = value {
                Text(value, format: .number.precision(.significantDigits(0 ... 10)))
            } else {
                Text("-")
            }
        }
        .font(.largeTitle)
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

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    ANumberFSContent(.constant(-50), name: "hello", allowSet: true)
}
