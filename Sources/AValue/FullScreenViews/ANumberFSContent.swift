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
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    ANumberFSContent(value: .constant(50), name: "hello", allowSet: true)
}
