import SwiftUI

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ATextFSContent: View {
    @Binding private var string: String
    var allowSet: Bool

    @FocusState private var isFocused: Bool

    public var body: some View {
        List {
            if allowSet {
                TextEditor(text: $string)
                    .frame(minHeight: 150)
                    .focused($isFocused)
            } else {
                Text(string)
            }
        }
        .onAppear {
            isFocused = true
        }
    }

    public init(_ string: Binding<String>, allowSet: Bool) {
        self._string = string
        self.allowSet = allowSet
    }

    public init(_ value: Binding<AValue?>, allowSet: Bool) {
        self._string = Binding {
            value.wrappedValue?.getString() ?? ""
        } set: { newString in
            value.wrappedValue = .string(newString)
        }
        self.allowSet = allowSet
    }
}
